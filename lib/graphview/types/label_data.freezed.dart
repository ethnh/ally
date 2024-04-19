// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'label_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LabelData _$LabelDataFromJson(Map<String, dynamic> json) {
  return _LabelData.fromJson(json);
}

/// @nodoc
mixin _$LabelData {
  String get name => throw _privateConstructorUsedError;
  List<String> get properties => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LabelDataCopyWith<LabelData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabelDataCopyWith<$Res> {
  factory $LabelDataCopyWith(LabelData value, $Res Function(LabelData) then) =
      _$LabelDataCopyWithImpl<$Res, LabelData>;
  @useResult
  $Res call({String name, List<String> properties, String color});
}

/// @nodoc
class _$LabelDataCopyWithImpl<$Res, $Val extends LabelData>
    implements $LabelDataCopyWith<$Res> {
  _$LabelDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? properties = null,
    Object? color = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as List<String>,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LabelDataImplCopyWith<$Res>
    implements $LabelDataCopyWith<$Res> {
  factory _$$LabelDataImplCopyWith(
          _$LabelDataImpl value, $Res Function(_$LabelDataImpl) then) =
      __$$LabelDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, List<String> properties, String color});
}

/// @nodoc
class __$$LabelDataImplCopyWithImpl<$Res>
    extends _$LabelDataCopyWithImpl<$Res, _$LabelDataImpl>
    implements _$$LabelDataImplCopyWith<$Res> {
  __$$LabelDataImplCopyWithImpl(
      _$LabelDataImpl _value, $Res Function(_$LabelDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? properties = null,
    Object? color = null,
  }) {
    return _then(_$LabelDataImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as List<String>,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LabelDataImpl implements _LabelData {
  const _$LabelDataImpl(
      {required this.name,
      final List<String> properties = const [],
      this.color = 'ff4e6ef2'})
      : _properties = properties;

  factory _$LabelDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$LabelDataImplFromJson(json);

  @override
  final String name;
  final List<String> _properties;
  @override
  @JsonKey()
  List<String> get properties {
    if (_properties is EqualUnmodifiableListView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_properties);
  }

  @override
  @JsonKey()
  final String color;

  @override
  String toString() {
    return 'LabelData(name: $name, properties: $properties, color: $color)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LabelDataImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name,
      const DeepCollectionEquality().hash(_properties), color);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LabelDataImplCopyWith<_$LabelDataImpl> get copyWith =>
      __$$LabelDataImplCopyWithImpl<_$LabelDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LabelDataImplToJson(
      this,
    );
  }
}

abstract class _LabelData implements LabelData {
  const factory _LabelData(
      {required final String name,
      final List<String> properties,
      final String color}) = _$LabelDataImpl;

  factory _LabelData.fromJson(Map<String, dynamic> json) =
      _$LabelDataImpl.fromJson;

  @override
  String get name;
  @override
  List<String> get properties;
  @override
  String get color;
  @override
  @JsonKey(ignore: true)
  _$$LabelDataImplCopyWith<_$LabelDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
