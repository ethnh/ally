import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mutex/mutex.dart';

import '../../veilid_support.dart';

part 'dht_record_pool.freezed.dart';
part 'dht_record_pool.g.dart';

/// Record pool that managed DHTRecords and allows for tagged deletion
@freezed
class DHTRecordPoolAllocations with _$DHTRecordPoolAllocations {
  const factory DHTRecordPoolAllocations({
    required IMap<String, ISet<TypedKey>>
        childrenByParent, // String key due to IMap<> json unsupported in key
    required IMap<String, TypedKey>
        parentByChild, // String key due to IMap<> json unsupported in key
    required ISet<TypedKey> rootRecords,
  }) = _DHTRecordPoolAllocations;

  factory DHTRecordPoolAllocations.fromJson(dynamic json) =>
      _$DHTRecordPoolAllocationsFromJson(json as Map<String, dynamic>);
}

/// Pointer to an owned record, with key, owner key and owner secret
/// Ensure that these are only serialized encrypted
@freezed
class OwnedDHTRecordPointer with _$OwnedDHTRecordPointer {
  const factory OwnedDHTRecordPointer({
    required TypedKey recordKey,
    required KeyPair owner,
  }) = _OwnedDHTRecordPointer;

  factory OwnedDHTRecordPointer.fromJson(dynamic json) =>
      _$OwnedDHTRecordPointerFromJson(json as Map<String, dynamic>);
}

class DHTRecordPool with AsyncTableDBBacked<DHTRecordPoolAllocations> {
  DHTRecordPool._(Veilid veilid, VeilidRoutingContext routingContext)
      : _state = DHTRecordPoolAllocations(
            childrenByParent: IMap(),
            parentByChild: IMap(),
            rootRecords: ISet()),
        _opened = <TypedKey, Mutex>{},
        _routingContext = routingContext,
        _veilid = veilid;

  // Persistent DHT record list
  DHTRecordPoolAllocations _state;
  // Which DHT records are currently open
  final Map<TypedKey, Mutex> _opened;
  // Default routing context to use for new keys
  final VeilidRoutingContext _routingContext;
  // Convenience accessor
  final Veilid _veilid;

  static DHTRecordPool? _singleton;

  //////////////////////////////////////////////////////////////
  /// AsyncTableDBBacked
  @override
  String tableName() => 'dht_record_pool';
  @override
  String tableKeyName() => 'pool_allocations';
  @override
  DHTRecordPoolAllocations valueFromJson(Object? obj) => obj != null
      ? DHTRecordPoolAllocations.fromJson(obj)
      : DHTRecordPoolAllocations(
          childrenByParent: IMap(), parentByChild: IMap(), rootRecords: ISet());
  @override
  Object? valueToJson(DHTRecordPoolAllocations val) => val.toJson();

  //////////////////////////////////////////////////////////////
  static Mutex instanceSetupMutex = Mutex();

  // ignore: prefer_expression_function_bodies
  static Future<DHTRecordPool> instance() async {
    return instanceSetupMutex.protect(() async {
      if (_singleton == null) {
        final routingContext = await Veilid.instance.routingContext();
        final globalPool = DHTRecordPool._(Veilid.instance, routingContext);
        globalPool._state = await globalPool.load();
        _singleton = globalPool;
      }
      return _singleton!;
    });
  }

  Veilid get veilid => _veilid;

  Future<void> _recordOpened(TypedKey key) async {
    // no race because dart is single threaded until async breaks
    final m = _opened[key] ?? Mutex();
    _opened[key] = m;
    await m.acquire();
    _opened[key] = m;
  }

  void recordClosed(TypedKey key) {
    final m = _opened.remove(key);
    if (m == null) {
      throw StateError('record already closed');
    }
    m.release();
  }

  Future<void> deleteDeep(TypedKey parent) async {
    // Collect all dependencies
    final allDeps = <TypedKey>[];
    final currentDeps = [parent];
    while (currentDeps.isNotEmpty) {
      final nextDep = currentDeps.removeLast();

      // Ensure we get the exclusive lock on this record
      await _recordOpened(nextDep);

      // Remove this child from its parent
      await _removeDependency(nextDep);

      allDeps.add(nextDep);
      final childDeps =
          _state.childrenByParent[nextDep.toJson()]?.toList() ?? [];
      currentDeps.addAll(childDeps);
    }

    // Delete all records
    final allFutures = <Future<void>>[];
    for (final dep in allDeps) {
      allFutures.add(_routingContext.deleteDHTRecord(dep));
      recordClosed(dep);
    }
    await Future.wait(allFutures);
  }

  void _validateParent(TypedKey? parent, TypedKey child) {
    final childJson = child.toJson();
    final existingParent = _state.parentByChild[childJson];
    if (parent == null) {
      if (existingParent != null) {
        throw StateError('Child is already parented: $child');
      }
    } else {
      if (_state.rootRecords.contains(child)) {
        throw StateError('Child already added as root: $child');
      }
      if (existingParent != null && existingParent != parent) {
        throw StateError('Child has two parents: $child <- $parent');
      }
    }
  }

  Future<void> _addDependency(TypedKey? parent, TypedKey child) async {
    if (parent == null) {
      if (_state.rootRecords.contains(child)) {
        // Dependency already added
        return;
      }
      _state = await store(
          _state.copyWith(rootRecords: _state.rootRecords.add(child)));
    } else {
      final childrenOfParent =
          _state.childrenByParent[parent.toJson()] ?? ISet<TypedKey>();
      if (childrenOfParent.contains(child)) {
        // Dependency already added (consecutive opens, etc)
        return;
      }
      _state = await store(_state.copyWith(
          childrenByParent: _state.childrenByParent
              .add(parent.toJson(), childrenOfParent.add(child)),
          parentByChild: _state.parentByChild.add(child.toJson(), parent)));
    }
  }

  Future<void> _removeDependency(TypedKey child) async {
    if (_state.rootRecords.contains(child)) {
      _state = await store(
          _state.copyWith(rootRecords: _state.rootRecords.remove(child)));
    } else {
      final parent = _state.parentByChild[child.toJson()];
      if (parent == null) {
        return;
      }
      final children = _state.childrenByParent[parent.toJson()]!.remove(child);
      late final DHTRecordPoolAllocations newState;
      if (children.isEmpty) {
        newState = _state.copyWith(
            childrenByParent: _state.childrenByParent.remove(parent.toJson()),
            parentByChild: _state.parentByChild.remove(child.toJson()));
      } else {
        newState = _state.copyWith(
            childrenByParent:
                _state.childrenByParent.add(parent.toJson(), children),
            parentByChild: _state.parentByChild.remove(child.toJson()));
      }
      _state = await store(newState);
    }
  }

  ///////////////////////////////////////////////////////////////////////

  /// Create a root DHTRecord that has no dependent records
  Future<DHTRecord> create({
    VeilidRoutingContext? routingContext,
    TypedKey? parent,
    DHTSchema schema = const DHTSchema.dflt(oCnt: 1),
    int defaultSubkey = 0,
    DHTRecordCrypto? crypto,
    KeyPair? writer,
  }) async {
    final dhtctx = routingContext ?? _routingContext;
    final recordDescriptor = await dhtctx.createDHTRecord(schema);

    final rec = DHTRecord(
        routingContext: dhtctx,
        recordDescriptor: recordDescriptor,
        defaultSubkey: defaultSubkey,
        writer: writer ?? recordDescriptor.ownerKeyPair(),
        crypto: crypto ??
            await DHTRecordCryptoPrivate.fromTypedKeyPair(
                recordDescriptor.ownerTypedKeyPair()!));

    await _addDependency(parent, rec.key);
    await _recordOpened(rec.key);

    return rec;
  }

  /// Open a DHTRecord readonly
  Future<DHTRecord> openRead(TypedKey recordKey,
      {VeilidRoutingContext? routingContext,
      TypedKey? parent,
      int defaultSubkey = 0,
      DHTRecordCrypto? crypto}) async {
    await _recordOpened(recordKey);

    late final DHTRecord rec;
    try {
      // If we are opening a key that already exists
      // make sure we are using the same parent if one was specified
      _validateParent(parent, recordKey);

      // Open from the veilid api
      final dhtctx = routingContext ?? _routingContext;
      final recordDescriptor = await dhtctx.openDHTRecord(recordKey, null);
      rec = DHTRecord(
          routingContext: dhtctx,
          recordDescriptor: recordDescriptor,
          defaultSubkey: defaultSubkey,
          crypto: crypto ?? const DHTRecordCryptoPublic());

      // Register the dependency
      await _addDependency(parent, rec.key);
    } on Exception catch (_) {
      recordClosed(recordKey);
      rethrow;
    }

    return rec;
  }

  /// Open a DHTRecord writable
  Future<DHTRecord> openWrite(
    TypedKey recordKey,
    KeyPair writer, {
    VeilidRoutingContext? routingContext,
    TypedKey? parent,
    int defaultSubkey = 0,
    DHTRecordCrypto? crypto,
  }) async {
    await _recordOpened(recordKey);

    late final DHTRecord rec;
    try {
      // If we are opening a key that already exists
      // make sure we are using the same parent if one was specified
      _validateParent(parent, recordKey);

      // Open from the veilid api
      final dhtctx = routingContext ?? _routingContext;
      final recordDescriptor = await dhtctx.openDHTRecord(recordKey, writer);
      rec = DHTRecord(
          routingContext: dhtctx,
          recordDescriptor: recordDescriptor,
          defaultSubkey: defaultSubkey,
          writer: writer,
          crypto: crypto ??
              await DHTRecordCryptoPrivate.fromTypedKeyPair(
                  TypedKeyPair.fromKeyPair(recordKey.kind, writer)));

      // Register the dependency if specified
      await _addDependency(parent, rec.key);
    } on Exception catch (_) {
      recordClosed(recordKey);
      rethrow;
    }

    return rec;
  }

  /// Open a DHTRecord owned
  /// This is the same as writable but uses an OwnedDHTRecordPointer
  /// for convenience and uses symmetric encryption on the key
  /// This is primarily used for backing up private content on to the DHT
  /// to synchronizing it between devices. Because it is 'owned', the correct
  /// parent must be specified.
  Future<DHTRecord> openOwned(
    OwnedDHTRecordPointer ownedDHTRecordPointer, {
    required TypedKey parent,
    VeilidRoutingContext? routingContext,
    int defaultSubkey = 0,
    DHTRecordCrypto? crypto,
  }) =>
      openWrite(
        ownedDHTRecordPointer.recordKey,
        ownedDHTRecordPointer.owner,
        routingContext: routingContext,
        parent: parent,
        defaultSubkey: defaultSubkey,
        crypto: crypto,
      );

  /// Get the parent of a DHTRecord key if it exists
  TypedKey? getParentRecord(TypedKey child) {
    final childJson = child.toJson();
    return _state.parentByChild[childJson];
  }
}
