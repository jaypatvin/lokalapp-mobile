import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lokalapp/utils/calendar_picker/calendar_picker.dart';
import 'package:lokalapp/utils/calendar_picker/classes/schedule_list.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/custom_app_bar.dart';
import 'package:lokalapp/widgets/rounded_button.dart';

class CustomizeAvailability extends StatefulWidget {
  @override
  _CustomizeAvailabilityState createState() => _CustomizeAvailabilityState();
}

class _CustomizeAvailabilityState extends State<CustomizeAvailability> {
  TextEditingController repeatController = TextEditingController();

  final List<String> repeatChoices = ['Days', 'Weeks', 'Months'];

  String dropDownValue;

  List<int> _markedDaysMap = [];

  DateTime startDate;

  ScheduleList _markedStartDate = ScheduleList([]);

  bool caledarPicked = false;
  Widget get buildText => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Customize Availability",
              style: TextStyle(
                  fontFamily: "Goldplay",
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text("Customize which days your shop will be available."),
          ),
        ],
      );

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
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: kTealColor),
              ),
              textColor: Colors.black,
              child: Text(
                "Customize Availability",
                style: TextStyle(
                  fontFamily: "Goldplay",
                  fontSize: 14,
                  color: kTealColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                showCalendarPicker();
              },
            ),
          ),
        ],
      );

  buttonSkip(width) => Row(
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
                caledarPicked ? "Confirm" : "Skip",
                style: TextStyle(
                  fontFamily: "Goldplay",
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {},
            ),
          ),
        ],
      );

  Future<DateTime> showCalendarPicker() async {
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
                      selectableDaysMap: dropDownValue == "Weeks"
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
                              caledarPicked = true;
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
            onPressed: dropDownValue != "Weeks" || _markedDaysMap.isNotEmpty
                ? showCalendarPicker
                : null,
            fontColor: Colors.white,
            fontSize: 20.0,
          ),
        ),
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
          titleText: "ShopSchedule",
          titleStyle: TextStyle(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          leadingColor: Colors.black,
          elevation: 0.0,
          onPressedLeading: () {
            Navigator.pop(context);
          }),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          buildText,
          SizedBox(
            height: 20,
          ),
          button(width * 0.8),
          SizedBox(
            height: height * 0.6,
          ),
          buttonSkip(width * 0.8)
        ],
      ),
    );
  }
}
