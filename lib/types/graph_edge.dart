import 'package:fluent_ui/fluent_ui.dart';

import 'graph_node.dart';
import 'source_edge.dart';
import 'typdef.dart';

class GraphEdge {
  GraphEdge(this.start, this.end, this.type, this.id, {this.paint});

  GraphNode end;
  EdgeId id;
  Paint? paint;
  GraphNode start;
  EdgeType type;

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
      other is GraphEdge && hashCode == other.hashCode;

  @override
  int get hashCode => id;

  static GraphEdge? fromSourceEdge(
      SourceEdge sourceEdge, Map<NodeId, GraphNode> nodeMap) {
    var source = nodeMap[sourceEdge.start];
    var end = nodeMap[sourceEdge.end];
    if (source != null && end != null) {
      return GraphEdge(source, end, sourceEdge.type, sourceEdge.id);
    }
    return null;
  }

  SourceEdge toSourceEdge() =>
      SourceEdge(id: id, type: type, start: start.id, end: end.id);

  GraphEdge copyWith({
    GraphNode? start,
    GraphNode? end,
    EdgeType? type,
    EdgeId? id,
    Paint? paint,
  }) =>
      GraphEdge(start ?? this.start, end ?? this.end, type ?? this.type,
          id ?? this.id,
          paint: paint ?? this.paint);
}

abstract class GraphObserver {
  void notifyGraphInvalidated();
}
