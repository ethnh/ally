import 'package:freezed_annotation/freezed_annotation.dart';
import 'typdef.dart';

part 'source_edge.g.dart';
part 'source_edge.freezed.dart';

/// @author wang.jiaqi
/// @date 2023-09-29 10

@freezed
class SourceEdge with _$SourceEdge {
  const factory SourceEdge({
    required EdgeId id,
    required String type,
    required int start,
    required int end,
  }) = _SourceEdge;

  factory SourceEdge.fromJson(Map<String, dynamic> json) =>
      _$SourceEdgeFromJson(json);
}
