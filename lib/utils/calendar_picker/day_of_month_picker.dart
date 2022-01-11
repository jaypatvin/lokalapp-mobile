import 'package:flutter/material.dart';

import 'src/default_styles.dart';

class DayOfMonthPicker extends StatefulWidget {
  final double? height;
  final double? width;
  final Function(int) onDayPressed;
  final int? markedDay;
  final EdgeInsets padding;

  const DayOfMonthPicker({
    Key? key,
    this.height,
    this.width,
    required this.onDayPressed,
    this.markedDay,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  _DayOfMonthPickerState createState() => _DayOfMonthPickerState();
}

class _DayOfMonthPickerState extends State<DayOfMonthPicker> {
  int? _markedDay;

  @override
  void initState() {
    super.initState();

    _markedDay = widget.markedDay;
  }

  Widget _dayContainer(int day) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      child: GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: _markedDay == day ? Colors.orange : Colors.grey[300]!,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor:
                  _markedDay == day ? Colors.orange : Colors.transparent,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(13.0),
              ),
            ),
            onPressed: () {
              // the calling method should handle the logic of the day press
              setState(() {
                if (_markedDay == day) {
                  _markedDay = 0;
                } else {
                  _markedDay = day;
                }
              });
              widget.onDayPressed(day);
            },
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Row(
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
    final weekDays = _renderWeekDays();
    final List<Widget> list = [...weekDays];

    /// because of number of days in a week is 7, so it would be easier to count it til 7.
    for (var index = 1; index <= 31; index++) {
      list.add(_dayContainer(index));
    }

    return list;
  }

  Widget _weekdayContainer(String weekDayName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4.0),
      padding: EdgeInsets.zero,
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
    final List<Widget> list = [];

    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    for (final day in days) {
      list.add(_weekdayContainer(day));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      padding: widget.padding,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 7,
        shrinkWrap: true,
        children: _renderDays(),
      ),
    );
  }
}
