import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

/// @author wang.jiaqi
/// @date 2023-10-09 08

class WidgetControllerBloc
    extends Bloc<WidgetControllerEvent, WidgetControllerState> {
  WidgetControllerBloc() : super(WidgetControllerState.initial()) {
    on<SetViewMode>((event, emit) => emit(_handleSetViewMode(event)));
    on<SetIsBrowserPaneVisible>(
        (event, emit) => emit(_handleSetIsBrowserVisible(event)));
    on<SetIsEditorPaneVisible>(
        (event, emit) => emit(_handleSetIsEditorVisible(event)));
  }

  WidgetControllerState _handleSetViewMode(SetViewMode event) {
    return state.copyWith(viewMode: event.viewMode);
  }

  WidgetControllerState _handleSetIsBrowserVisible(
      SetIsBrowserPaneVisible event) {
    var newFlexWeight = state.centerFlexWeight;
    if (state.isBrowserPaneVisible) {
      newFlexWeight += 1;
    } else {
      newFlexWeight -= 1;
    }
    return state.copyWith(
      isBrowserPaneVisible: !state.isBrowserPaneVisible,
      centerFlexWeight: newFlexWeight,
    );
  }

  WidgetControllerState _handleSetIsEditorVisible(
      SetIsEditorPaneVisible event) {
    var newFlexWeight = state.centerFlexWeight;
    if (state.isEditorPaneVisible) {
      newFlexWeight += 1;
    } else {
      newFlexWeight -= 1;
    }
    return state.copyWith(
      isEditorPaneVisible: !state.isEditorPaneVisible,
      centerFlexWeight: newFlexWeight,
    );
  }
}
