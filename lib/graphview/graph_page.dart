import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/user_popup_bloc/user_popup_bloc.dart';
import 'bloc/user_popup_bloc/user_popup_state.dart';
import 'bloc/relation_chart_data_bloc/bloc.dart';
import 'graph_view.dart';
import 'directed_graphview.dart';
import 'user_popup.dart';
import 'forcedirected/fruchterman_reingold_algorithm.dart';
import 'defaultText.dart';
import 'types/graph_node.dart';
import 'graph.dart';
import 'types/graph_edge.dart';

class GraphExamplePage extends StatelessWidget {
  const GraphExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserPopupBloc>(
          create: (context) => UserPopupBloc(),
        ),
        BlocProvider<RelationChartDataBloc>(
          create: (context) => RelationChartDataBloc(), // Optional initialization  event
        ), 
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Interactive Graph Example')),
        body: Stack(
          children: [
            InteractiveViewer(
              child: GraphClusterViewPage(), 
            ),
            UserPopup(), 
          ],
        ),
      ),
    );
  }

}
