import '../../types/graph_node.dart';

abstract class UserPopupState {}

class UserPopupInitial extends UserPopupState {}

class UserPopupOpen extends UserPopupState {
  final GraphNode user;

  UserPopupOpen(this.user);
}

class UserPopupClosed extends UserPopupState {}
