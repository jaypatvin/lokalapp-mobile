import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'default_styles.dart';

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
    } else if (isSelectable) {
      borderColor = Colors.grey.shade300;
    }

    final EdgeInsets margin =
        isSelected ? const EdgeInsets.all(0.5) : const EdgeInsets.all(1.0);
    final EdgeInsets padding =
        isSelected ? const EdgeInsets.all(2) : const EdgeInsets.all(3.0);
    final TextStyle style = isSelected
        ? getDefaultDayStyle().copyWith(fontSize: 14.0)
        : getDefaultDayStyle();

    return Container(
      margin: margin,
      padding: padding,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor),
          borderRadius: const BorderRadius.all(
            Radius.circular(13.0),
          ),
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: buttonColor,
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
              '${dateTime.day}',
              semanticsLabel: dateTime.day.toString(),
              style: style,
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

class TappableCalendarWeekday extends StatelessWidget {
  final int weekday;
  final DateFormat dateFormat;
  final TextStyle? textStyle;
  final void Function()? onPressed;
  final bool isMarked;
  final bool isSelectable;
  const TappableCalendarWeekday({
    Key? key,
    required this.weekday,
    required this.dateFormat,
    this.isMarked = false,
    this.isSelectable = true,
    this.onPressed,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final werapWeekday = weekday % 7;
    final msg = dateFormat.dateSymbols.STANDALONENARROWWEEKDAYS[werapWeekday];

    Color borderColor = Colors.transparent;
    Color buttonColor = Colors.transparent;

    if (isMarked) {
      if (!isSelectable) {
        borderColor = buttonColor = Colors.pink;
      } else {
        borderColor = buttonColor = Colors.orange;
      }
    } else if (isSelectable) {
      borderColor = Colors.grey.shade300;
    }

    const EdgeInsets margin = EdgeInsets.all(1.0);
    const EdgeInsets padding = EdgeInsets.all(2.0);
    final TextStyle style =
        isSelectable ? defaultDaysTextStyle : defaultInactiveDaysTextStyle;
    return Expanded(
      child: Container(
        height: 50,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
          ),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: buttonColor,
            shape: const CircleBorder(),
          ),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                msg,
                semanticsLabel:
                    dateFormat.dateSymbols.STANDALONEWEEKDAYS[werapWeekday],
                style: style,
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
