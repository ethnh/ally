import '../../types/enums.dart';

/// @author wang.jiaqi
/// @date 2023-10-09 08

class WidgetControllerState {
  WidgetControllerState({
    required this.viewMode,
    required this.isBrowserPaneVisible,
    required this.isEditorPaneVisible,
    required this.centerFlexWeight,
  });

  WidgetControllerState.initial()
      : viewMode = ViewMode.classMode,
        isBrowserPaneVisible = true,
        isEditorPaneVisible = true,
        centerFlexWeight = 2;

  final int centerFlexWeight;
  final bool isBrowserPaneVisible;
  final bool isEditorPaneVisible;
  final ViewMode viewMode;

  WidgetControllerState copyWith({
    ViewMode? viewMode,
    bool? isBrowserPaneVisible,
    bool? isEditorPaneVisible,
    int? centerFlexWeight,
  }) =>
      WidgetControllerState(
        viewMode: viewMode ?? this.viewMode,
        isBrowserPaneVisible: isBrowserPaneVisible ?? this.isBrowserPaneVisible,
        isEditorPaneVisible: isEditorPaneVisible ?? this.isEditorPaneVisible,
        centerFlexWeight: centerFlexWeight ?? this.centerFlexWeight,
      );
}
