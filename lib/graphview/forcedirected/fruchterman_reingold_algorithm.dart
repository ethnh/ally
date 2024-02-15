import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:collection/collection.dart' show IterableExtension;

import '../types/graph_edge.dart';
import '../types/graph_node.dart';
import '../algorithm.dart';
import '../edgerenderer/arrow_edge_renderer.dart';
import '../edgerenderer/edge_renderer.dart';
import '../graph.dart';

const int defaultIterations = 1000;
const double defaultRepulsionRate = 0.5;
const double defaultRepulsionPercentage = 0.4;
const double defaultAttractionRate = 0.15;
const double defaultAttractionPercentage = 0.15;
const int defaultClusterPadding = 15;
const double epsilon = 0.0001;

class FruchtermanReingoldAlgorithm implements Algorithm {
  FruchtermanReingoldAlgorithm(
      {this.iterations = defaultIterations,
      this.renderer,
      this.repulsionRate = defaultRepulsionRate,
      this.attractionRate = defaultAttractionRate,
      this.repulsionPercentage = defaultRepulsionPercentage,
      this.attractionPercentage = defaultAttractionPercentage}) {
    renderer = renderer ?? ArrowEdgeRenderer();
  }

  double attractionPercentage = defaultAttractionPercentage;
  double attractionRate = defaultAttractionRate;
  Map<int, Offset> displacement = {};
  GraphNode? focusedNode;
  double graphHeight = 500; //default value, change ahead of time
  double graphWidth = 500;
  int iterations = defaultIterations;
  Random rand = Random();
  double repulsionPercentage = defaultRepulsionPercentage;
  double repulsionRate = defaultRepulsionRate;
  late double tick;

  @override
  EdgeRenderer? renderer;

  @override
  void init(Graph? graph) {
    for (var node in graph!.nodes) {
      displacement[node.id] = Offset.zero;
      node.position = Offset(
          rand.nextDouble() * graphWidth, rand.nextDouble() * graphHeight);
    }
  }

  @override
  Size run(Graph? graph, double shiftX, double shiftY) {
    var size = findBiggestSize(graph!) * graph.nodeCount();
    graphWidth = size;
    graphHeight = size;

    var nodes = graph.nodes;
    var edges = graph.edges;

    tick = 0.1 * sqrt(graphWidth / 2 * graphHeight / 2);

    init(graph);

    for (var i = 0; i < iterations; i++) {
      calculateRepulsion(nodes);
      calculateAttraction(edges);
      limitMaximumDisplacement(nodes);

      cool(i);

      if (done()) {
        break;
      }
    }

    if (focusedNode == null) {
      positionNodes(graph);
    }

    shiftCoordinates(graph, shiftX, shiftY);

    return calculateGraphSize(graph);
  }

  @override
  void setDimensions(double width, double height) {
    graphWidth = width;
    graphHeight = height;
  }

  @override
  void setFocusedNode(GraphNode node) {
    focusedNode = node;
  }

  @override
  void step(Graph? graph) {
    displacement = {};
    for (var node in graph!.nodes) {
      displacement[node.id] = Offset.zero;
    }
    calculateRepulsion(graph.nodes);
    calculateAttraction(graph.edges);
    moveNodes(graph);
  }

  void moveNodes(Graph graph) {
    for (var node in graph.nodes) {
      var newPosition = node.position += displacement[node.id]!;
      double newDX = min(graphWidth - 40, max(0, newPosition.dx));
      double newDY = min(graphHeight - 40, max(0, newPosition.dy));

      node.position = Offset(newDX, newDY);
    }
  }

  void cool(int currentIteration) {
    tick *= 1.0 - currentIteration / iterations;
  }

  void limitMaximumDisplacement(List<GraphNode> nodes) {
    for (var node in nodes) {
      if (node != focusedNode) {
        var dispLength = max(epsilon, displacement[node.id]!.distance);
        node.position +=
            displacement[node.id]! / dispLength * min(dispLength, tick);
      } else {
        displacement[node.id] = Offset.zero;
      }
    }
  }

  void calculateAttraction(List<GraphEdge> edges) {
    for (var edge in edges) {
      var source = edge.start;
      var destination = edge.end;
      var delta = source.position - destination.position;
      var deltaDistance = max(epsilon, delta.distance);
      var maxAttractionDistance = min(graphWidth * attractionPercentage,
          graphHeight * attractionPercentage);
      var attractionForce =
          min(0, (maxAttractionDistance - deltaDistance)).abs() /
              (maxAttractionDistance * 2);
      var attractionVector = delta * attractionForce * attractionRate;

      displacement[source.id] = displacement[source.id]! - attractionVector;
      displacement[destination.id] =
          displacement[destination.id]! + attractionVector;
    }
  }

  void calculateRepulsion(List<GraphNode> nodes) {
    for (var nodeA in nodes) {
      for (var nodeB in nodes) {
        if (nodeA != nodeB) {
          var delta = nodeA.position - nodeB.position;
          var deltaDistance = max(epsilon, delta.distance); //protect for 0
          var maxRepulsionDistance = min(graphWidth * repulsionPercentage,
              graphHeight * repulsionPercentage);
          var repulsionForce = max(0, maxRepulsionDistance - deltaDistance) /
              maxRepulsionDistance; //value between 0-1
          var repulsionVector = delta * repulsionForce * repulsionRate;

          displacement[nodeA.id] = displacement[nodeA.id]! + repulsionVector;
        }
      }
    }

    for (var nodeA in nodes) {
      displacement[nodeA.id] =
          displacement[nodeA.id]! / nodes.length.toDouble();
    }
  }

  void shiftCoordinates(Graph graph, double shiftX, double shiftY) {
    for (var node in graph.nodes) {
      node.position = Offset(node.x + shiftX, node.y + shiftY);
    }
  }

  void positionNodes(Graph graph) {
    var offset = getOffset(graph);
    var x = offset.dx;
    var y = offset.dy;
    var nodesVisited = <GraphNode>[];
    var nodeClusters = <NodeCluster>[];
    for (var node in graph.nodes) {
      node.position = Offset(node.x - x, node.y - y);
    }

    for (var node in graph.nodes) {
      if (!nodesVisited.contains(node)) {
        nodesVisited.add(node);
        var cluster = findClusterOf(nodeClusters, node);
        if (cluster == null) {
          cluster = NodeCluster();
          cluster.add(node);
          nodeClusters.add(cluster);
        }

        followEdges(graph, cluster, node, nodesVisited);
      }
    }

    positionCluster(nodeClusters);
  }

  void positionCluster(List<NodeCluster> nodeClusters) {
    combineSingleNodeCluster(nodeClusters);

    var cluster = nodeClusters[0];
    // move first cluster to 0,0
    cluster.offset(-cluster.rect!.left, -cluster.rect!.top);

    for (var i = 1; i < nodeClusters.length; i++) {
      var nextCluster = nodeClusters[i];
      var xDiff =
          nextCluster.rect!.left - cluster.rect!.right - defaultClusterPadding;
      var yDiff = nextCluster.rect!.top - cluster.rect!.top;
      nextCluster.offset(-xDiff, -yDiff);
      cluster = nextCluster;
    }
  }

  void combineSingleNodeCluster(List<NodeCluster> nodeClusters) {
    NodeCluster? firstSingleNodeCluster;

    for (var cluster in nodeClusters) {
      if (cluster.size() == 1) {
        if (firstSingleNodeCluster == null) {
          firstSingleNodeCluster = cluster;
        } else {
          firstSingleNodeCluster.concat(cluster);
        }
      }
    }

    nodeClusters.removeWhere((element) => element.size() == 1);
  }

  void followEdges(
      Graph graph, NodeCluster cluster, GraphNode node, List nodesVisited) {
    graph.successorsOf(node).forEach((successor) {
      if (!nodesVisited.contains(successor)) {
        nodesVisited.add(successor);
        cluster.add(successor);

        followEdges(graph, cluster, successor, nodesVisited);
      }
    });

    graph.predecessorsOf(node).forEach((predecessor) {
      if (!nodesVisited.contains(predecessor)) {
        nodesVisited.add(predecessor);
        cluster.add(predecessor);

        followEdges(graph, cluster, predecessor, nodesVisited);
      }
    });
  }

  NodeCluster? findClusterOf(List<NodeCluster> clusters, GraphNode node) {
    return clusters.firstWhereOrNull((element) => element.contains(node));
  }

  double findBiggestSize(Graph graph) {
    return graph.nodes.map((it) => it.radius).reduce(max);
  }

  Offset getOffset(Graph graph) {
    var offsetX = double.infinity;
    var offsetY = double.infinity;

    for (var node in graph.nodes) {
      offsetX = min(offsetX, node.x);
      offsetY = min(offsetY, node.y);
    }

    return Offset(offsetX, offsetY);
  }

  bool done() {
    return tick < 1.0 / max(graphHeight, graphWidth);
  }

  void drawEdges(Canvas canvas, Graph graph, Paint linePaint) {}

  Size calculateGraphSize(Graph graph) {
    var left = double.infinity;
    var top = double.infinity;
    var right = double.negativeInfinity;
    var bottom = double.negativeInfinity;

    for (var node in graph.nodes) {
      left = min(left, node.x);
      top = min(top, node.y);
      right = max(right, node.x + node.radius);
      bottom = max(bottom, node.y + node.radius);
    }

    return Size(right - left, bottom - top);
  }
}

class NodeCluster {
  NodeCluster() {
    nodes = [];
    rect = Rect.zero;
  }

  List<GraphNode>? nodes;
  Rect? rect;

  List<GraphNode>? getNodes() {
    return nodes;
  }

  Rect? getRect() {
    return rect;
  }

  void setRect(Rect rect) {
    rect = rect;
  }

  void add(GraphNode node) {
    nodes!.add(node);

    if (nodes!.length == 1) {
      rect = Rect.fromLTRB(
          node.x, node.y, node.x + node.radius, node.y + node.radius);
    } else {
      rect = Rect.fromLTRB(
          min(rect!.left, node.x),
          min(rect!.top, node.y),
          max(rect!.right, node.x + node.radius),
          max(rect!.bottom, node.y + node.radius));
    }
  }

  bool contains(GraphNode node) {
    return nodes!.contains(node);
  }

  int size() {
    return nodes!.length;
  }

  void concat(NodeCluster cluster) {
    for (var node in cluster.nodes!) {
      node.position = (Offset(rect!.right + defaultClusterPadding, rect!.top));
      add(node);
    }
  }

  void offset(double xDiff, double yDiff) {
    for (var node in nodes!) {
      node.position = (node.position + Offset(xDiff, yDiff));
    }

    rect = rect!.translate(xDiff, yDiff);
  }
}
