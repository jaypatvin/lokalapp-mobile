import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that display a `Text` when there is no internet connection.
class ConnectivityStatus extends StatefulWidget {
  /// A widget that display a `Text` on the bottom of the screen
  /// when there is no internet connection.
  const ConnectivityStatus({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _ConnectivityStatusState createState() => _ConnectivityStatusState();
}

class _ConnectivityStatusState extends State<ConnectivityStatus>
    with WidgetsBindingObserver {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool _hasConnection = false;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _connectivitySubscription.resume();
        initConnectivity();
        break;
      case AppLifecycleState.paused:
        _connectivitySubscription.pause();
        break;
      default:
        break;
    }
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      setState(() {
        _hasConnection = false;
      });
    } else {
      final _status = await checkConnection();
      if (!_status) {
        if (_status != _hasConnection) {
          setState(() {
            _hasConnection = _status;
          });
        }
      }
    }
  }

  Future<bool> checkConnection() async {
    final previousConnection = _hasConnection;
    bool _status = _hasConnection;
    try {
      final result = await InternetAddress.lookup('lokalapp.ph');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _status = true;
      } else {
        _status = false;
      }
    } on SocketException catch (_) {
      _status = false;
    }

    if (previousConnection != _status) {
      setState(() {
        _hasConnection = _status;
      });
    }

    return _status;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: widget.child),
        if (!_hasConnection)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              color: Colors.red.shade300,
              child: Text(
                'No internet connection!',
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
