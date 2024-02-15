import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'bloc/user_popup_bloc/user_popup_bloc.dart';
import 'bloc/user_popup_bloc/user_popup_state.dart';
import 'bloc/user_popup_bloc/user_popup_event.dart';

class UserPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPopupBloc, UserPopupState>(
      builder: (context, state) {
        if (state is UserPopupOpen) {
          //return fluent.ContentDialog(
          //  title: Text(state.user.name),
          //  // ... (Rest of your popup content) ...
          //  actions: [
          //    fluent.FilledButton(
          //      child: const Text('Close'),
          //      onPressed: () =>
          //          context.read<UserPopupBloc>().add(CloseUserPopup()),
          //    )
          //  ],
          //);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 400,
                    child: Wrap(direction: Axis.vertical, children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Close")),
                      Text("Name:"),
                      Text(state.user.name),
                      Text("Bio:"),
                      Text(state.user.bio),
                      Text(
                          "Hello World From Components/user_popup.dart (this makes this popup wide)"),
                    ]),
                  );
                });
          });
          return const SizedBox.shrink(); // Not showing when closed
        } else {
          return const SizedBox.shrink(); // Not showing when closed
        }
      },
    );
  }
}
