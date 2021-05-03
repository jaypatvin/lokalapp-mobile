import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'classes/schedule_list.dart';
import 'src/calendar_header.dart';
import 'src/default_styles.dart';
import 'src/weekday_row.dart';

typedef Widget DayBuilder(
    bool isSelectable,
    int index,
    bool isToday,
    bool isPrevMonthDay,
    TextStyle textStyle,
    bool isNextMonthDay,
    bool isThisMonthDay,
    DateTime day);

class CalendarCarousel extends StatefulWidget {
  final double height;
  final double width;
  final DateTime selectedDateTime;
  final Function(DateTime) onDayPressed;
  final ScheduleList markedDatesMap;

  final bool headerTitleTouchable;
  final Function onHeaderTitlePressed;
  final Function onLeftArrowPressed;
  final Function onRightArrowPressed;

  final bool showOnlyCurrentMonthDate;
  final List<int> selectableDaysMap;

  CalendarCarousel({
    Key key,
    this.height = double.infinity,
    this.width = double.infinity,
    this.selectedDateTime,
    this.onDayPressed,
    this.markedDatesMap,
    this.headerTitleTouchable = false,
    this.onHeaderTitlePressed,
    this.onLeftArrowPressed,
    this.onRightArrowPressed,
    this.showOnlyCurrentMonthDate = false,
    this.selectableDaysMap,
  }) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

enum WeekdayFormat {
  weekdays,
  standalone,
  short,
  standaloneShort,
  narrow,
  standaloneNarrow,
}

class _CalendarState extends State<CalendarCarousel> {
  PageController _controller;
  List<DateTime> _dates;
  DateTime _selectedDate;
  DateTime _targetDate;
  int _startWeekday = 0;
  int _endWeekday = 0;
  DateFormat _localeDate;
  int _pageNum = 0;
  DateTime minDate;
  DateTime maxDate;

  /// When FIRSTDAYOFWEEK is 0 in dart-intl, it represents Monday. However it is the second day in the arrays of Weekdays.
  /// Therefore we need to add 1 modulo 7 to pick the right weekday from intl. (cf. [GlobalMaterialLocalizations])
  int firstDayOfWeek;

  /// If the setState called from this class, don't reload the selectedDate, but it should reload selected date if called from external class

  @override
  initState() {
    super.initState();
    initializeDateFormatting();

    minDate = DateTime(
      DateTime.now().year - 1,
      DateTime.now().month,
      DateTime.now().day,
    );
    maxDate = DateTime(
      DateTime.now().year + 1,
      DateTime.now().month,
      DateTime.now().day,
    );

    _selectedDate = widget.selectedDateTime ?? DateTime.now();

    _init();

    /// setup pageController
    _controller = PageController(
      initialPage: this._pageNum,
      keepPage: true,
      viewportFraction: 1.0,
    );

    _localeDate = DateFormat.yMMMM("en");
    firstDayOfWeek = (_localeDate.dateSymbols.FIRSTDAYOFWEEK + 1) % 7;
    _setDate();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: <Widget>[
          CalendarHeader(
              headerMargin: const EdgeInsets.symmetric(vertical: 16.0),
              headerTitle: '${_localeDate.format(this._dates[this._pageNum])}',
              showHeader: true,
              onLeftButtonPressed: () {
                if (widget.onLeftArrowPressed != null) {
                  widget.onLeftArrowPressed();
                }

                if (this._pageNum > 0) {
                  _setDate(this._pageNum - 1);
                }
              },
              onRightButtonPressed: () {
                if (widget.onRightArrowPressed != null) {
                  widget.onRightArrowPressed();
                }

                if (this._dates.length - 1 > this._pageNum) {
                  _setDate(this._pageNum + 1);
                }
              },
              isTitleTouchable: widget.headerTitleTouchable,
              onHeaderTitlePressed: widget.onHeaderTitlePressed ??
                  () {
                    // TODO: add functions
                  }),
          WeekdayRow(
            firstDayOfWeek,
            weekdayFormat: WeekdayFormat.narrow,
            weekdayMargin: const EdgeInsets.only(bottom: 4.0),
            weekdayPadding: const EdgeInsets.all(0.0),
            weekdayBackgroundColor: Colors.transparent,
            weekdayTextStyle: defaultWeekdayTextStyle,
            localeDate: _localeDate,
          ),
          Expanded(
            child: PageView.builder(
              itemCount: this._dates.length,
              physics: ScrollPhysics(),
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                this._setDate(index);
              },
              controller: _controller,
              itemBuilder: (context, index) {
                return builder(index);
              },
              pageSnapping: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget renderDay(
    bool isSelectable,
    bool isMarked,
    DateTime now,
    TextStyle style,
  ) {
    return Container(
      margin: EdgeInsets.all(1.0),
      child: Container(
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            border: Border.all(
              color: isMarked
                  ? Colors.orange
                  : isSelectable
                      ? Colors.grey[300]
                      : Colors.transparent,
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            )),
        child: FlatButton(
          color: isMarked ? Colors.orange : Colors.transparent,
          onPressed: () {
            if (!isSelectable) return;
            setState(() {
              _selectedDate = now;
            });

            // the calling method should handle the logic of the press
            // this is to avoid bloating the calendar picker
            if (widget.onDayPressed != null) widget.onDayPressed(now);
          },
          shape: RoundedRectangleBorder(
            side:
                BorderSide(color: Colors.transparent, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(13.0),
          ),
          child: Container(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Text(
                  '${now.day}',
                  semanticsLabel: now.day.toString(),
                  style: style,
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AnimatedBuilder builder(int slideIndex) {
    _startWeekday = _dates[slideIndex].weekday - firstDayOfWeek;
    if (_startWeekday == 7) {
      _startWeekday = 0;
    }
    _endWeekday =
        DateTime(_dates[slideIndex].year, _dates[slideIndex].month + 1, 1)
                .weekday -
            firstDayOfWeek;
    double screenWidth = MediaQuery.of(context).size.width;
    int totalItemCount = DateTime(
          _dates[slideIndex].year,
          _dates[slideIndex].month + 1,
          0,
        ).day +
        _startWeekday +
        (7 - _endWeekday);
    int year = _dates[slideIndex].year;
    int month = _dates[slideIndex].month;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double value = 1.0;
        if (_controller.position.haveDimensions) {
          value = _controller.page - slideIndex;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * widget.height,
            width: Curves.easeOut.transform(value) * screenWidth,
            child: child,
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 7,
                childAspectRatio: 1.0,
                padding: EdgeInsets.zero,
                children: List.generate(totalItemCount, (index) {
                  bool isToday =
                      DateTime.now().day == index + 1 - _startWeekday &&
                          DateTime.now().month == month &&
                          DateTime.now().year == year;

                  bool isPrevMonthDay = index < _startWeekday;
                  bool isNextMonthDay = index >=
                      (DateTime(year, month + 1, 0).day) + _startWeekday;
                  bool isThisMonthDay = !isPrevMonthDay && !isNextMonthDay;

                  DateTime now = DateTime(year, month, 1);
                  TextStyle defaultTextStyle;
                  if (isPrevMonthDay && !widget.showOnlyCurrentMonthDate) {
                    now = now.subtract(Duration(days: _startWeekday - index));
                    defaultTextStyle = defaultPrevDaysTextStyle;
                  } else if (isThisMonthDay) {
                    now = DateTime(year, month, index + 1 - _startWeekday);
                    defaultTextStyle =
                        isToday ? defaultTodayTextStyle : defaultDaysTextStyle;
                  } else if (!widget.showOnlyCurrentMonthDate) {
                    now = DateTime(year, month, index + 1 - _startWeekday);
                    defaultTextStyle = defaultNextDaysTextStyle;
                  } else {
                    return Container();
                  }
                  bool isMarked = widget.markedDatesMap.contains(now);
                  int day = now.weekday;
                  if (day == 7) day = 0;
                  bool isSelectable = true;
                  // TODO: set limit for selectable
                  // currently, users can select until the next year of the same date
                  if (now.millisecondsSinceEpoch <
                      DateTime.now()
                          .subtract(Duration(days: 1))
                          .millisecondsSinceEpoch)
                    isSelectable = false;
                  else if (maxDate != null &&
                      now.millisecondsSinceEpoch >
                          maxDate.millisecondsSinceEpoch)
                    isSelectable = false;
                  else if (!widget.selectableDaysMap.contains(day))
                    isSelectable = false;

                  TextStyle textStyle = getDefaultDayStyle(
                      isSelectable,
                      index,
                      isToday,
                      isPrevMonthDay,
                      defaultTextStyle,
                      isNextMonthDay,
                      isThisMonthDay);
                  return renderDay(
                    isSelectable,
                    isMarked,
                    now,
                    textStyle,
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _init() {
    _targetDate = _selectedDate;

    _pageNum = (_targetDate.year - minDate.year) * 12 +
        _targetDate.month -
        minDate.month;
  }

  DateTime _lastDayOfWeek(DateTime date) {
    var day = _createUTCMiddayDateTime(date);
    return day.add(new Duration(days: 7 - day.weekday % 7));
  }

  DateTime _createUTCMiddayDateTime(DateTime date) {
    // Magic const: 12 is to maintain compatibility with date_utils
    return new DateTime.utc(date.year, date.month, date.day, 12, 0, 0);
  }

  void _setDatesAndWeeks() {
    /// Setup default calendar format
    List<DateTime> date = [];
    for (int _cnt = 0;
        0 >=
            DateTime(minDate.year, minDate.month + _cnt)
                .difference(DateTime(maxDate.year, maxDate.month))
                .inDays;
        _cnt++) {
      date.add(DateTime(minDate.year, minDate.month + _cnt, 1));
      if (0 ==
          date.last
              .difference(
                  DateTime(this._targetDate.year, this._targetDate.month))
              .inDays) {}
    }
    this._dates = date;
  }

  void _setDate([int page = -1]) {
    if (page == -1) {
      setState(() {
        _setDatesAndWeeks();
      });
    } else {
      setState(() {
        this._pageNum = page;
        this._targetDate = this._dates[page];
        _startWeekday = _dates[page].weekday - firstDayOfWeek;
        _endWeekday = _lastDayOfWeek(_dates[page]).weekday - firstDayOfWeek;
      });
      _controller.animateToPage(page,
          duration: Duration(milliseconds: 1), curve: Threshold(0.0));
    }
  }

  TextStyle getDefaultDayStyle(
    bool isSelectable,
    int index,
    bool isToday,
    bool isPrevMonthDay,
    TextStyle defaultTextStyle,
    bool isNextMonthDay,
    bool isThisMonthDay,
  ) {
    return !isSelectable
        ? defaultInactiveDaysTextStyle
        : (_localeDate.dateSymbols.WEEKENDRANGE
                    .contains((index - 1 + firstDayOfWeek) % 7)) &&
                !isToday
            ? (isPrevMonthDay
                ? defaultPrevDaysTextStyle
                : isNextMonthDay
                    ? defaultNextDaysTextStyle
                    : isSelectable
                        ? defaultWeekendTextStyle
                        : defaultInactiveWeekendTextStyle)
            : isToday
                ? defaultTodayTextStyle
                : defaultTextStyle;
  }
}
