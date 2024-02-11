import 'dart:async';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/relation_chart_data_bloc/bloc.dart';
import '../../bloc/relation_chart_data_bloc/state.dart';
import '../../../types/graph_node.dart';
import '../../bloc/user_popup_bloc/user_popup_bloc.dart';
import '../../bloc/user_popup_bloc/user_popup_event.dart';
import '../../bloc/user_popup_bloc/user_popup_state.dart';
import '../../tools/bloc_util.dart';
import 'graph.dart';
import 'algorithm.dart';
import '../../tools/defaultText.dart';

typedef NodeWidgetBuilder = Widget Function(GraphNode node);

class GraphView extends StatefulWidget {
  const GraphView(
      {Key? key, required this.algorithm, this.paint, this.animated = true})
      : super(key: key);

  final Algorithm algorithm;
  final bool animated;
  final Paint? paint;

  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  Widget circularWidget(GraphNode node) {
    var background = relationChartDataBloc(context).getColor(node.label);
    return MouseRegion(
      cursor: SystemMouseCursors.click, // 设置鼠标光标为小手指样式
      child: GestureDetector(
        onTap: () {
          //tripletEditorBloc(context).add(ChooseNode(newNode: node));
          context.read<UserPopupBloc>().add(ShowUserPopup(node));
        },
        child: Container(
          width: node.radius * 2,
          height: node.radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: background, spreadRadius: 5)],
          ),
          child: Center(
            child: Text(
              relationChartDataBloc(context).state.nodeMap[node.id]?.name ?? '',
              overflow: TextOverflow.ellipsis,
              style: calculateTextColor().copyWith(fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RelationChartDataBloc, RelationChartDataState>(
      builder: (context, state) => _GraphViewAnimated(
        key: widget.key,
        graph: relationChartDataBloc(context).state.graph!,
        algorithm: widget.algorithm,
        paint: widget.paint,
        builder: (GraphNode node) {
          return circularWidget(node); // 返回一个圆形小部件
        },
      ),
    );
  }
}

class RenderCustomLayoutBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, NodeBoxData>,
        RenderBoxContainerDefaultsMixin<RenderBox, NodeBoxData> {
  RenderCustomLayoutBox(
    Graph graph,
    Algorithm algorithm,
    Paint? paint, {
    List<RenderBox>? children,
  }) {
    _algorithm = algorithm;
    _graph = graph;
    edgePaint = paint;
    addAll(children);
  }

  late Algorithm _algorithm;
  late Graph _graph;
  late Paint _paint;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Graph>('graph', graph));
    properties.add(DiagnosticsProperty<Algorithm>('algorithm', algorithm));
    properties.add(DiagnosticsProperty<Paint>('paint', edgePaint));
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    context.canvas.translate(offset.dx, offset.dy);

    algorithm.renderer?.render(context.canvas, graph, edgePaint);

    context.canvas.restore();

    defaultPaint(context, offset);
  }

  @override
  void performLayout() {
    if (childCount == 0) {
      size = constraints.biggest;
      assert(size.isFinite);
      return;
    }

    var child = firstChild;
    var position = 0;
    var looseConstraints = BoxConstraints.loose(constraints.biggest);
    while (child != null) {
      final node = child.parentData as NodeBoxData;

      child.layout(looseConstraints, parentUsesSize: true);
      graph.getNodeAtPosition(position).size = child.size;

      child = node.nextSibling;
      position++;
    }

    size = algorithm.run(graph, 10, 10);

    child = firstChild;
    position = 0;
    while (child != null) {
      final node = child.parentData as NodeBoxData;

      node.offset = graph.getNodeAtPosition(position).position;

      child = node.nextSibling;
      position++;
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! NodeBoxData) {
      child.parentData = NodeBoxData();
    }
  }

  Paint get edgePaint => _paint;

  set edgePaint(Paint? value) {
    _paint = value ??
        (Paint()
          ..color = Colors.black
          ..strokeWidth = 3)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;
    markNeedsPaint();
  }

  Graph get graph => _graph;

  set graph(Graph value) {
    _graph = value;
    markNeedsLayout();
  }

  Algorithm get algorithm => _algorithm;

  set algorithm(Algorithm value) {
    _algorithm = value;
    markNeedsLayout();
  }
}

class NodeBoxData extends ContainerBoxParentData<RenderBox> {}

class _GraphViewAnimated extends StatefulWidget {
  _GraphViewAnimated(
      {Key? key,
      required this.graph,
      required this.algorithm,
      this.paint,
      required NodeWidgetBuilder builder}) {
    for (var node in graph.nodes) {
      nodes.add(builder(node));
    }
  }

  final Algorithm algorithm;
  final Graph graph;
  final nodes = <Widget>[];
  final Paint? paint;
  final stepMilis = 33;

  @override
  _GraphViewAnimatedState createState() => _GraphViewAnimatedState();
}

class _GraphViewAnimatedState extends State<_GraphViewAnimated> {
  late Algorithm algorithm;
  late Graph graph;
  late Timer timer;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    graph = widget.graph;

    algorithm = widget.algorithm;
    algorithm.init(graph);
    startTimer();

    super.initState();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(milliseconds: widget.stepMilis), (timer) {
      algorithm.step(graph);
      update();
    });
  }

  Future<void> update() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    algorithm.setDimensions(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: EdgeRender(algorithm, graph, const Offset(0, 0)),
        ),
        ...List<Widget>.generate(graph.nodeCount(), (index) {
          return Positioned(
            top: graph.getNodeAtPosition(index).position.dy,
            left: graph.getNodeAtPosition(index).position.dx,
            child: GestureDetector(
              child: widget.nodes[index],
              onPanUpdate: (details) {
                graph.getNodeAtPosition(index).position += details.delta;
                update();
              },
            ),
          );
        }),
      ],
    );
  }
}

class EdgeRender extends CustomPainter {
  EdgeRender(this.algorithm, this.graph, this.offset);

  Algorithm algorithm;
  Graph graph;
  Offset offset;

// 设置了画箭头的样式
  @override
  void paint(Canvas canvas, Size size) {
    var edgePaint = (Paint()
      ..color = Colors.black
      ..strokeWidth = 3)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    algorithm.renderer!.render(canvas, graph, edgePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
