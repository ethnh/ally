// XXX Eliminate this when we have ValueChanged
import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


const int ticksPerContactInvitationCheck = 5;
const int ticksPerNewMessageCheck = 5;

class BackgroundTicker extends ConsumerStatefulWidget {
  const BackgroundTicker({required this.builder, super.key});

  final Widget Function(BuildContext) builder;

  @override
  BackgroundTickerState createState() => BackgroundTickerState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<Widget Function(BuildContext p1)>.has(
        'builder', builder));
  }
}

class BackgroundTickerState extends ConsumerState<BackgroundTicker> {
  Timer? _tickTimer;
  bool _inTick = false;
  int _contactInvitationCheckTick = 0;
  int _newMessageCheckTick = 0;
  bool _hasRefreshedContactList = false;

  @override
  void initState() {
    super.initState();
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_inTick) {
        unawaited(_onTick());
      }
    });
  }

  @override
  void dispose() {
    final tickTimer = _tickTimer;
    if (tickTimer != null) {
      tickTimer.cancel();
    }

    super.dispose();
  }

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  Future<void> _onTick() async {
    _inTick = true;
    try {
    } finally {
      _inTick = false;
    }
  }

  Future<void> _doContactListRefresh() async {
    return; // rip-and-tear
  }

  Future<void> _doContactInvitationCheck() async {
    return; // rip-and-tear
  }

  Future<void> _doNewMessageCheck() async {
    return; // rip-and-tear
  }
}
