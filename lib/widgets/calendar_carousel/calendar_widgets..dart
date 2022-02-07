import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/calendar_picker/src/default_styles.dart';

class LokalCalendarDay extends StatelessWidget {
  final DateTime dateTime;
  final bool isLastMonthDay;
  final bool isNextMonthDay;
  final bool isSelectable;
  final bool isMarked;
  final bool isToday;
  final bool isSelected;
  final void Function()? onPressed;

  const LokalCalendarDay({
    Key? key,
    required this.dateTime,
    required this.isLastMonthDay,
    required this.isNextMonthDay,
    this.isSelectable = true,
    this.isMarked = false,
    this.onPressed,
    this.isToday = false,
    this.isSelected = false,
  }) : super(key: key);

  TextStyle getDefaultDayStyle() {
    if (!isSelectable || isNextMonthDay) return defaultInactiveDaysTextStyle;
    if (isToday) return defaultTodayTextStyle;
    return defaultDaysTextStyle;
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.transparent;
    Color buttonColor = Colors.transparent;

    if (isMarked) {
      if (!isSelectable) {
        borderColor = buttonColor = Colors.pink;
      } else {
        borderColor = buttonColor = Colors.orange;
      }
    } else if (isSelectable || isNextMonthDay) {
      borderColor = Colors.grey.shade300;
    }

    const EdgeInsets margin = EdgeInsets.all(1.0);
    const EdgeInsets padding = EdgeInsets.all(2.0);
    final TextStyle _style = getDefaultDayStyle();

    //TODO: update styles
    // if (isSelected) {
    //   margin = EdgeInsets.zero;
    //   padding = EdgeInsets.all(1.5.w);
    //   _style = style.copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.bold);
    // }
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Text(
              '${dateTime.day}',
              semanticsLabel: dateTime.day.toString(),
              style: _style,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class LokalCalendarWeekday extends StatelessWidget {
  final int weekday;
  final DateFormat dateFormat;
  final TextStyle? textStyle;
  const LokalCalendarWeekday({
    Key? key,
    required this.weekday,
    required this.dateFormat,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final werapWeekday = weekday % 7;
    final msg = dateFormat.dateSymbols.STANDALONENARROWWEEKDAYS[werapWeekday];
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Center(
          child: Text(msg, textAlign: TextAlign.center, style: textStyle),
        ),
      ),
    );
  }
}
