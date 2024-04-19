import '../relation_chart_data_bloc/event.dart';
import '../../types/label_data.dart';
import '../../types/typdef.dart';

/// @author wang.jiaqi
/// @date 2023-10-09 14

abstract class LabelEvent extends RelationChartDataEvent {
  LabelEvent();
}

/// 设置 [labelName] 的可见性
class SetLabelVisibility extends LabelEvent {
  SetLabelVisibility({required this.labelName});

  final LabelName labelName;
}

/// 更新某个类的数据到 [classData]
class UpdateClassData extends LabelEvent {
  UpdateClassData({required this.classData, required this.oldName});

  final LabelData classData;
  final LabelName oldName;
}

/// 删除名为 [labelName] 的类
class DeleteLabel extends LabelEvent {
  DeleteLabel({required this.labelName});

  final LabelName labelName;
}

class CreateLabel extends LabelEvent {
  CreateLabel({required this.labelData});

  final LabelData labelData;
}
