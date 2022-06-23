import 'dart:developer' as dev;

import 'package:flutter/material.dart';

class DeviceInfoProvider extends ChangeNotifier {
  String? _deviceId;
  String? get deviceId => _deviceId;

  String? _deviceModel;
  String? get deviceModel => _deviceModel;

  void setDeviceId(String? value) {
    _deviceId = value;
    dev.log(_deviceId ?? 'empty device id');
    notifyListeners();
  }

  void setDeviceModel(String? value) {
    _deviceModel = value;
    dev.log(_deviceId ?? 'empty device model');
    notifyListeners();
  }
}
