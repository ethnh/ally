import 'package:freezed_annotation/freezed_annotation.dart';
import '../../types/source_node.dart';
import '../../types/source_edge.dart';

import '../../types/label_data.dart';
import '../../types/typdef.dart';

part 'relation_chart_data_model.g.dart';
part 'relation_chart_data_model.freezed.dart';

/// @author wang.jiaqi
/// @date 2023-10-05 19

@freezed
class RelationChartDataModel with _$RelationChartDataModel {
  const factory RelationChartDataModel({
    required List<SourceNode> nodeList,
    required List<SourceEdge> edgeList,
    required List<LabelData> labelDataList,
    required List<EdgeType> edgeTypeList,
  }) = _RelationChartDataModel;

  factory RelationChartDataModel.fromJson(Map<String, dynamic> json) =>
      _$RelationChartDataModelFromJson(json);

  factory RelationChartDataModel.initial() => const RelationChartDataModel(
      nodeList: [],
      edgeList: [],
      labelDataList: <LabelData>[],
      edgeTypeList: []);
}
