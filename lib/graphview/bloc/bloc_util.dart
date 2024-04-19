import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/relation_chart_data_bloc/bloc.dart';
import '../bloc/widget_controller_bloc/bloc.dart';

RelationChartDataBloc relationChartDataBloc(BuildContext context) =>
    context.read<RelationChartDataBloc>();

//TripletEditorBloc tripletEditorBloc(BuildContext context) =>
//    context.read<TripletEditorBloc>();

WidgetControllerBloc widgetControllerBloc(BuildContext context) =>
    context.read<WidgetControllerBloc>();
