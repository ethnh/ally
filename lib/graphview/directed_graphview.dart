import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/relation_chart_data_bloc/bloc.dart';
import 'bloc/relation_chart_data_bloc/state.dart';
import 'algorithm.dart';
import 'forcedirected/fruchterman_reingold_algorithm.dart';
import 'graph_view.dart';

class GraphClusterViewPage extends StatefulWidget {
  const GraphClusterViewPage({
    super.key,
  });

  @override
  State<GraphClusterViewPage> createState() => _GraphClusterViewPageState();
}

class _GraphClusterViewPageState extends State<GraphClusterViewPage> {
  late Algorithm builder;

  @override
  void initState() {
    super.initState();
    builder = FruchtermanReingoldAlgorithm(iterations: 1000);
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(1000),
      minScale: 0.1,
      maxScale: 10,
      child: BlocBuilder<RelationChartDataBloc, RelationChartDataState>(
        builder: (context, state) => GraphView(
          algorithm: builder,
        ),
      ),
    );
  }
}
