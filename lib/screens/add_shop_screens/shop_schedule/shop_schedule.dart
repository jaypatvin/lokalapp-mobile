import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lokalapp/providers/schedule.dart';
import 'package:lokalapp/screens/add_shop_screens/components/condensed_operating_hours.dart';
import 'package:lokalapp/screens/add_shop_screens/components/operating_hours.dart';
import 'package:lokalapp/screens/add_shop_screens/shop_schedule/customize_availability.dart';
import 'package:provider/provider.dart';

import '../../../utils/calendar_picker/calendar_picker.dart';
import '../../../utils/calendar_picker/classes/schedule_list.dart';
import '../../../utils/calendar_picker/weekday_picker.dart';
import '../../../utils/themes.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/rounded_button.dart';

// TODO: create state holder using provider for schedule to be used by calendar and weekday picker
// this will also remove textediting controller, dropdown value, and markedDays
class ShopSchedule extends StatefulWidget {
  @override
  _ShopScheduleState createState() => _ShopScheduleState();
}

class _ShopScheduleState extends State<ShopSchedule> {
  List<int> _markedDaysMap = [];
  DateTime startDate;
  ScheduleList _markedStartDate = ScheduleList([]);
  bool isPressed = false;
  List<String> repeatChoices = ['Days', 'Weeks', 'Months'];

  @override
  initState() {
    var sched = Provider.of<Schedule>(context);
    sched.dropDownValue = repeatChoices[0];

    super.initState();
  }

  Future<DateTime> showCalendarPicker() async {
    var sched = Provider.of<Schedule>(context, listen: false);
    var date = DateTime.now();
    await showDialog<DateTime>(
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
                    height: MediaQuery.of(context).size.height * 0.58,
                    padding: EdgeInsets.all(5.0),
                    child: CalendarCarousel(
                      onDayPressed: (day) {
                        date = day;
                        //Navigator.pop(context, day);
                        setState(() {
                          _markedStartDate
                            ..clear()
                            ..add(day);
                        });
                      },
                      markedDatesMap: _markedStartDate,
                      selectableDaysMap: sched.dropDownValue == "Weeks"
                          ? _markedDaysMap
                          : [1, 2, 3, 4, 5, 6, 7],
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
                              ..add(startDate);
                            Navigator.pop(context, startDate);
                          },
                        ),
                        RoundedButton(
                          label: "Confirm",
                          fontColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              startDate = date;
                            });
                            Navigator.pop(context, startDate);
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
    return startDate;
  }

  Widget startDatePicker() {
    var sched = Provider.of<Schedule>(context);
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
            label: startDate != null
                ? DateFormat.MMMMd().format(startDate)
                : "Select Start Date",
            onPressed:
                sched.dropDownValue != "Weeks" || _markedDaysMap.isNotEmpty
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
    var controller = Provider.of<Schedule>(context);
    var dropDownValue = Provider.of<Schedule>(context).getDropDownVal;
    final onChange = Provider.of<Schedule>(context);
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
            onChanged: (text) => controller.setDisplayText(text),
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
              child: DropdownButton<String>(
                items: repeatChoices.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      int.tryParse(controller.getRepeatController) == 1
                          ? value.substring(0, value.length - 1)
                          : value,
                    ),
                  );
                }).toList(),
                value: dropDownValue,
                onChanged: (value) {
                  onChange.setDropDownValues(value);
                },
                style: kTextStyle.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  button(width) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          Container(
            height: 43,
            width: width,
            padding: const EdgeInsets.all(2),
            child: FlatButton(
              color: kTealColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: kTealColor),
              ),
              textColor: Colors.black,
              child: Text(
                "Confirm",
                style: TextStyle(
                  fontFamily: "Goldplay",
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomizeAvailability()));
              },
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var sched = Provider.of<Schedule>(context, listen: false);
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
            children: [
              SizedBox(
                height: 20,
              ),
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
              SizedBox(height: height * 0.07),
              Visibility(
                visible: sched.dropDownValue == 'Weeks',
                child: Column(
                  children: [
                    WeekdayPicker(
                      onDayPressed: (int index) {
                        if (_markedDaysMap.contains(index)) {
                          setState(() {
                            _markedDaysMap.remove(index);
                            if (_markedStartDate.schedule.isEmpty) return;
                            var markedStart = _markedStartDate.schedule.first;
                            var startDay = markedStart.weekday;
                            if (startDay == 7) startDay = 0;
                            if (startDay == index) _markedStartDate.clear();

                            int day = startDate.weekday;
                            if (day == 7) day = 0;
                            if (day == index) {
                              for (DateTime indexDay = DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day);
                                  indexDay.month <= DateTime.now().month + 1;
                                  indexDay = indexDay.add(Duration(days: 1))) {
                                int day = indexDay.weekday;
                                if (day == 7) day = 0;
                                if (_markedDaysMap.contains(day)) {
                                  startDate = indexDay;
                                  return;
                                } else
                                  startDate = null;
                              }
                            }
                          });
                        } else {
                          setState(() {
                            _markedDaysMap.add(index);
                            if (_markedStartDate.schedule.isNotEmpty) return;
                            for (DateTime indexDay = DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day);
                                indexDay.month <= DateTime.now().month + 1;
                                indexDay = indexDay.add(Duration(days: 1))) {
                              int day = indexDay.weekday;
                              if (day == 7) day = 0;
                              if (day == index) {
                                startDate = indexDay;
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
              startDatePicker(),
              SizedBox(height: height * 0.08),
              // SizedBox(height: height * 0.02),
              Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Hours",
                    style: kTextStyle.copyWith(fontSize: 22.0),
                  )),
              CondensedOperatingHours(
                day: "From:",
              ),
              SizedBox(
                height: height * 0.1,
              ),
              button(width * 0.7),
              SizedBox(
                height: height * 0.3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
