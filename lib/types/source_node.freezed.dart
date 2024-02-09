// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'source_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SourceNode _$SourceNodeFromJson(Map<String, dynamic> json) {
  return _SourceNode.fromJson(json);
}

/// @nodoc
mixin _$SourceNode {
  String get name => throw _privateConstructorUsedError;
  Map<String, dynamic>? get properties => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  String get bio => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  double get radius => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SourceNodeCopyWith<SourceNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SourceNodeCopyWith<$Res> {
  factory $SourceNodeCopyWith(
          SourceNode value, $Res Function(SourceNode) then) =
      _$SourceNodeCopyWithImpl<$Res, SourceNode>;
  @useResult
  $Res call(
      {String name,
      Map<String, dynamic>? properties,
      int id,
      String bio,
      String label,
      double radius});
}

/// @nodoc
class _$SourceNodeCopyWithImpl<$Res, $Val extends SourceNode>
    implements $SourceNodeCopyWith<$Res> {
  _$SourceNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? properties = freezed,
    Object? id = null,
    Object? bio = null,
    Object? label = null,
    Object? radius = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      properties: freezed == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      bio: null == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SourceNodeImplCopyWith<$Res>
    implements $SourceNodeCopyWith<$Res> {
  factory _$$SourceNodeImplCopyWith(
          _$SourceNodeImpl value, $Res Function(_$SourceNodeImpl) then) =
      __$$SourceNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      Map<String, dynamic>? properties,
      int id,
      String bio,
      String label,
      double radius});
}

/// @nodoc
class __$$SourceNodeImplCopyWithImpl<$Res>
    extends _$SourceNodeCopyWithImpl<$Res, _$SourceNodeImpl>
    implements _$$SourceNodeImplCopyWith<$Res> {
  __$$SourceNodeImplCopyWithImpl(
      _$SourceNodeImpl _value, $Res Function(_$SourceNodeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? properties = freezed,
    Object? id = null,
    Object? bio = null,
    Object? label = null,
    Object? radius = null,
  }) {
    return _then(_$SourceNodeImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      properties: freezed == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      bio: null == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SourceNodeImpl implements _SourceNode {
  const _$SourceNodeImpl(
      {required this.name,
      required final Map<String, dynamic>? properties,
      required this.id,
      required this.bio,
      required this.label,
      this.radius = 20})
      : _properties = properties;

  factory _$SourceNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$SourceNodeImplFromJson(json);

  @override
  final String name;
  final Map<String, dynamic>? _properties;
  @override
  Map<String, dynamic>? get properties {
    final value = _properties;
    if (value == null) return null;
    if (_properties is EqualUnmodifiableMapView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final int id;
  @override
  final String bio;
  @override
  final String label;
  @override
  @JsonKey()
  final double radius;

  @override
  String toString() {
    return 'SourceNode(name: $name, properties: $properties, id: $id, bio: $bio, label: $label, radius: $radius)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SourceNodeImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.radius, radius) || other.radius == radius));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name,
      const DeepCollectionEquality().hash(_properties), id, bio, label, radius);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SourceNodeImplCopyWith<_$SourceNodeImpl> get copyWith =>
      __$$SourceNodeImplCopyWithImpl<_$SourceNodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SourceNodeImplToJson(
      this,
    );
  }
}

abstract class _SourceNode implements SourceNode {
  const factory _SourceNode(
      {required final String name,
      required final Map<String, dynamic>? properties,
      required final int id,
      required final String bio,
      required final String label,
      final double radius}) = _$SourceNodeImpl;

  factory _SourceNode.fromJson(Map<String, dynamic> json) =
      _$SourceNodeImpl.fromJson;

  @override
  String get name;
  @override
  Map<String, dynamic>? get properties;
  @override
  int get id;
  @override
  String get bio;
  @override
  String get label;
  @override
  double get radius;
  @override
  @JsonKey(ignore: true)
  _$$SourceNodeImplCopyWith<_$SourceNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
