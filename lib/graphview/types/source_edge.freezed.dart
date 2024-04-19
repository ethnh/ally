// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'source_edge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SourceEdge _$SourceEdgeFromJson(Map<String, dynamic> json) {
  return _SourceEdge.fromJson(json);
}

/// @nodoc
mixin _$SourceEdge {
  int get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  int get start => throw _privateConstructorUsedError;
  int get end => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SourceEdgeCopyWith<SourceEdge> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SourceEdgeCopyWith<$Res> {
  factory $SourceEdgeCopyWith(
          SourceEdge value, $Res Function(SourceEdge) then) =
      _$SourceEdgeCopyWithImpl<$Res, SourceEdge>;
  @useResult
  $Res call({int id, String type, int start, int end});
}

/// @nodoc
class _$SourceEdgeCopyWithImpl<$Res, $Val extends SourceEdge>
    implements $SourceEdgeCopyWith<$Res> {
  _$SourceEdgeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as int,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SourceEdgeImplCopyWith<$Res>
    implements $SourceEdgeCopyWith<$Res> {
  factory _$$SourceEdgeImplCopyWith(
          _$SourceEdgeImpl value, $Res Function(_$SourceEdgeImpl) then) =
      __$$SourceEdgeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String type, int start, int end});
}

/// @nodoc
class __$$SourceEdgeImplCopyWithImpl<$Res>
    extends _$SourceEdgeCopyWithImpl<$Res, _$SourceEdgeImpl>
    implements _$$SourceEdgeImplCopyWith<$Res> {
  __$$SourceEdgeImplCopyWithImpl(
      _$SourceEdgeImpl _value, $Res Function(_$SourceEdgeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_$SourceEdgeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as int,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SourceEdgeImpl implements _SourceEdge {
  const _$SourceEdgeImpl(
      {required this.id,
      required this.type,
      required this.start,
      required this.end});

  factory _$SourceEdgeImpl.fromJson(Map<String, dynamic> json) =>
      _$$SourceEdgeImplFromJson(json);

  @override
  final int id;
  @override
  final String type;
  @override
  final int start;
  @override
  final int end;

  @override
  String toString() {
    return 'SourceEdge(id: $id, type: $type, start: $start, end: $end)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SourceEdgeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, start, end);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SourceEdgeImplCopyWith<_$SourceEdgeImpl> get copyWith =>
      __$$SourceEdgeImplCopyWithImpl<_$SourceEdgeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SourceEdgeImplToJson(
      this,
    );
  }
}

abstract class _SourceEdge implements SourceEdge {
  const factory _SourceEdge(
      {required final int id,
      required final String type,
      required final int start,
      required final int end}) = _$SourceEdgeImpl;

  factory _SourceEdge.fromJson(Map<String, dynamic> json) =
      _$SourceEdgeImpl.fromJson;

  @override
  int get id;
  @override
  String get type;
  @override
  int get start;
  @override
  int get end;
  @override
  @JsonKey(ignore: true)
  _$$SourceEdgeImplCopyWith<_$SourceEdgeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
