import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/activities.dart';
import '../providers/products.dart';
import '../providers/shops.dart';
import '../providers/users.dart';

class StateHandler extends StatefulWidget {
  const StateHandler({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  _StateHandlerState createState() => _StateHandlerState();
}

class _StateHandlerState extends State<StateHandler>
    with WidgetsBindingObserver {
  late final Users _users;
  late final Products _products;
  late final Shops _shops;
  late final Activities _activities;

  @override
  void initState() {
    super.initState();

    _users = context.read<Users>();
    _products = context.read<Products>();
    _shops = context.read<Shops>();
    _activities = context.read<Activities>();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_users.subscriptionListener?.isPaused ?? false) {
          _users.subscriptionListener?.resume();
        }
        if (_shops.subscriptionListener?.isPaused ?? false) {
          _shops.subscriptionListener?.resume();
        }
        if (_activities.subscriptionListener?.isPaused ?? false) {
          _activities.subscriptionListener?.resume();
        }
        if (_products.subscriptionListener?.isPaused ?? false) {
          _products.subscriptionListener?.resume();
        }
        break;
      case AppLifecycleState.paused:
        if (!(_users.subscriptionListener?.isPaused ?? true)) {
          _users.subscriptionListener?.pause();
        }
        if (!(_shops.subscriptionListener?.isPaused ?? true)) {
          _shops.subscriptionListener?.pause();
        }
        if (!(_activities.subscriptionListener?.isPaused ?? true)) {
          _activities.subscriptionListener?.pause();
        }
        if (!(_products.subscriptionListener?.isPaused ?? true)) {
          _products.subscriptionListener?.pause();
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
