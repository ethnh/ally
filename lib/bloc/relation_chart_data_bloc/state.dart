import 'package:freezed_annotation/freezed_annotation.dart';
import '../../types/graph_edge.dart';
import '../../types/typdef.dart';
import '../../components/graphview/graph.dart';

import '../../types/graph_node.dart';
import '../../types/label_data.dart';
import 'relation_chart_data_model.dart';
part 'state.freezed.dart';

/// @author wang.jiaqi
/// @date 2023-10-09 09

enum GraphDataStatus { loading, loaded, notFound, error }

@freezed
class RelationChartDataState with _$RelationChartDataState {
  const factory RelationChartDataState({
    required RelationChartDataModel relationChartData,
    @Default({}) Map<LabelName, LabelData> labelMap,
    @Default({}) Map<NodeId, GraphNode> nodeMap,
    @Default({}) Map<EdgeId, GraphEdge> edgeMap,
    @Default({}) Map<LabelName, bool> labelVisibilityMap,
    @Default({}) Set<EdgeType> edgeTypes,
    @Default({}) Map<LabelName, List<GraphNode>> nodeToLabelMap,
    @Default({}) Map<EdgeType, List<GraphEdge>> edgeToTypeMap,
    @Default(false) bool forceRefreshFlag,
    @Default(false) bool isInitDone,
    @Default(GraphDataStatus.loading) GraphDataStatus graphDataStatus,
    Graph? graph,
  }) = _RelationChartDataState;

  factory RelationChartDataState.fromJson(Map<String, dynamic> json) {
    var relationChartData = RelationChartDataModel.fromJson(json);
    return RelationChartDataState(relationChartData: relationChartData);
  }

  static Graph _createExampleGraph() {
    // Create UserNode objects
    final alice = GraphNode(
      name: 'Alice Smith',
      bio: 'Software Engineer',
      id: 1,
      label: 'Alice',
      properties: {},
    );

    final bob = GraphNode(
      name: 'Bob Johnson',
      bio: 'Product Designer',
      id: 2,
      label: 'Bob',
      properties: {},
    );

    final charlie = GraphNode(
      name: 'Charlie Davis',
      bio: 'Data Scientist',
      id: 3,
      label: 'Charlie',
      properties: {},
    );

    final dave = GraphNode(
      name: 'Dave Brown',
      bio: 'Marketing Manager',
      id: 4,
      label: 'Dave',
      properties: {},
    );

    final eve = GraphNode(
      name: 'Eve Wilson',
      bio: 'Project Manager',
      id: 5,
      label: 'Eve',
      properties: {},
    );

    final frank = GraphNode(
      name: 'Frank White',
      bio: 'Quality Assurance',
      id: 6,
      label: 'Frank',
      properties: {},
    );

    final grace = GraphNode(
      name: 'Grace Lee',
      bio: 'UX Designer',
      id: 7,
      label: 'Grace',
      properties: {},
    );

    final hank = GraphNode(
      name: 'Hank Taylor',
      bio: 'System Administrator',
      id: 8,
      label: 'Hank',
      properties: {},
    );

    final iris = GraphNode(
      name: 'Iris Green',
      bio: 'Business Analyst',
      id: 9,
      label: 'Iris',
      properties: {},
    );

    final jack = GraphNode(
      name: 'Jack Adams',
      bio: 'DevOps Engineer',
      id: 10,
      label: 'Jack',
      properties: {},
    );

    final edge1 = GraphEdge(
        alice, bob, "Fully Trusted", "${alice.id}${bob.id}Fully".hashCode);
    final edge2 = GraphEdge(alice, charlie, "Ultimate Trust",
        "${alice.id}${charlie.id}Ultimate".hashCode);
    final edge3 =
        GraphEdge(alice, dave, "", "${alice.id}${dave.id}None".hashCode);
    final edge4 =
        GraphEdge(bob, eve, "Marginal Trust", "${bob.id}${eve.id}a".hashCode);
    final edge5 = GraphEdge(
        charlie, frank, "Marginal Trust", "${charlie.id}${frank.id}a".hashCode);
    final edge6 = GraphEdge(
        dave, grace, "Fully Trusted", "${dave.id}${grace.id}Fully".hashCode);
    final edge7 = GraphEdge(
        eve, hank, "Ultimate Trust", "${eve.id}${hank.id}Ultimate".hashCode);
    final edge8 =
        GraphEdge(frank, iris, "", "${frank.id}${iris.id}None".hashCode);
    final edge9 = GraphEdge(
        grace, jack, "Marginal Trust", "${grace.id}${jack.id}a".hashCode);
    final edge10 = GraphEdge(
        hank, alice, "Fully Trusted", "${hank.id}${alice.id}Fully".hashCode);

    return Graph(
      nodes: [
        alice,
        bob,
        charlie,
        dave,
        eve,
        frank,
        grace,
        hank,
        iris,
        jack
      ], // List of UserNodes
      edges: [
        edge1,
        edge2,
        edge3,
        edge4,
        edge5,
        edge6,
        edge7,
        edge8,
        edge9,
        edge10,
//        edge11,
//        edge12,
//        edge13,
//        edge14,
//        edge15,
//        edge16,
//        edge17,
//        edge18,
//        edge19,
//        edge20,
      ], // List of GraphEdge objects
    );
  }

  factory RelationChartDataState.initial() => RelationChartDataState(
        relationChartData: RelationChartDataModel.initial(),
        forceRefreshFlag: false,
        graph: _createExampleGraph(),
      );
}

Future<RelationChartDataState> pretreatment(
    RelationChartDataState state) async {
  var relationChartData = state.relationChartData;
  var nodeMap = <NodeId, GraphNode>{};
  for (var node in relationChartData.nodeList) {
    nodeMap[node.id] = GraphNode.fromNode(node);
  }

  var edgeTypes = <EdgeType>{};
  for (var type in relationChartData.edgeTypeList) {
    edgeTypes.add(type);
  }

  var edgeMap = <EdgeId, GraphEdge>{};
  for (var edge in relationChartData.edgeList) {
    var newEdge = GraphEdge.fromSourceEdge(edge, nodeMap);
    if (newEdge != null) {
      edgeMap[edge.id] = newEdge;
    }
  }

  var classVisibilityMap = <LabelName, bool>{};
  for (var classData in relationChartData.labelDataList) {
    classVisibilityMap[classData.name] = true;
  }

  var nodeToLabelMap = <LabelName, List<GraphNode>>{};
  for (var node in nodeMap.values) {
    var nodeList = nodeToLabelMap[node.label] ?? [];
    nodeList.add(node);
    nodeToLabelMap[node.label] = nodeList;
  }

  var edgeToTypeMap = <EdgeType, List<GraphEdge>>{};
  for (var edge in edgeMap.values) {
    var edgeList = edgeToTypeMap[edge.type] ?? [];
    edgeList.add(edge);
    edgeToTypeMap[edge.type] = edgeList;
  }

  var classMap = <LabelName, LabelData>{};
  for (var classData in relationChartData.labelDataList) {
    classMap[classData.name] = classData;
  }

  var graph = Graph(
      nodes: nodeMap.values.toList(),
      edges: edgeMap.values.toList(),
      graphObserver: []);

  return RelationChartDataState(
    relationChartData: relationChartData,
    labelMap: classMap,
    nodeMap: nodeMap,
    edgeMap: edgeMap,
    labelVisibilityMap: classVisibilityMap,
    nodeToLabelMap: nodeToLabelMap,
    forceRefreshFlag: false,
    graph: graph,
    edgeTypes: edgeTypes,
    edgeToTypeMap: edgeToTypeMap,
    isInitDone: true,
  );
}
