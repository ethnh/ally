// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'relation_chart_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RelationChartDataModel _$RelationChartDataModelFromJson(
    Map<String, dynamic> json) {
  return _RelationChartDataModel.fromJson(json);
}

/// @nodoc
mixin _$RelationChartDataModel {
  List<SourceNode> get nodeList => throw _privateConstructorUsedError;
  List<SourceEdge> get edgeList => throw _privateConstructorUsedError;
  List<LabelData> get labelDataList => throw _privateConstructorUsedError;
  List<String> get edgeTypeList => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RelationChartDataModelCopyWith<RelationChartDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RelationChartDataModelCopyWith<$Res> {
  factory $RelationChartDataModelCopyWith(RelationChartDataModel value,
          $Res Function(RelationChartDataModel) then) =
      _$RelationChartDataModelCopyWithImpl<$Res, RelationChartDataModel>;
  @useResult
  $Res call(
      {List<SourceNode> nodeList,
      List<SourceEdge> edgeList,
      List<LabelData> labelDataList,
      List<String> edgeTypeList});
}

/// @nodoc
class _$RelationChartDataModelCopyWithImpl<$Res,
        $Val extends RelationChartDataModel>
    implements $RelationChartDataModelCopyWith<$Res> {
  _$RelationChartDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodeList = null,
    Object? edgeList = null,
    Object? labelDataList = null,
    Object? edgeTypeList = null,
  }) {
    return _then(_value.copyWith(
      nodeList: null == nodeList
          ? _value.nodeList
          : nodeList // ignore: cast_nullable_to_non_nullable
              as List<SourceNode>,
      edgeList: null == edgeList
          ? _value.edgeList
          : edgeList // ignore: cast_nullable_to_non_nullable
              as List<SourceEdge>,
      labelDataList: null == labelDataList
          ? _value.labelDataList
          : labelDataList // ignore: cast_nullable_to_non_nullable
              as List<LabelData>,
      edgeTypeList: null == edgeTypeList
          ? _value.edgeTypeList
          : edgeTypeList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RelationChartDataModelImplCopyWith<$Res>
    implements $RelationChartDataModelCopyWith<$Res> {
  factory _$$RelationChartDataModelImplCopyWith(
          _$RelationChartDataModelImpl value,
          $Res Function(_$RelationChartDataModelImpl) then) =
      __$$RelationChartDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SourceNode> nodeList,
      List<SourceEdge> edgeList,
      List<LabelData> labelDataList,
      List<String> edgeTypeList});
}

/// @nodoc
class __$$RelationChartDataModelImplCopyWithImpl<$Res>
    extends _$RelationChartDataModelCopyWithImpl<$Res,
        _$RelationChartDataModelImpl>
    implements _$$RelationChartDataModelImplCopyWith<$Res> {
  __$$RelationChartDataModelImplCopyWithImpl(
      _$RelationChartDataModelImpl _value,
      $Res Function(_$RelationChartDataModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodeList = null,
    Object? edgeList = null,
    Object? labelDataList = null,
    Object? edgeTypeList = null,
  }) {
    return _then(_$RelationChartDataModelImpl(
      nodeList: null == nodeList
          ? _value._nodeList
          : nodeList // ignore: cast_nullable_to_non_nullable
              as List<SourceNode>,
      edgeList: null == edgeList
          ? _value._edgeList
          : edgeList // ignore: cast_nullable_to_non_nullable
              as List<SourceEdge>,
      labelDataList: null == labelDataList
          ? _value._labelDataList
          : labelDataList // ignore: cast_nullable_to_non_nullable
              as List<LabelData>,
      edgeTypeList: null == edgeTypeList
          ? _value._edgeTypeList
          : edgeTypeList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RelationChartDataModelImpl implements _RelationChartDataModel {
  const _$RelationChartDataModelImpl(
      {required final List<SourceNode> nodeList,
      required final List<SourceEdge> edgeList,
      required final List<LabelData> labelDataList,
      required final List<String> edgeTypeList})
      : _nodeList = nodeList,
        _edgeList = edgeList,
        _labelDataList = labelDataList,
        _edgeTypeList = edgeTypeList;

  factory _$RelationChartDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RelationChartDataModelImplFromJson(json);

  final List<SourceNode> _nodeList;
  @override
  List<SourceNode> get nodeList {
    if (_nodeList is EqualUnmodifiableListView) return _nodeList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodeList);
  }

  final List<SourceEdge> _edgeList;
  @override
  List<SourceEdge> get edgeList {
    if (_edgeList is EqualUnmodifiableListView) return _edgeList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_edgeList);
  }

  final List<LabelData> _labelDataList;
  @override
  List<LabelData> get labelDataList {
    if (_labelDataList is EqualUnmodifiableListView) return _labelDataList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_labelDataList);
  }

  final List<String> _edgeTypeList;
  @override
  List<String> get edgeTypeList {
    if (_edgeTypeList is EqualUnmodifiableListView) return _edgeTypeList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_edgeTypeList);
  }

  @override
  String toString() {
    return 'RelationChartDataModel(nodeList: $nodeList, edgeList: $edgeList, labelDataList: $labelDataList, edgeTypeList: $edgeTypeList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RelationChartDataModelImpl &&
            const DeepCollectionEquality().equals(other._nodeList, _nodeList) &&
            const DeepCollectionEquality().equals(other._edgeList, _edgeList) &&
            const DeepCollectionEquality()
                .equals(other._labelDataList, _labelDataList) &&
            const DeepCollectionEquality()
                .equals(other._edgeTypeList, _edgeTypeList));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_nodeList),
      const DeepCollectionEquality().hash(_edgeList),
      const DeepCollectionEquality().hash(_labelDataList),
      const DeepCollectionEquality().hash(_edgeTypeList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RelationChartDataModelImplCopyWith<_$RelationChartDataModelImpl>
      get copyWith => __$$RelationChartDataModelImplCopyWithImpl<
          _$RelationChartDataModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RelationChartDataModelImplToJson(
      this,
    );
  }
}

abstract class _RelationChartDataModel implements RelationChartDataModel {
  const factory _RelationChartDataModel(
      {required final List<SourceNode> nodeList,
      required final List<SourceEdge> edgeList,
      required final List<LabelData> labelDataList,
      required final List<String> edgeTypeList}) = _$RelationChartDataModelImpl;

  factory _RelationChartDataModel.fromJson(Map<String, dynamic> json) =
      _$RelationChartDataModelImpl.fromJson;

  @override
  List<SourceNode> get nodeList;
  @override
  List<SourceEdge> get edgeList;
  @override
  List<LabelData> get labelDataList;
  @override
  List<String> get edgeTypeList;
  @override
  @JsonKey(ignore: true)
  _$$RelationChartDataModelImplCopyWith<_$RelationChartDataModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
