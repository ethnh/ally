import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/timezone.dart';
import 'user_popup_event.dart';
import 'user_popup_state.dart';

class UserPopupBloc extends Bloc<UserPopupEvent, UserPopupState> {
  UserPopupBloc() : super(UserPopupInitial()) {
    on<ShowUserPopup>((event, emit) => emit(UserPopupOpen(event.user)));
    on<CloseUserPopup>((event, emit) => emit(UserPopupClosed()));
  }
}
