// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation_chart_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RelationChartDataModelImpl _$$RelationChartDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RelationChartDataModelImpl(
      nodeList: (json['node_list'] as List<dynamic>)
          .map((e) => SourceNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      edgeList: (json['edge_list'] as List<dynamic>)
          .map((e) => SourceEdge.fromJson(e as Map<String, dynamic>))
          .toList(),
      labelDataList: (json['label_data_list'] as List<dynamic>)
          .map((e) => LabelData.fromJson(e as Map<String, dynamic>))
          .toList(),
      edgeTypeList: (json['edge_type_list'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$RelationChartDataModelImplToJson(
        _$RelationChartDataModelImpl instance) =>
    <String, dynamic>{
      'node_list': instance.nodeList.map((e) => e.toJson()).toList(),
      'edge_list': instance.edgeList.map((e) => e.toJson()).toList(),
      'label_data_list': instance.labelDataList.map((e) => e.toJson()).toList(),
      'edge_type_list': instance.edgeTypeList,
    };
