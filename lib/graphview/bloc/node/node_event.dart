import '../relation_chart_data_bloc/event.dart';
import '../../types/label_data.dart';

import '../../types/graph_node.dart';

abstract class NodeEvent extends RelationChartDataEvent {}

class AddNode extends NodeEvent {
  AddNode(this.node);

  final GraphNode node;
}

class UpdateNode extends NodeEvent {
  UpdateNode(this.node);

  final GraphNode node;
}

class DeleteNode extends NodeEvent {
  DeleteNode(this.node);

  final GraphNode node;
}

class CreateLabelAndSetNode extends NodeEvent {
  CreateLabelAndSetNode(this.labelData, this.node, this.isNodeExist);

  final LabelData labelData;
  final GraphNode node;
  final bool isNodeExist;
}

class ResizeNode extends NodeEvent {
  ResizeNode(this.node);

  final GraphNode node;
}
