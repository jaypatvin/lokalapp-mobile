import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../services/device_info_provider.dart';

/// This widget needs a [Provider] of [DeviceInfoProvider] up in the widget
/// tree.
class DeviceInfo extends HookWidget {
  const DeviceInfo({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final deviceInfoPlugin =
        useMemoized<DeviceInfoPlugin>(() => DeviceInfoPlugin());

    final initPlatformState = useCallback(
      () async {
        String? deviceId;
        String? deviceModel;
        try {
          if (Platform.isAndroid) {
            final info = await deviceInfoPlugin.androidInfo;
            // TODO: update this for application logs
            // No androidId for newest Android versions
            deviceId = info.id;
            deviceModel = info.device;
          } else if (Platform.isIOS) {
            final info = await deviceInfoPlugin.iosInfo;
            deviceId = info.identifierForVendor;
            deviceModel = info.model;
          } else {
            deviceId = 'Using a device outside of supported devices';
          }
        } on PlatformException catch (e, stack) {
          deviceId = 'Failed to get platform ID.';
          FirebaseCrashlytics.instance.recordError(e, stack);
        }

        context.read<DeviceInfoProvider>()
          ..setDeviceId(deviceId)
          ..setDeviceModel(deviceModel);
      },
      [],
    );

    useEffect(
      () {
        initPlatformState();
        return () {};
      },
      [],
    );

    return child;
  }
}

// class DeviceInfo extends StatefulWidget {
//   /// This widget needs a [Provider] of [DeviceInfoProvider] up in the widget
//   /// tree.
//   const DeviceInfo({Key? key}) : super(key: key);

//   @override
//   State<DeviceInfo> createState() => _DeviceInfoState();
// }

// class _DeviceInfoState extends State<DeviceInfo> {
//   static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
//   String? _deviceId;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> initPlatformState() async {
//     String? deviceId;
//     try {
//       if (Platform.isAndroid) {
//         deviceId = (await _deviceInfoPlugin.androidInfo).androidId;
//       } else if (Platform.isIOS) {
//         deviceId = (await _deviceInfoPlugin.iosInfo).identifierForVendor;
//       } else {
//         deviceId = 'Using a device outside of supported devices';
//       }
//     } on PlatformException catch (e, stack) {
//       deviceId = 'Failed to get platform ID.';
//       FirebaseCrashlytics.instance.recordError(e, stack);
//     }
//     if (!mounted) return;
//     setState(() {
//       _deviceId = deviceId;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
