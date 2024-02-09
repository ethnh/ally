import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../node/node_event.dart';
import '../../types/graph_edge.dart';
import '../../types/source_edge.dart';
import '../../types/source_node.dart';

import '../../types/graph_node.dart';
import '../../types/label_data.dart';
import '../../types/typdef.dart';
import '../label/label_event.dart';
import '../edge/edge_event.dart';
import 'event.dart';
import 'state.dart';

/// @author wang.jiaqi
/// @date 2023-10-09 08

class RelationChartDataBloc
    extends Bloc<RelationChartDataEvent, RelationChartDataState> {
  RelationChartDataBloc() : super(RelationChartDataState.initial()) {
    //on<InitRelationChartData>(
    //    (event, emit) async => emit(await _onInitRelationChartData(event)));
    on<UpdateClassData>((event, emit) => emit(_onUpdateClassData(event)));

    on<CreateLabel>((event, emit) => emit(_onCreateLabel(event)));
    on<DeleteLabel>((event, emit) => emit(_onDeleteLabel(event)));
    on<CreateLabelAndSetNode>(
        (event, emit) => emit(_onCreateLabelAndSetNode(event)));
    on<SetLabelVisibility>((event, emit) => emit(_onSetClassVisibility(event)));

    on<AddNode>((event, emit) => emit(_onAddNode(event)));
    on<UpdateNode>((event, emit) => emit(_onUpdateNode(event)));
    on<DeleteNode>((event, emit) => emit(_onDeleteNode(event)));

    on<UpdateEdge>((event, emit) => emit(_onUpdateEdge(event)));
    on<CreateEdge>((event, emit) => emit(_onCreateEdge(event)));
    on<DeleteEdge>((event, emit) => emit(_onDeleteEdge(event)));
    on<CreateEdgeTypeAndAddEdge>(
        (event, emit) => emit(_onCreateEdgeTypeAndAddEdge(event)));
    on<DeleteEdgeType>((event, emit) => emit(_onDeleteEdgeType(event)));
  }

  @override
  void onChange(Change<RelationChartDataState> change) {
    //logger.i('[change!]');
    super.onChange(change);
  }

  Triplet? getTriplet(GraphEdge edge) {
    GraphNode? startNode = state.nodeMap[edge.start];
    GraphNode? endNode = state.nodeMap[edge.end];
    if (startNode != null && endNode != null) {
      return (startNode, edge, endNode);
    }
    return null;
  }

  int instanceCount(LabelName className) =>
      state.nodeToLabelMap[className]?.length ?? 0;

  Future<String> getRawData() async {
    var graphNodeList = state.nodeMap.values.toList();
    var nodeList = <SourceNode>[];
    for (var graphNode in graphNodeList) {
      nodeList.add(graphNode.toSourceNode());
    }

    var graphEdgeList = state.edgeMap.values.toList();

    var edgeList = <SourceEdge>[];
    for (var edge in graphEdgeList) {
      edgeList.add(edge.toSourceEdge());
    }

    var edgeTypeList = state.edgeTypes.toList();

    var newRawData = state.relationChartData.copyWith(
        labelDataList: state.labelMap.values.toList(),
        nodeList: nodeList,
        edgeList: edgeList,
        edgeTypeList: edgeTypeList);
    //logger.d(newRawData.toJson());
    return jsonEncode(newRawData.toJson());
  }

  GraphNode getGraphNode(NodeId id) {
    return state.nodeMap[id]!;
  }

  Color getColor(LabelName? label) => const Color(0xfff3f3f3);
  // state.labelMap[label]?.color.toColor() ? const Color(0xfff3f3f3);

  //Future<RelationChartDataState> _onInitRelationChartData(
  //  InitRelationChartData event,
  //) async {
  //  var state = await pretreatment(
  //      RelationChartDataState.fromJson(jsonDecode(event.rawData)));
  //  //logger.i('[relationChartDataEvent]: initRelationChartData!');
  //  return state;
  //}

  RelationChartDataState _onSetClassVisibility(SetLabelVisibility event) {
    var labelVisibilityMap = state.labelVisibilityMap;
    //logger.i('[classBrowser]: SetClassVisible!');
    if (labelVisibilityMap[event.labelName] != null) {
      labelVisibilityMap[event.labelName] =
          !labelVisibilityMap[event.labelName]!;
      return state.copyWith(labelVisibilityMap: labelVisibilityMap);
    }
    return state;
  }

  RelationChartDataState _onUpdateClassData(UpdateClassData event) {
    /// 未改名则不需要更新map
    if (event.oldName == event.classData.name) {
      var labelMap = state.labelMap;
      labelMap[event.oldName] = event.classData;
      return state.copyWith(labelMap: labelMap);
    } else {
      /// 类已经被改名了
      var labelMap = state.labelMap;
      var labelVisibilityMap = state.labelVisibilityMap;
      labelVisibilityMap[event.classData.name] =
          labelVisibilityMap[event.oldName] ?? true;
      labelVisibilityMap.remove(event.oldName);

      var nodeToLabelMap = state.nodeToLabelMap;
      nodeToLabelMap[event.classData.name] =
          nodeToLabelMap[event.oldName] ?? [];
      nodeToLabelMap.remove(event.oldName);
      //logger.i('[classBrowser]: updateClassData renamed!');

      return state.copyWith(
        nodeToLabelMap: nodeToLabelMap,
        labelMap: labelMap,
        labelVisibilityMap: labelVisibilityMap,
      );
    }
  }

  RelationChartDataState _onDeleteLabel(DeleteLabel event) {
    var targetLabel = event.labelName;
    var labelMap = <LabelName, LabelData>{}
      ..addAll(state.labelMap)
      ..remove(targetLabel);
    // 不需要清除节点
    var nodeToLabelMap = <LabelName, List<GraphNode>>{}
      ..addAll(state.nodeToLabelMap);
    var nodes = nodeToLabelMap[targetLabel];
    if (nodes == null || nodes.isEmpty) {
      return state.copyWith(labelMap: labelMap);
    }

    nodeToLabelMap.remove(targetLabel);

    // 需要清除节点
    var edgeMap = <EdgeId, GraphEdge>{}..addAll(state.edgeMap);
    var edgeEntries = edgeMap.entries.toList();
    for (var entry in edgeEntries) {
      if (entry.value.start.label == targetLabel ||
          entry.value.end.label == targetLabel) {
        edgeMap.remove(entry.key);
        state.graph?.removeEdge(entry.value);
      }
    }

    var nodeMap = <NodeId, GraphNode>{}..addAll(state.nodeMap);
    var nodeEntries = nodeMap.entries.toList();
    for (var entry in nodeEntries) {
      if (entry.value.label == event.labelName) {
        nodeMap.remove(entry.key);
        state.graph!.removeNode(entry.value);
      }
    }

    var labelVisiblityMap = <LabelName, bool>{}
      ..addAll(state.labelVisibilityMap)
      ..remove(targetLabel);
    //logger.i('[classBrowser]: DeleteClassData!');
    var edgeToTypeMap = <EdgeType, List<GraphEdge>>{};
    for (var edge in edgeMap.values) {
      var edgeList = edgeToTypeMap[edge.type] ?? [];
      edgeList.add(edge);
      edgeToTypeMap[edge.type] = edgeList;
    }
    return state.copyWith(
      nodeToLabelMap: nodeToLabelMap,
      labelVisibilityMap: labelVisiblityMap,
      nodeMap: nodeMap,
      labelMap: labelMap,
      edgeMap: edgeMap,
      edgeToTypeMap: edgeToTypeMap,
    );
  }

  RelationChartDataState _onUpdateEdge(UpdateEdge event) {
    var newEdge = event.edge;
    var edgeMap = <EdgeId, GraphEdge>{}
      ..addAll(state.edgeMap)
      ..[newEdge.id] = newEdge;
    state.graph!.updateEdge(newEdge);

    var edgeToTypeMap = <EdgeType, List<GraphEdge>>{}
      ..addAll(state.edgeToTypeMap);
    var edgeList = edgeToTypeMap[newEdge.type] ?? [];
    var oldTypeList = edgeToTypeMap[event.oldType] ?? [];
    for (var edge in oldTypeList) {
      if (edge.id == newEdge.id) {
        oldTypeList.remove(edge);
        break;
      }
    }
    edgeList.add(newEdge);
    edgeToTypeMap[newEdge.type] = edgeList;

    var newFlag = !state.forceRefreshFlag;
    return state.copyWith(
      edgeMap: edgeMap,
      forceRefreshFlag: newFlag,
      edgeToTypeMap: edgeToTypeMap,
    );
  }

  RelationChartDataState _onCreateEdge(CreateEdge event) {
    var newEdge = event.edge;
    var edgeTypes = <EdgeType>{}
      ..addAll(state.edgeTypes)
      ..add(newEdge.type);
    var edgeMap = <EdgeId, GraphEdge>{}
      ..addAll(state.edgeMap)
      ..[newEdge.id] = newEdge;
    var edgeToTypeMap = <EdgeType, List<GraphEdge>>{}
      ..addAll(state.edgeToTypeMap);
    var edgeList = edgeToTypeMap[newEdge.type] ?? [];
    edgeList.add(newEdge);
    edgeToTypeMap[newEdge.type] = edgeList;

    state.graph!.addEdgeS(newEdge);
    return state.copyWith(
      edgeTypes: edgeTypes,
      edgeMap: edgeMap,
    );
  }

  RelationChartDataState _onDeleteEdge(DeleteEdge event) {
    var edgeMap = <EdgeId, GraphEdge>{}..addAll(state.edgeMap);
    var edgeToTypeMap = <EdgeType, List<GraphEdge>>{}
      ..addAll(state.edgeToTypeMap);
    var edge = event.edge;

    var edges = edgeToTypeMap[edge.type] ?? [];
    edges.remove(edge);
    edgeToTypeMap[edge.type] = edges;
    state.graph?.removeEdge(edge);
    edgeMap.remove(edge.id);

    return state.copyWith(
      edgeMap: edgeMap,
      edgeToTypeMap: edgeToTypeMap,
    );
  }

  RelationChartDataState _onCreateLabel(CreateLabel event) {
    var labelMap = <LabelName, LabelData>{}..addAll(state.labelMap);
    labelMap[event.labelData.name] = event.labelData;
    var labelVisibilityMap = <LabelName, bool>{}
      ..addAll(state.labelVisibilityMap);
    labelVisibilityMap[event.labelData.name] = true;
    return state.copyWith(
        labelMap: labelMap, labelVisibilityMap: labelVisibilityMap);
  }

  RelationChartDataState _onAddNode(AddNode event) {
    var nodeMap = <NodeId, GraphNode>{}..addAll(state.nodeMap);
    var node = event.node;
    nodeMap[node.id] = event.node;

    var nodeToLabelMap = <LabelName, List<GraphNode>>{}
      ..addAll(state.nodeToLabelMap);
    var nodeList = nodeToLabelMap[event.node.label] ?? [];
    nodeList.add(event.node);
    nodeToLabelMap[event.node.label] = nodeList;

    state.graph!.addNode(event.node);
    return state.copyWith(nodeMap: nodeMap, nodeToLabelMap: nodeToLabelMap);
  }

  RelationChartDataState _onUpdateNode(UpdateNode event) {
    var newNode = event.node;
    var nodeMap = <NodeId, GraphNode>{}..addAll(state.nodeMap);

    if (nodeMap[newNode.id] == null) {
      return _onAddNode(AddNode(newNode));
    }

    var oldLabel = nodeMap[newNode.id]?.label ?? '';
    nodeMap[newNode.id] = newNode;
    var nodeToLabelMap = <LabelName, List<GraphNode>>{}
      ..addAll(state.nodeToLabelMap);
    if (oldLabel == newNode.label) {
      var nodes = nodeToLabelMap[oldLabel] ?? [];
      for (var node in nodes) {
        if (node.id == newNode.id) {
          //logger.d('[update]NodeUpdate!');
          node = newNode;
          break;
        }
      }
      nodeToLabelMap[oldLabel] = nodes;
    } else {
      var oldLabelNodes = nodeToLabelMap[oldLabel] ?? [];
      for (var i = 0; i < oldLabelNodes.length; i++) {
        if (oldLabelNodes[i].id == newNode.id) {
          //logger.d('[remove]$oldLabel');
          oldLabelNodes.removeAt(i);
          break;
        }
      }
      var newLabelNodes = nodeToLabelMap[newNode.label] ?? [];
      //logger.d('[add]${newNode.label}');
      newLabelNodes.add(newNode);
      nodeToLabelMap[oldLabel] = oldLabelNodes;
      nodeToLabelMap[newNode.label] = newLabelNodes;
    }

    state.graph?.updateNode(event.node);
    var newFlag = !state.forceRefreshFlag;
    return state.copyWith(
      nodeMap: nodeMap,
      forceRefreshFlag: newFlag,
      nodeToLabelMap: nodeToLabelMap,
    );
  }

  RelationChartDataState _onDeleteNode(DeleteNode event) {
    var node = event.node;
    state.graph?.removeNode(node);
    var nodeMap = <NodeId, GraphNode>{}..addAll(state.nodeMap);
    nodeMap.remove(node.id);

    var nodeToLabelMap = <LabelName, List<GraphNode>>{}
      ..addAll(state.nodeToLabelMap);
    var nodes = nodeToLabelMap[node.label];
    nodes = (nodes == null) ? [] : (nodes..remove(node));
    nodeToLabelMap[node.label] = nodes;

    var edgeMap = <EdgeId, GraphEdge>{}..addAll(state.edgeMap);
    var entries = edgeMap.entries.toList();
    for (var entry in entries) {
      if ((entry.value.end.id == node.id) ||
          (entry.value.start.id == node.id)) {
        edgeMap.remove(entry.key);
        state.graph?.removeEdge(entry.value);
      }
    }

    return state.copyWith(
      nodeToLabelMap: nodeToLabelMap,
      nodeMap: nodeMap,
      edgeMap: edgeMap,
    );
  }

  RelationChartDataState _onCreateEdgeTypeAndAddEdge(
      CreateEdgeTypeAndAddEdge event) {
    var edge = event.newEdge;
    var type = event.type;
    var oldEdge = event.oldEdge;
    var edgeTypes = <EdgeType>{}
      ..addAll(state.edgeTypes)
      ..add(type);

    var edgeToTypeMap = <EdgeType, List<GraphEdge>>{}
      ..addAll(state.edgeToTypeMap)
      ..[type] = [edge];

    var edgeMap = <EdgeId, GraphEdge>{}
      ..addAll(state.edgeMap)
      ..[edge.id] = edge;

    if (oldEdge != null) {
      edgeMap.remove(oldEdge);
      state.graph?.removeEdge(oldEdge);
    }

    state.graph!.addEdgeS(edge);

    var newFlag = !state.forceRefreshFlag;
    //logger.d(state.copyWith(
    //  edgeTypes: edgeTypes,
    //  forceRefreshFlag: newFlag,
    //  edgeToTypeMap: edgeToTypeMap,
    //  edgeMap: edgeMap,
    //));

    return state.copyWith(
      edgeTypes: edgeTypes,
      forceRefreshFlag: newFlag,
      edgeToTypeMap: edgeToTypeMap,
      edgeMap: edgeMap,
    );
  }

  RelationChartDataState _onDeleteEdgeType(DeleteEdgeType event) {
    var type = event.type;
    var edgeMap = <EdgeId, GraphEdge>{}..addAll(state.edgeMap);
    var edgeToTypeMap = <EdgeType, List<GraphEdge>>{}
      ..addAll(state.edgeToTypeMap);
    var edges = edgeToTypeMap[type];
    var edgeTypes = <EdgeType>{}
      ..addAll(state.edgeTypes)
      ..remove(type);
    if (edges == null) {
      return state.copyWith(edgeTypes: edgeTypes);
    }
    if (edges == []) {
      return state.copyWith(
        edgeTypes: edgeTypes,
        edgeToTypeMap: edgeToTypeMap..remove(type),
      );
    }

    state.graph!.removeEdges(edges);
    for (var edge in edges) {
      edgeMap.remove(edge);
    }
    edgeToTypeMap.remove(type);
    //logger.i('[delete]');
    //logger.d(state.copyWith(
    //  edgeMap: edgeMap,
    //  edgeToTypeMap: edgeToTypeMap,
    //  edgeTypes: edgeTypes,
    //));
    return state.copyWith(
      edgeMap: edgeMap,
      edgeToTypeMap: edgeToTypeMap,
      edgeTypes: edgeTypes,
    );
  }

  RelationChartDataState _onCreateLabelAndSetNode(CreateLabelAndSetNode event) {
    var labelMap = <LabelName, LabelData>{}..addAll(state.labelMap);
    labelMap[event.labelData.name] = event.labelData;
    var labelVisibilityMap = <LabelName, bool>{}
      ..addAll(state.labelVisibilityMap);

    labelVisibilityMap[event.labelData.name] = true;

    var node = event.node;
    var nodeToLabelMap = <LabelName, List<GraphNode>>{}
      ..addAll(state.nodeToLabelMap);

    if (event.isNodeExist) {
      var oldLabel = node.label;
      nodeToLabelMap[oldLabel] =
          (nodeToLabelMap[oldLabel]?..remove(node)) ?? [];
      node = node.copyWith(label: event.labelData.name);
      state.graph!.updateNode(node);
    }
    var nodeMap = <NodeId, GraphNode>{}
      ..addAll(state.nodeMap)
      ..[node.id] = node;

    nodeToLabelMap[node.label] = [node];

    state.graph!.addNode(node);
    return state.copyWith(
      labelMap: labelMap,
      nodeMap: nodeMap,
      nodeToLabelMap: nodeToLabelMap,
    );
  }
}
