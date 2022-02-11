import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';

import '../../utils/constants/themes.dart';
import 'src/default_styles.dart';

class DayOfMonthPicker extends StatefulWidget {
  final double? height;
  final double? width;
  final Function(int) onDayPressed;
  final int? markedDay;
  final EdgeInsets padding;
  final String monthChoice;

  const DayOfMonthPicker({
    Key? key,
    this.height,
    this.width,
    required this.onDayPressed,
    this.markedDay,
    this.padding = EdgeInsets.zero,
    required this.monthChoice,
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
    final bool _isMarked = day == _markedDay;

    return Container(
      margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.all(2.0),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: _isMarked ? kOrangeColor : Colors.grey.shade300,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
      ),
      child: TextButton(
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
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: _isMarked ? kOrangeColor : Colors.transparent,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Text(
              '$day',
              semanticsLabel: day.toString(),
              style: defaultDaysTextStyle,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _renderDays() {
    final weekDays = _renderWeekDays();
    final List<Widget> list = [...weekDays];

    final _index = en_USSymbols.MONTHS.indexOf(widget.monthChoice) + 1;

    final _now = DateTime.now();
    final _lastDayOfMonth = DateTime(_now.year, _index + 1, 0).day;

    for (var index = 1; index <= _lastDayOfMonth; index++) {
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
