import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';

import '../../providers/post_requests/operating_hours_body.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../utils/functions.utils.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/rounded_button.dart';
import '../../widgets/schedule_picker.dart';
import 'customize_availability.dart';

class ShopSchedule extends StatefulWidget {
  final File shopPhoto;
  final bool forEditing;
  final Function() onShopEdit;

  const ShopSchedule(
    this.shopPhoto, {
    this.forEditing = false,
    this.onShopEdit,
  });

  @override
  _ShopScheduleState createState() => _ShopScheduleState();
}

class _ShopScheduleState extends State<ShopSchedule> {
  TimeOfDay _opening = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _closing = TimeOfDay(hour: 17, minute: 0);
  DateTime _startDate;
  List<int> _selectableDays = [];

  @override
  void initState() {
    super.initState();

    final user = context.read<CurrentUser>();
    final shops = context.read<Shops>().findByUser(user.id);

    if (shops.isNotEmpty) {
      final shop = shops.first;
      if (isValidOperatingHours(shop.operatingHours)) {
        _opening = stringToTimeOfDay(shop.operatingHours.startTime);
        _closing = stringToTimeOfDay(shop.operatingHours.endTime);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.read<OperatingHoursBody>().update(
          startTime: getTimeOfDayString(_opening),
          endTime: getTimeOfDayString(_closing),
        );
  }

  void _onStartDatesChangedHandler(List<DateTime> dates, String repeatType) {
    if (dates.isEmpty) {
      this._startDate = null;
    } else {
      this._startDate = dates.first;
    }

    context.read<OperatingHoursBody>().update(
          startDates: dates
              .map<String>(
                (date) => DateFormat("yyyy-MM-dd").format(
                  date ?? DateTime.now(),
                ),
              )
              .toList(),
          repeatType: repeatType,
        );
  }

  Future<void> _selectTime(
    TimeOfDay initialTime,
    Function(TimeOfDay) onSet,
  ) async {
    final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime ?? TimeOfDay.now(),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (pickedTime != null) onSet(pickedTime);
  }

  void _onSelectableDaysChanged(List<int> selectableDays) {
    this._selectableDays = selectableDays;
  }

  RepeatChoices _getRepeatChoice() {
    final repeatType =
        context.read<OperatingHoursBody>().operatingHours.repeatType;
    var repeatChoice = RepeatChoices.month;
    if (repeatType.split("-").length <= 1) {
      RepeatChoices.values.forEach((choice) {
        if (choice.value.toLowerCase() == repeatType) {
          repeatChoice = choice;
        }
      });
    }
    return repeatChoice;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<CurrentUser>();
    final shops = context.read<Shops>().findByUser(user.id);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
          titleText: "Shop Schedule",
          titleStyle: TextStyle(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          leadingColor: Colors.black,
          elevation: 0.0,
          onPressedLeading: () {
            Navigator.pop(context);
          }),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SchedulePicker(
                header: "Days Available",
                description: "Set your shop's availability",
                operatingHours:
                    shops.isNotEmpty ? shops.first.operatingHours : null,
                onStartDatesChanged: _onStartDatesChangedHandler,
                // onStartDateChanged: _onStartDateChanged,
                onRepeatTypeChanged: (repeatType) => context
                    .read<OperatingHoursBody>()
                    .update(repeatType: repeatType),
                onRepeatUnitChanged: (repeatUnit) => context
                    .read<OperatingHoursBody>()
                    .update(repeatUnit: repeatUnit),
                onSelectableDaysChanged: _onSelectableDaysChanged,
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Text(
                "Hours",
                style: kTextStyle.copyWith(fontSize: 24.0),
              ),
              SizedBox(height: height * 0.02),
              _HoursPicker(
                opening: this._opening,
                closing: this._closing,
                onSelectOpening: () {
                  _selectTime(this._opening, (pickedTime) {
                    if (pickedTime == _opening) return;
                    setState(() {
                      _opening = pickedTime;
                    });
                    context
                        .read<OperatingHoursBody>()
                        .update(startTime: getTimeOfDayString(_opening));
                  });
                },
                onSelectClosing: () {
                  _selectTime(this._closing, (pickedTime) {
                    if (pickedTime == _closing) return;
                    setState(() {
                      _closing = pickedTime;
                    });
                    context
                        .read<OperatingHoursBody>()
                        .update(endTime: getTimeOfDayString(_closing));
                  });
                },
              ),
              SizedBox(height: height * 0.05),
              RoundedButton(
                label: "Confirm",
                height: 10,
                minWidth: double.infinity,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: "GoldplayBold",
                fontColor: Colors.white,
                onPressed: () {
                  final operatingHours =
                      context.read<OperatingHoursBody>().operatingHours;
                  final startDates = operatingHours.startDates;
                  final repeatUnit = operatingHours.repeatUnit;
                  if (startDates == null || startDates.isEmpty) {
                    final snackBar = SnackBar(
                      content: Text("Select a start date"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }

                  if (repeatUnit == null || repeatUnit <= 0) {
                    final snackBar = SnackBar(
                      content: Text("Enter a valid repeat number."),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => CustomizeAvailability(
                        repeatChoice: this._getRepeatChoice(),
                        repeatEvery: context
                            .read<OperatingHoursBody>()
                            .operatingHours
                            .repeatUnit,
                        selectableDays: this._selectableDays,
                        startDate: this._startDate ?? DateTime.now(),
                        shopPhoto: widget.shopPhoto,
                        usedDatePicker: context
                                .read<OperatingHoursBody>()
                                .operatingHours
                                .repeatType
                                .split("-")
                                .length <=
                            1,
                        forEditing: widget.forEditing,
                        onShopEdit: widget.onShopEdit,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HoursPicker extends StatelessWidget {
  final TimeOfDay opening;
  final TimeOfDay closing;
  final void Function() onSelectOpening;
  final void Function() onSelectClosing;

  const _HoursPicker({
    Key key,
    @required this.opening,
    @required this.closing,
    @required this.onSelectOpening,
    @required this.onSelectClosing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizedBox spacerBox = SizedBox(
      width: MediaQuery.of(context).size.width * 0.03,
    );
    return Row(
      children: [
        Text(
          "Every",
          style: kTextStyle.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 20.0,
          ),
        ),
        spacerBox,
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: Colors.transparent,
              ),
              color: Colors.grey[200],
            ),
            child: TextButton(
              onPressed: this.onSelectOpening,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      getTimeOfDayString(this.opening),
                      style: kTextStyle.copyWith(
                        fontWeight: FontWeight.normal,
                        //fontSize: 18.0,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_sharp,
                    color: kTealColor,
                  ),
                ],
              ),
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
            ),
          ),
        ),
        spacerBox,
        Text(
          "To",
          style: kTextStyle.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 20.0,
          ),
        ),
        spacerBox,
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: Colors.transparent,
              ),
              color: Colors.grey[200],
            ),
            child: TextButton(
              onPressed: this.onSelectClosing,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      getTimeOfDayString(this.closing),
                      style: kTextStyle.copyWith(
                        fontWeight: FontWeight.normal,
                        //fontSize: 18.0,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_sharp,
                    color: kTealColor,
                  ),
                ],
              ),
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
