import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';

import 'source_node.dart';
import 'typdef.dart';

var random = Random(1);

class GraphNode {
  GraphNode({
    required this.name,
    required this.bio,
    required this.id,
    required this.label,
    required this.properties,
    this.size = const Size(20, 20),
  });

  factory GraphNode.fromNode(SourceNode node) {
    return GraphNode(
        name: node.name,
        bio: node.bio,
        id: node.id,
        label: node.label,
        properties: node.properties,
        size: Size(node.radius, node.radius));
  }

  int id;
  LabelName label;
  String bio;
  String name;
  Offset position = Offset(
      random.nextDouble() * 20 + 10, random.nextDouble() * 20 + 10); // 节点的位置

  Map<String, dynamic>? properties;
  Size size;

  @override
  bool operator ==(Object other) =>
      other is GraphNode && hashCode == other.hashCode;

  // 获取哈希码
  @override
  int get hashCode {
    return ("$id ").hashCode;
  }

  // 转换为字符串
  @override
  String toString() {
    return 'Node{position: $position, key: $id, _size: $size, properties:${properties?.entries.toList()}}';
  }

  GraphNode copyWith(
          {String? name,
          int? id,
          String? bio,
          LabelName? label,
          Map<String, dynamic>? properties,
          double? radius}) =>
      GraphNode(
          name: name ?? this.name,
          id: id ?? this.id,
          bio: bio ?? this.bio,
          label: label ?? this.label,
          properties: properties ?? this.properties,
          size: radius != null ? Size(radius, radius) : size);

  double get radius => size.width;

  double get x => position.dx; // 获取节点的 x 坐标

  double get y => position.dy; // 获取节点的 y 坐标

  // 设置节点的 y 坐标
  set y(double value) {
    position = Offset(position.dx, value);
  }

  // 设置节点的 x 坐标
  set x(double value) {
    position = Offset(value, position.dy);
  }

  SourceNode toSourceNode() {
    return SourceNode(
      name: name,
      properties: properties ?? <String, dynamic>{},
      id: id,
      bio: bio,
      label: label,
    );
  }
}
