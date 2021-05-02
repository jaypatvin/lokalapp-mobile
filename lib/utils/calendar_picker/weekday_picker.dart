import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'calendar_picker.dart';
import 'src/default_styles.dart';

class WeekdayPicker extends StatefulWidget {
  final WeekdayFormat weekdayFormat;
  final String locale;
  final int firstDayOfWeek;
  final EdgeInsets weekdayMargin;
  final EdgeInsets weekdayPadding;
  final Color weekdayBackgroundColor;
  final TextStyle weekdayTextStyle;
  final bool daysHaveCircularBorder;
  final Function(int) onDayPressed;
  final List<int> markedDaysMap;

  WeekdayPicker({
    this.weekdayFormat = WeekdayFormat.narrow,
    this.locale = "en",
    this.firstDayOfWeek,
    this.weekdayMargin = const EdgeInsets.all(0.0),
    this.weekdayPadding = const EdgeInsets.all(0.0),
    this.weekdayBackgroundColor = Colors.transparent,
    this.weekdayTextStyle,
    this.daysHaveCircularBorder = true,
    this.onDayPressed,
    this.markedDaysMap,
  });
  @override
  _WeekdayPickerState createState() => _WeekdayPickerState();
}

class _WeekdayPickerState extends State<WeekdayPicker> {
  DateFormat _localeDate;
  int firstDayOfWeek;

  @override
  initState() {
    initializeDateFormatting();
    _localeDate = DateFormat.yMMMM(widget.locale);
    if (widget.firstDayOfWeek == null)
      firstDayOfWeek = (_localeDate.dateSymbols.FIRSTDAYOFWEEK + 1) % 7;
    else
      firstDayOfWeek = widget.firstDayOfWeek;

    super.initState();
  }

  Widget _weekdayContainer(bool isMarked, int weekday, String weekDayName) {
    return Container(
      margin: EdgeInsets.all(2.0),
      child: GestureDetector(
        onLongPress: () => print(weekDayName),
        child: Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.orange),
              shape: widget.daysHaveCircularBorder
                  ? BoxShape.circle
                  : BoxShape.rectangle,
              borderRadius: widget.daysHaveCircularBorder
                  ? null
                  : BorderRadius.all(
                      Radius.circular(15.0),
                    )),
          child: FlatButton(
            color: isMarked ? Colors.orange : Colors.transparent,
            onPressed: () {
              // the calling method should handle the logic of the day press
              if (widget.onDayPressed != null) {
                widget.onDayPressed(weekday);
              }
            },
            shape: widget.daysHaveCircularBorder
                ? CircleBorder(
                    side: BorderSide(
                        color: Colors.transparent, style: BorderStyle.solid),
                  )
                : RoundedRectangleBorder(
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
                      weekDayName,
                      semanticsLabel: weekDayName,
                      style: widget.weekdayTextStyle ?? defaultWeekdayTextStyle,
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

  List<Widget> _renderWeekDays() {
    List<Widget> list = [];

    /// because of number of days in a week is 7, so it would be easier to count it til 7.
    for (var i = firstDayOfWeek, count = 0;
        count < 7;
        i = (i + 1) % 7, count++) {
      String weekDay;

      switch (widget.weekdayFormat) {
        case WeekdayFormat.weekdays:
          weekDay = _localeDate.dateSymbols.WEEKDAYS[i];
          break;
        case WeekdayFormat.standalone:
          weekDay = _localeDate.dateSymbols.STANDALONEWEEKDAYS[i];
          break;
        case WeekdayFormat.short:
          weekDay = _localeDate.dateSymbols.SHORTWEEKDAYS[i];
          break;
        case WeekdayFormat.standaloneShort:
          weekDay = _localeDate.dateSymbols.STANDALONESHORTWEEKDAYS[i];
          break;
        case WeekdayFormat.narrow:
          weekDay = _localeDate.dateSymbols.NARROWWEEKDAYS[i];
          break;
        case WeekdayFormat.standaloneNarrow:
          weekDay = _localeDate.dateSymbols.STANDALONENARROWWEEKDAYS[i];
          break;
        default:
          weekDay = _localeDate.dateSymbols.STANDALONEWEEKDAYS[i];
          break;
      }
      bool isMarked = widget.markedDaysMap.contains(count);
      list.add(_weekdayContainer(isMarked, count, weekDay));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      shrinkWrap: true,
      children: _renderWeekDays(),
    );
  }
}
