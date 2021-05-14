import 'package:flutter/material.dart';

import 'src/default_styles.dart';

class DayOfMonthPicker extends StatelessWidget {
  final double height;
  final double width;
  final Function(int) onDayPressed;
  final int markedDay;
  final EdgeInsets padding;

  DayOfMonthPicker({
    this.height,
    this.width,
    @required this.onDayPressed,
    this.markedDay,
    this.padding = EdgeInsets.zero,
  });

  Widget _dayContainer(int day) {
    return Container(
      margin: EdgeInsets.all(2.0),
      child: GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            border: Border.all(
                color:
                    this.markedDay == day ? Colors.orange : Colors.grey[300]),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          child: FlatButton(
            color: this.markedDay == day ? Colors.orange : Colors.transparent,
            onPressed: () {
              // the calling method should handle the logic of the day press
              if (this.onDayPressed != null) {
                this.onDayPressed(day);
              }
            },
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.transparent, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(13.0),
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultTextStyle(
                    style: defaultDaysTextStyle,
                    child: Text(
                      day.toString(),
                      semanticsLabel: day.toString(),
                      style: defaultWeekdayTextStyle,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _renderDays() {
    var weekDays = _renderWeekDays();
    List<Widget> list = [...weekDays];

    /// because of number of days in a week is 7, so it would be easier to count it til 7.
    for (var index = 1; index <= 31; index++) {
      list.add(_dayContainer(index));
    }

    return list;
  }

  Widget _weekdayContainer(String weekDayName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4.0),
      padding: const EdgeInsets.all(0.0),
      child: Center(
        child: DefaultTextStyle(
          style: defaultWeekdayTextStyle,
          child: Text(
            weekDayName,
            semanticsLabel: weekDayName,
            style: defaultWeekdayTextStyle,
          ),
        ),
      ),
    );
  }

  List<Widget> _renderWeekDays() {
    List<Widget> list = [];

    var days = ["S", "M", "T", "W", "T", "F", "S"];
    for (var day in days) {
      list.add(_weekdayContainer(day));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      padding: this.padding,
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 7,
        shrinkWrap: true,
        children: _renderDays(),
      ),
    );
  }
}
