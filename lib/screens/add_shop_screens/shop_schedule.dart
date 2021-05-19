import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';

import '../../models/operating_hours.dart';
import '../../providers/post_requests/operating_hours_body.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../utils/calendar_picker/calendar_picker.dart';
import '../../utils/calendar_picker/day_of_month_picker.dart';
import '../../utils/calendar_picker/weekday_picker.dart';
import '../../utils/functions.utils.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/rounded_button.dart';
import 'customize_availability.dart';
import 'shop_schedule/repeat_choices.dart';

class ShopSchedule extends StatefulWidget {
  final File shopPhoto;

  const ShopSchedule(this.shopPhoto);

  @override
  _ShopScheduleState createState() => _ShopScheduleState();
}

class _ShopScheduleState extends State<ShopSchedule> {
  TextEditingController repeatController = TextEditingController();
  RepeatChoices repeatChoice;
  TimeOfDay _opening;
  TimeOfDay _closing;

  // Days and Weeks
  List<int> _markedDaysMap = [];
  DateTime _startDate;
  List<DateTime> _markedStartDate = [];

  // MONTH
  int _markedStartDayOfMonth = 0;
  int _startDayOfMonth = 0;
  List<String> _ordinalNumbers = [
    "First",
    "Second",
    "Third",
    "Fourth",
    "Fifth"
  ];
  String _ordinalChoice;
  String _monthDayChoice;
  String _monthChoice;
  // this will be used to determine if user used the date picker
  // or used the dropdown buttons for start date of month repeatability
  bool _usedDatePicker = false;

  @override
  initState() {
    super.initState();
    OperatingHours _operatingHours;

    var user = Provider.of<CurrentUser>(context, listen: false);
    var shops = Provider.of<Shops>(context, listen: false).findByUser(user.id);
    if (shops.isNotEmpty) _operatingHours = shops.first.operatingHours;

    if (_operatingHours == null) {
      repeatChoice = RepeatChoices.day;
      _opening = TimeOfDay(hour: 8, minute: 0);
      _closing = TimeOfDay(hour: 17, minute: 0);

      _ordinalChoice = _ordinalNumbers[0];
      var day = DateTime.now().weekday;
      if (day == 0) day = 7;
      _monthDayChoice = en_USSymbols.WEEKDAYS[day];
      _monthChoice = en_USSymbols.MONTHS[DateTime.now().month - 1];
    } else {
      RepeatChoices.values.forEach((element) {
        // Common:
        if (element.value.toLowerCase() == _operatingHours.repeatType) {
          repeatChoice = element;
        }
      });
      repeatController.text = _operatingHours.repeatUnit.toString();
      _opening = stringToTimeOfDay(_operatingHours.startTime);
      _closing = stringToTimeOfDay(_operatingHours.endTime);

      // Day and week:
      _startDate = DateFormat("yyyy-MM-dd").parse(
        _operatingHours.startDates.first,
      );
      _markedStartDate = [_startDate];

      // Month:
      var _ordinal = 0;
      _markedStartDayOfMonth = _startDayOfMonth = _startDate.day;
      for (var indexDay = DateTime(_startDate.year, _startDate.month, 1);
          indexDay.day <= _startDate.day;
          indexDay = indexDay.add(Duration(days: 1)),) {
        if (indexDay.weekday == _startDate.weekday) {
          _ordinal++;
        }
      }
      _ordinalChoice = _ordinalNumbers[_ordinal - 1];
      _monthChoice = en_USSymbols.MONTHS[_startDate.month - 1];
      var _weekday = _startDate.weekday;
      if (_weekday == 7) _weekday = 7;
      _monthDayChoice = en_USSymbols.WEEKDAYS[_weekday];
    }
  }

  // MONTH STATE:
  /* ------------------------------------------------------------------------ */
  Future<int> showDayOfMonthPicker() async {
    return await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Center(
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text(
                        "Start Date",
                        style: kTextStyle.copyWith(
                          fontSize: 24.0,
                        ),
                      ),
                      DayOfMonthPicker(
                        width: MediaQuery.of(context).size.width * 0.95,
                        padding: EdgeInsets.all(5.0),
                        onDayPressed: (day) {
                          setState(() {
                            if (_markedStartDayOfMonth == day) {
                              _markedStartDayOfMonth = 0;
                            } else {
                              _markedStartDayOfMonth = day;
                            }
                          });
                        },
                        markedDay: _markedStartDayOfMonth,
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.05),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RoundedButton(
                              label: "Cancel",
                              color: Color(
                                0xFFF1FAFF,
                              ),
                              onPressed: () {
                                _markedStartDayOfMonth = _startDayOfMonth;
                                Navigator.pop(context, _startDayOfMonth);
                              },
                            ),
                            RoundedButton(
                              label: "Confirm",
                              fontColor: Colors.white,
                              onPressed: () {
                                this.setState(() {
                                  _startDayOfMonth = _markedStartDayOfMonth;
                                });
                                _usedDatePicker = true;
                                setMonthStartDate(day: _startDayOfMonth);
                                Navigator.pop(context, this._startDayOfMonth);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // to be shown when Month is chosen as repeatChoice
  Widget buildDayOfMonthBody() {
    var height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RoundedButton(
          textAlign: TextAlign.start,
          minWidth: double.infinity,
          label: _startDayOfMonth == 0
              ? 'Select Start Day'
              : '${getOrdinal(_startDayOfMonth)} of the month',
          onPressed: showDayOfMonthPicker,
          fontColor: Colors.white,
          fontSize: 20.0,
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.01),
            child: Text(
              'or',
              style: kTextStyle.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  color: Colors.grey[200],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: _ordinalNumbers.map((String choice) {
                      return DropdownMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList(),
                    value: _ordinalChoice,
                    onChanged: (value) {
                      setState(() {
                        _ordinalChoice = value;
                      });
                      _usedDatePicker = false;
                      setMonthDayOfWeek();
                    },
                    style: kTextStyle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  color: Colors.grey[200],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: en_USSymbols.WEEKDAYS.map((String choice) {
                      return DropdownMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList(),
                    value: _monthDayChoice,
                    onChanged: (value) {
                      setState(() {
                        _monthDayChoice = value;
                      });
                      _usedDatePicker = false;
                      setMonthDayOfWeek();
                    },
                    style: kTextStyle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Row(
          children: [
            Text(
              'Start Month',
              style: kTextStyle.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  color: Colors.grey[200],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: en_USSymbols.MONTHS.map((String choice) {
                      return DropdownMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList(),
                    value: _monthChoice,
                    onChanged: (value) {
                      var month = en_USSymbols.MONTHS.indexOf(_monthChoice);

                      setState(() {
                        _monthChoice = value;
                      });

                      if (_usedDatePicker) {
                        setMonthStartDate(month: month + 1);
                      } else {
                        setMonthDayOfWeek();
                      }
                    },
                    style: kTextStyle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // change state functions
  String getOrdinal(int input) {
    int value = input % 100;

    if (3 < value && value < 21) {
      return "${input}th";
    }

    switch (input % 10) {
      case 1:
        return "${input}st";
      case 2:
        return "${input}nd";
      case 3:
        return "${input}rd";
      default:
        return "${input}th";
    }
  }

  void setMonthStartDate({int day, int month}) {
    _startDate ??= DateTime.now();

    setState(() {
      _startDate = DateTime(
        _startDate.year,
        month ?? _startDate.month,
        day ?? _startDate.day,
      );
    });
  }

  void setMonthDayOfWeek() {
    setState(() {
      _startDate = null;
      _startDayOfMonth = 0;
    });
  }
  /* ------------------------------------------------------------------------ */

  Future<DateTime> showCalendarPicker() async {
    return await showDialog<DateTime>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    "Start Date",
                    style: kTextStyle.copyWith(
                      fontSize: 24.0,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.56,
                    padding: EdgeInsets.all(5.0),
                    child: CalendarCarousel(
                      width: MediaQuery.of(context).size.width * 0.95,
                      onDayPressed: (day) {
                        setState(() {
                          if (_markedStartDate.contains(day)) {
                            _markedStartDate.clear();
                          } else {
                            _markedStartDate
                              ..clear()
                              ..add(day);
                          }
                        });
                      },
                      markedDatesMap: _markedStartDate,
                      selectableDaysMap: repeatChoice == RepeatChoices.week
                          ? _markedDaysMap
                          : [1, 2, 3, 4, 5, 6, 0],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.05),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RoundedButton(
                          label: "Cancel",
                          color: Color(
                            0xFFF1FAFF,
                          ),
                          onPressed: () {
                            _markedStartDate
                              ..clear()
                              ..add(_startDate);
                            Navigator.pop(context, _startDate);
                          },
                        ),
                        RoundedButton(
                          label: "Confirm",
                          fontColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              if (_markedStartDate.isNotEmpty)
                                _startDate = _markedStartDate.first;
                              else
                                _startDate = null;
                            });
                            Navigator.pop(context, _startDate);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget startDatePicker() {
    return Row(
      children: [
        Text(
          "Start date",
          style: kTextStyle.copyWith(
              fontWeight: FontWeight.normal, fontSize: 18.0),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
        ),
        Expanded(
          child: RoundedButton(
            textAlign: TextAlign.start,
            minWidth: double.infinity,
            label: _startDate != null
                ? DateFormat.MMMMd().format(_startDate)
                : "Select Start Date",
            onPressed:
                repeatChoice != RepeatChoices.week || _markedDaysMap.isNotEmpty
                    ? showCalendarPicker
                    : null,
            fontColor: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }

  Widget repeatabilityPicker() {
    return Row(
      children: [
        Text(
          "Every",
          style: kTextStyle.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 20.0,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: TextField(
            controller: repeatController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            textAlign: TextAlign.center,
            style: kTextStyle.copyWith(
              color: kTealColor,
              fontSize: 32.0,
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: Colors.transparent,
              ),
              color: Colors.grey[200],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<RepeatChoices>(
                items: RepeatChoices.values.map((RepeatChoices choice) {
                  return DropdownMenuItem<RepeatChoices>(
                    value: choice,
                    child: Text(
                      int.tryParse(repeatController.text) == 1
                          ? choice.value
                          : choice.value + "s",
                    ),
                  );
                }).toList(),
                value: repeatChoice,
                onChanged: (choice) {
                  setState(() {
                    repeatChoice = choice;
                  });
                },
                style: kTextStyle.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> selectTime(
      TimeOfDay initialTime, Function(TimeOfDay) onSet) async {
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

  Widget hoursPicker() {
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
              onPressed: () {
                selectTime(this._opening, (pickedTime) {
                  if (pickedTime == _opening) return;
                  setState(() {
                    _opening = pickedTime;
                  });
                });
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      getTimeOfDayString(context, _opening),
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
              onPressed: () {
                selectTime(this._closing, (pickedTime) {
                  if (pickedTime == _closing) return;
                  setState(() {
                    _closing = pickedTime;
                  });
                });
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      getTimeOfDayString(context, _closing),
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

  Widget buildBody() {
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Days Available",
          style: kTextStyle.copyWith(fontSize: 24.0),
        ),
        Text(
          "Set your shop's availability",
          style: kTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
        ),
        SizedBox(
          height: height * 0.02,
        ),
        repeatabilityPicker(),
        SizedBox(height: height * 0.02),
        Visibility(
          visible: repeatChoice == RepeatChoices.week,
          child: Column(
            children: [
              WeekdayPicker(
                onDayPressed: (int index) {
                  if (_markedDaysMap.contains(index)) {
                    setState(() {
                      _markedDaysMap.remove(index);
                      if (_markedStartDate.isEmpty) return;
                      var markedStart = _markedStartDate.first;
                      var startDay = markedStart.weekday;
                      if (startDay == 7) startDay = 0;
                      if (startDay == index) _markedStartDate.clear();

                      int day = _startDate.weekday;
                      if (day == 7) day = 0;
                      if (day == index) {
                        for (DateTime indexDay = DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day);
                            indexDay.month <= DateTime.now().month + 1;
                            indexDay = indexDay.add(Duration(days: 1))) {
                          int day = indexDay.weekday;
                          if (day == 7) day = 0;
                          if (_markedDaysMap.contains(day)) {
                            _startDate = indexDay;
                            return;
                          } else
                            _startDate = null;
                        }
                      }
                    });
                  } else {
                    setState(() {
                      _markedDaysMap.add(index);
                      if (_markedStartDate.isNotEmpty) return;
                      for (DateTime indexDay = DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day);
                          indexDay.month <= DateTime.now().month + 1;
                          indexDay = indexDay.add(Duration(days: 1))) {
                        int day = indexDay.weekday;
                        if (day == 7) day = 0;
                        if (day == index) {
                          _startDate = indexDay;
                          _markedStartDate.add(indexDay);
                          return;
                        }
                      }
                    });
                  }
                },
                markedDaysMap: _markedDaysMap,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Visibility(
                visible: _markedDaysMap.isEmpty,
                child: Text(
                  "Select a day or days to repeat every week",
                  style: kTextStyle.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
            ],
          ),
        ),
        Visibility(
          visible: repeatChoice != RepeatChoices.month,
          child: startDatePicker(),
        ),
        Visibility(
          visible: repeatChoice == RepeatChoices.month,
          child: buildDayOfMonthBody(),
        ),
        SizedBox(
          height: height * 0.05,
        ),
        Text(
          "Hours",
          style: kTextStyle.copyWith(fontSize: 24.0),
        ),
        SizedBox(
          height: height * 0.02,
        ),
        hoursPicker(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(
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
              buildBody(),
              SizedBox(
                height: height * 0.05,
              ),
              RoundedButton(
                label: "Confirm",
                height: 10,
                minWidth: double.infinity,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: "GoldplayBold",
                fontColor: Colors.white,
                onPressed: () {
                  Provider.of<OperatingHoursBody>(context, listen: false)
                      .update(
                    startDates: [
                      DateFormat("yyyy-MM-dd").format(
                        _startDate ?? DateTime.now(),
                      ),
                    ],
                    startTime: getTimeOfDayString(context, _opening),
                    endTime: getTimeOfDayString(context, _closing),
                    repeatType: repeatChoice.value?.toLowerCase(),
                    repeatUnit: int.tryParse(repeatController.text) ?? 1,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => CustomizeAvailability(
                        repeatChoice: this.repeatChoice,
                        repeatEvery: int.tryParse(this.repeatController.text),
                        selectableDays: this._markedDaysMap,
                        startDate: this._startDate ?? DateTime.now(),
                        shopPhoto: widget.shopPhoto,
                        usedDatePicker: _usedDatePicker,
                        monthOrdinal:
                            _ordinalNumbers.indexOf(_ordinalChoice) + 1,
                        monthWeekDay:
                            en_USSymbols.WEEKDAYS.indexOf(_monthDayChoice),
                        startMonth:
                            en_USSymbols.MONTHS.indexOf(_monthChoice) + 1,
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
