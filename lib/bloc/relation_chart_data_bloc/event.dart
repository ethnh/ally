/// @author wang.jiaqi
/// @date 2023-10-09 14

abstract class RelationChartDataEvent {
  RelationChartDataEvent();
}

/// 使用从json文件中读取的数据 [rawData] 初始化State
class InitRelationChartData extends RelationChartDataEvent {
  InitRelationChartData({required this.rawData});

  final String rawData;
}
