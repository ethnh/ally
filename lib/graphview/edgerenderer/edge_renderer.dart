import 'package:fluent_ui/fluent_ui.dart';

import '../graph.dart';

abstract class EdgeRenderer {
  void render(Canvas canvas, Graph graph, Paint paint);
}
