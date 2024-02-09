import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/relation_chart_data_bloc/event.dart';
import '../bloc/relation_chart_data_bloc/bloc.dart';
import '../bloc/user_popup_bloc/user_popup_bloc.dart';
import '../pages/developer.dart';
import '../pages/index.dart';
import '../pages/graph.dart';
import '../tools/bloc_util.dart';

part 'router_notifier.g.dart';

@riverpod
class RouterNotifier extends _$RouterNotifier implements Listenable {
  /// GoRouter listener
  VoidCallback? routerListener;

  /// Do we need to make or import an account immediately?
  bool hasAnyAccount = true;
  bool hasActiveChat = true;

  /// AsyncNotifier build
  @override
  Future<void> build() async {
    // When this notifier's state changes, inform GoRouter
    ref.listenSelf((_, __) {
      if (state.isLoading) {
        return;
      }
      routerListener?.call();
    });
  }

  /// Redirects when our state changes
  String? redirect(BuildContext context, GoRouterState state) {
    if (this.state.isLoading || this.state.hasError) {
      return null;
    }

    // No matter where we are, if there's not
    switch (state.matchedLocation) {
      case '/settings':
        return null;
      case '/developer':
        return null;
      default:
        return '/';
      // '/developer';
    }
  }

  /// Our application routes
  List<GoRoute> get routes => [
        GoRoute(
            path: '/',
            builder: (context, state) => GraphExamplePage()
            ),

        ///        GoRoute(
        ///          path: '/home',
        ///          builder: (context, state) => const HomePage(),
        ///          routes: [
        ///            GoRoute(
        ///              path: 'settings',
        ///              builder: (context, state) => const SettingsPage(),
        ///            ),
        ///            GoRoute(
        ///              path: 'chat',
        ///              builder: (context, state) => const ChatOnlyPage(),
        ///            ),
        ///          ],
        ///        ),
        ///        GoRoute(
        ///          path: '/new_account',
        ///          builder: (context, state) => const NewAccountPage(),
        ///          routes: [
        ///            GoRoute(
        ///              path: 'settings',
        ///              builder: (context, state) => const SettingsPage(),
        ///            ),
        ///          ],
        ///        ),
        GoRoute(
          path: '/developer',
          builder: (context, state) => const DeveloperPage(),
        )
      ];

  ///////////////////////////////////////////////////////////////////////////
  /// Listenable

  /// Adds [GoRouter]'s listener as specified by its [Listenable].
  /// [GoRouteInformationProvider] uses this method on creation to handle its
  /// internal [ChangeNotifier].
  /// Check out the internal implementation of [GoRouter] and
  /// [GoRouteInformationProvider] to see this in action.
  @override
  void addListener(VoidCallback listener) {
    routerListener = listener;
  }

  /// Removes [GoRouter]'s listener as specified by its [Listenable].
  /// [GoRouteInformationProvider] uses this method when disposing,
  /// so that it removes its callback when destroyed.
  /// Check out the internal implementation of [GoRouter] and
  /// [GoRouteInformationProvider] to see this in action.
  @override
  void removeListener(VoidCallback listener) {
    routerListener = null;
  }
}
