import '../models/post_requests/shared/application_log.dart';
import 'api/api.dart';
import 'api/application_log_service.dart';
import 'device_info_provider.dart';

class ApplicationLogger {
  /// Logs [ApplicationLog] with the [ApplicationLogsService]
  factory ApplicationLogger({
    required API api,
    required DeviceInfoProvider deviceInfo,
  }) =>
      ApplicationLogger._(ApplicationLogsService(api), deviceInfo);

  ApplicationLogger._(
    this.service,
    this._deviceInfo,
  );

  final ApplicationLogsService service;
  final DeviceInfoProvider _deviceInfo;

  String? communityId;

  Future<bool> log({
    required ActionTypes actionType,
    String? communityId,
    Map<String, dynamic>? metaData,
  }) {
    return service.log(
      log: ApplicationLog(
        communityId: communityId ?? this.communityId ?? 'no-community-id',
        actionType: actionType,
        deviceId: '${_deviceInfo.deviceModel}: '
            '${_deviceInfo.deviceId ?? 'no-device-id'}',
        metadata: metaData,
      ),
    );
  }
}