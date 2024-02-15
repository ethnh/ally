import 'package:fluent_ui/fluent_ui.dart';

import 'types/graph_node.dart';
import 'edgerenderer/edge_renderer.dart';
import 'graph.dart';

abstract class Algorithm {
  EdgeRenderer? renderer;

  /// Executes the algorithm.
  ///
  /// [shiftY] Shifts the y-coordinate origin
  ///
  /// [shiftX] Shifts the x-coordinate origin
  ///
  /// @return The size of the graph
  Size run(Graph? graph, double shiftX, double shiftY);

  void setFocusedNode(GraphNode node);

  void init(Graph? graph);

  void step(Graph? graph);

  void setDimensions(double width, double height);
}
