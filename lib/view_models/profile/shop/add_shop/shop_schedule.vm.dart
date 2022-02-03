import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../../providers/auth.dart';
import '../../../../providers/post_requests/operating_hours_body.dart';
import '../../../../providers/shops.dart';
import '../../../../routers/app_router.dart';
import '../../../../routers/profile/props/customize_availability.props.dart';
import '../../../../screens/profile/add_shop/customize_availability.dart';
import '../../../../state/view_model.dart';
import '../../../../utils/functions.utils.dart';
import '../../../../widgets/schedule_picker.dart';

class ShopScheduleViewModel extends ViewModel {
  ShopScheduleViewModel({
    this.shopPhoto,
    this.forEditing = false,
    this.onShopEdit,
  });

  late TimeOfDay _opening;
  TimeOfDay get opening => _opening;

  late TimeOfDay _closing;
  TimeOfDay get closing => _closing;

  DateTime? _startDate;
  DateTime? get startDate => _startDate;

  List<int> _selectableDays = [];
  List<int> get selectableDays => _selectableDays;

  final File? shopPhoto;
  final bool forEditing;
  final Function()? onShopEdit;

  @override
  void init() {
    super.init();

    final user = context.read<Auth>().user!;
    final shops = context.read<Shops>().findByUser(user.id);

    if (shops.isNotEmpty) {
      final shop = shops.first;
      if (isValidOperatingHours(shop.operatingHours)) {
        final operatingHours = shop.operatingHours;
        _opening = stringToTimeOfDay(operatingHours.startTime!);
        _closing = stringToTimeOfDay(operatingHours.endTime!);
        context.read<OperatingHoursBody>().update(
              startTime: getTimeOfDayString(_opening),
              endTime: getTimeOfDayString(_closing),
              repeatType: operatingHours.repeatType,
              repeatUnit: operatingHours.repeatUnit,
              startDates: operatingHours.startDates,
              unavailableDates: operatingHours.unavailableDates,
              customDates: operatingHours.customDates,
              notify: false,
            );
      }
    } else {
      _opening = const TimeOfDay(hour: 8, minute: 0);
      _closing = const TimeOfDay(hour: 17, minute: 0);
      context.read<OperatingHoursBody>().update(
            startTime: getTimeOfDayString(_opening),
            endTime: getTimeOfDayString(_closing),
            notify: false,
          );
    }
  }

  void onStartDatesChangedHandler(
    List<DateTime> dates,
    String repeatType,
  ) {
    if (dates.isEmpty) {
      _startDate = null;
    } else {
      _startDate = dates.first;
    }

    context.read<OperatingHoursBody>().update(
          startDates: dates
              .map<String>((date) => DateFormat('yyyy-MM-dd').format(date))
              .toList(),
          repeatType: repeatType,
        );
  }

  Future<void> _selectTime(
    TimeOfDay? initialTime,
    Function(TimeOfDay) onSet,
  ) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime != null) onSet(pickedTime);
  }

  void onSelectableDaysChanged(List<int> selectableDays) {
    _selectableDays = selectableDays;
    notifyListeners();
  }

  RepeatChoices _getRepeatChoice() {
    final repeatType =
        context.read<OperatingHoursBody>().operatingHours.repeatType!;
    var repeatChoice = RepeatChoices.month;
    if (repeatType.split('-').length <= 1) {
      for (final choice in RepeatChoices.values) {
        if (choice.value.toLowerCase() == repeatType) {
          repeatChoice = choice;
        }
      }
    }
    return repeatChoice;
  }

  void onSelectOpening() {
    _selectTime(_opening, (pickedTime) {
      if (pickedTime == _opening) return;
      _opening = pickedTime;
      context
          .read<OperatingHoursBody>()
          .update(startTime: getTimeOfDayString(_opening));
      notifyListeners();
    });
  }

  Future<void> onSelectClosing() async {
    await _selectTime(_closing, (pickedTime) {
      if (pickedTime == _closing) return;
      _closing = pickedTime;
      context
          .read<OperatingHoursBody>()
          .update(endTime: getTimeOfDayString(_closing));
      notifyListeners();
    });
  }

  void onConfirm() {
    final operatingHours = context.read<OperatingHoursBody>().operatingHours;
    final startDates = operatingHours.startDates;
    final repeatUnit = operatingHours.repeatUnit;
    if (startDates == null || startDates.isEmpty) {
      showToast('Select a start date.');
      return;
    }

    if (repeatUnit == null || repeatUnit <= 0) {
      showToast('Enter a valid repeat number.');
      return;
    }
    context.read<AppRouter>().navigateTo(
          AppRoute.profile,
          CustomizeAvailability.routeName,
          arguments: CustomizeAvailabilityProps(
            repeatChoice: _getRepeatChoice(),
            repeatEvery:
                context.read<OperatingHoursBody>().operatingHours.repeatUnit,
            selectableDays: _selectableDays,
            startDate: _startDate ?? DateTime.now(),
            shopPhoto: shopPhoto,
            usedDatePicker: context
                    .read<OperatingHoursBody>()
                    .operatingHours
                    .repeatType!
                    .split('-')
                    .length <=
                1,
            forEditing: forEditing,
            onShopEdit: onShopEdit,
          ),
        );
  }
}
