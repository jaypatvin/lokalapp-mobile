import 'package:flutter/foundation.dart';

import '../../models/operating_hours.dart';
import '../../models/post_requests/shop/operating_hours.request.dart';

class OperatingHoursBody extends ChangeNotifier {
  OperatingHoursRequest _body = const OperatingHoursRequest();

  OperatingHoursRequest get request => _body;

  void update({
    String? startTime,
    String? endTime,
    String? repeatType,
    int? repeatUnit,
    List<String>? startDates,
    List<String>? unavailableDates,
    List<CustomDates>? customDates,
    bool notify = true,
  }) {
    _body = _body.copyWith(
      startTime: startTime,
      endTime: endTime,
      repeatType: repeatType,
      repeatUnit: repeatUnit,
      startDates: startDates,
      unavailableDates: unavailableDates,
      customDates: customDates,
    );
    if (notify) notifyListeners();
  }

  void clear({bool notify = true}) {
    _body = const OperatingHoursRequest();
    if (notify) notifyListeners();
  }
}
