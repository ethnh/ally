import 'package:freezed_annotation/freezed_annotation.dart';
import 'typdef.dart';
part 'source_node.g.dart';
part 'source_node.freezed.dart';

/// @author wang.jiaqi
/// @date 2023-09-29 10

@freezed
class SourceNode with _$SourceNode {
  const factory SourceNode({
    required String name,
    required Map<String, dynamic>? properties,
    required NodeId id,
    required NodeBio bio,
    required LabelName label,
    @Default(20) double radius,
  }) = _SourceNode;

  factory SourceNode.fromJson(Map<String, dynamic> json) =>
      _$SourceNodeFromJson(json);
}
