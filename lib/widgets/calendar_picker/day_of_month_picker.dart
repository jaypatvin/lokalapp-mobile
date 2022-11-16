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
  final List<int>? selectableMonthDays;

  const DayOfMonthPicker({
    super.key,
    this.height,
    this.width,
    required this.onDayPressed,
    this.markedDay,
    this.padding = EdgeInsets.zero,
    required this.monthChoice,
    this.selectableMonthDays,
  });

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
    final bool isMarked = day == _markedDay;
    // TODO: do we limit this?
    // final bool _isEnabled = widget.selectableMonthDays?.contains(day) ?? true;
    const bool isEnabled = true;

    return Container(
      margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.all(2.0),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isMarked ? kOrangeColor : Colors.grey.shade300,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
      ),
      child: TextButton(
        onPressed: isEnabled
            ? () {
                // the calling method should handle the logic of the day press
                setState(() {
                  if (_markedDay == day) {
                    _markedDay = 0;
                  } else {
                    _markedDay = day;
                  }
                });
                widget.onDayPressed(day);
              }
            // ignore: dead_code
            : null,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: isMarked ? kOrangeColor : Colors.transparent,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
        child: SizedBox.expand(
          child: Center(
            child: Text(
              '$day',
              semanticsLabel: day.toString(),
              style: isEnabled
                  ? defaultDaysTextStyle
                  // ignore: dead_code
                  : defaultInactiveDaysTextStyle,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _renderDays() {
    final List<Widget> list = [
      ...List.generate(7, (_) => const SizedBox(height: 5.0))
    ];

    final index = en_USSymbols.MONTHS.indexOf(widget.monthChoice) + 1;

    final now = DateTime.now();
    final lastDayOfMonth = DateTime(now.year, index + 1, 0).day;

    for (var index = 1; index <= lastDayOfMonth; index++) {
      list.add(_dayContainer(index));
    }

    return list;
  }

  // Widget _weekdayContainer(String weekDayName) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 4.0),
  //     padding: EdgeInsets.zero,
  //     child: Center(
  //       child: DefaultTextStyle(
  //         style: defaultWeekdayTextStyle,
  //         child: Text(
  //           weekDayName,
  //           semanticsLabel: weekDayName,
  //           style: defaultWeekdayTextStyle,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // List<Widget> _renderWeekDays() {
  //   final List<Widget> list = [];

  //   final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  //   for (final day in days) {
  //     list.add(_weekdayContainer(day));
  //   }

  //   return list;
  // }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      shrinkWrap: true,
      children: _renderDays(),
    );
  }
}
