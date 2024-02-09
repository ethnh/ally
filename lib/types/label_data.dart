import 'package:freezed_annotation/freezed_annotation.dart';

part 'label_data.g.dart';
part 'label_data.freezed.dart';

/// @author wang.jiaqi
/// @date 2023-10-07 10

@freezed
class LabelData with _$LabelData {
  const factory LabelData({
    required String name,
    @Default([]) List<String> properties,
    @Default('ff4e6ef2') String color,
  }) = _LabelData;

  factory LabelData.fromJson(Map<String, dynamic> json) =>
      _$LabelDataFromJson(json);
}
