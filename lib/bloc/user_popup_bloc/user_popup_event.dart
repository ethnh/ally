import '../../types/graph_node.dart';

abstract class UserPopupEvent {}

class ShowUserPopup extends UserPopupEvent {
  final GraphNode user;

  ShowUserPopup(this.user);
}

class CloseUserPopup extends UserPopupEvent {}
