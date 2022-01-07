import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'src/calendar_header.dart';
import 'src/default_styles.dart';
import 'src/weekday_row.dart';

typedef DayBuilder = Widget Function(
  bool isSelectable,
  int index,
  bool isToday,
  bool isPrevMonthDay,
  TextStyle textStyle,
  bool isNextMonthDay,
  bool isThisMonthDay,
  DateTime day,
);

class CalendarCarousel extends StatefulWidget {
  final double width;
  final double height;
  final DateTime? selectedDateTime;
  final Function(DateTime)? onDayPressed;
  final Function(DateTime)? onNonSelectableDayPressed;
  final List<DateTime?>? markedDatesMap;
  final DateTime? startDate;

  final bool headerTitleTouchable;
  final Function? onHeaderTitlePressed;
  final Function? onLeftArrowPressed;
  final Function? onRightArrowPressed;

  final bool showOnlyCurrentMonthDate;
  final List<int> selectableDaysMap;
  final List<DateTime?> selectableDates;

  const CalendarCarousel({
    Key? key,
    this.height = double.infinity,
    this.width = double.infinity,
    this.selectedDateTime,
    this.onDayPressed,
    this.onNonSelectableDayPressed,
    this.markedDatesMap,
    this.headerTitleTouchable = false,
    this.onHeaderTitlePressed,
    this.onLeftArrowPressed,
    this.onRightArrowPressed,
    this.showOnlyCurrentMonthDate = false,
    this.selectableDaysMap = const [],
    this.startDate,
    this.selectableDates = const [],
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
  PageController? _controller;
  late List<DateTime> _dates;
  DateTime? _selectedDate;
  DateTime? _targetDate;
  int _startWeekday = 0;
  int _endWeekday = 0;
  DateFormat? _localeDate;
  int _pageNum = 0;
  late DateTime minDate;
  DateTime? maxDate;
  late DateTime startDate;

  /// When FIRSTDAYOFWEEK is 0 in dart-intl, it represents Monday. However it is the second day in the arrays of Weekdays.
  /// Therefore we need to add 1 modulo 7 to pick the right weekday from intl. (cf. [GlobalMaterialLocalizations])
  int? firstDayOfWeek;

  /// If the setState called from this class, don't reload the selectedDate, but it should reload selected date if called from external class

  @override
  void initState() {
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
    startDate =
        widget.startDate ?? DateTime.now().subtract(const Duration(days: 1));
    if (startDate.difference(DateTime.now()).inDays == 0) {
      startDate = startDate.subtract(const Duration(days: 1));
    }

    _selectedDate = widget.selectedDateTime ?? DateTime.now();

    _init();

    /// setup pageController
    _controller = PageController(
      initialPage: _pageNum,
    );

    _localeDate = DateFormat.yMMMM('en');
    firstDayOfWeek = (_localeDate!.dateSymbols.FIRSTDAYOFWEEK + 1) % 7;
    _setDate();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      //constraints: BoxConstraints(),
      width: widget.width,
      height: widget.height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CalendarHeader(
            headerMargin: EdgeInsets.symmetric(vertical: 5.0.h),
            headerTitle: _localeDate!.format(_dates[_pageNum]),
            onLeftButtonPressed: () {
              widget.onLeftArrowPressed?.call();

              if (_pageNum > 0) {
                _setDate(_pageNum - 1);
              }
            },
            onRightButtonPressed: () {
              widget.onRightArrowPressed?.call();

              if (_dates.length - 1 > _pageNum) {
                _setDate(_pageNum + 1);
              }
            },
            isTitleTouchable: widget.headerTitleTouchable,
            onHeaderTitlePressed:
                widget.onHeaderTitlePressed as void Function()? ??
                    () {
                      // TODO: add functions
                    },
          ),
          WeekdayRow(
            firstDayOfWeek,
            weekdayFormat: WeekdayFormat.narrow,
            weekdayMargin: EdgeInsets.only(bottom: 4.0.h),
            weekdayPadding: EdgeInsets.zero,
            weekdayBackgroundColor: Colors.transparent,
            weekdayTextStyle: defaultWeekdayTextStyle,
            localeDate: _localeDate,
          ),
          Expanded(
            child: PageView.builder(
              itemCount: _dates.length,
              physics: const ScrollPhysics(),
              onPageChanged: (index) {
                _setDate(index);
              },
              controller: _controller,
              itemBuilder: (context, index) {
                return builder(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget renderDay(
    DateTime now,
    TextStyle style, {
    required bool isSelectable,
    required bool isMarked,
  }) {
    Color? borderColor = Colors.transparent;
    Color buttonColor = Colors.transparent;
    if (isMarked) {
      borderColor = buttonColor = Colors.orange;
      if (!isSelectable) {
        borderColor = buttonColor = Colors.pink;
      }
    } else if (isSelectable) {
      borderColor = Colors.grey[300];
    }

    EdgeInsets margin = EdgeInsets.all(1.0.w);
    EdgeInsets padding = EdgeInsets.all(2.0.w);
    TextStyle _style = style;

    if (_selectedDate == now) {
      margin = EdgeInsets.zero;
      padding = EdgeInsets.all(1.5.w);
      _style = style.copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.bold);
    }

    return Container(
      margin: margin,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor!,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0.r),
          ),
        ),
        child: FlatButton(
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          color: buttonColor,
          onPressed: () {
            if (widget.onNonSelectableDayPressed != null && !isSelectable) {
              widget.onNonSelectableDayPressed!(now);
            }

            setState(() {
              if (_selectedDate == now) {
                _selectedDate = null;
              } else {
                _selectedDate = now;
              }
            });

            if (!isSelectable) return;

            // the calling method should handle the logic of the press
            // this is to avoid bloating the calendar picker
            widget.onDayPressed?.call(now);
          },
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(18.0.r),
          ),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Text(
                '${now.day}',
                semanticsLabel: now.day.toString(),
                style: buttonColor != Colors.pink
                    ? style
                    : _style.copyWith(color: Colors.white),
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  AnimatedBuilder builder(int slideIndex) {
    _startWeekday = _dates[slideIndex].weekday - firstDayOfWeek!;
    if (_startWeekday == 7) {
      _startWeekday = 0;
    }
    _endWeekday =
        DateTime(_dates[slideIndex].year, _dates[slideIndex].month + 1)
                .weekday -
            firstDayOfWeek!;
    final double screenWidth = MediaQuery.of(context).size.width;
    final int totalItemCount = DateTime(
          _dates[slideIndex].year,
          _dates[slideIndex].month + 1,
          0,
        ).day +
        _startWeekday +
        (7 - _endWeekday);
    final int year = _dates[slideIndex].year;
    final int month = _dates[slideIndex].month;

    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        double value = 1.0;
        if (_controller!.position.haveDimensions) {
          value = _controller!.page! - slideIndex;
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
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 7,
              padding: EdgeInsets.zero,
              children: List.generate(totalItemCount, (index) {
                final bool isToday =
                    DateTime.now().day == index + 1 - _startWeekday &&
                        DateTime.now().month == month &&
                        DateTime.now().year == year;

                final bool isPrevMonthDay = index < _startWeekday;
                final bool isNextMonthDay =
                    index >= (DateTime(year, month + 1, 0).day) + _startWeekday;
                final bool isThisMonthDay = !isPrevMonthDay && !isNextMonthDay;

                DateTime now = DateTime(year, month);
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
                final bool isMarked = widget.markedDatesMap!.contains(now);
                int day = now.weekday;
                if (day == 7) day = 0;
                bool isSelectable = true;
                // TODO: set limit for selectable
                // currently, users can select until the next year of the same date
                final bool isEarlier = now.millisecondsSinceEpoch <
                    startDate.millisecondsSinceEpoch;
                final bool isLater = maxDate != null &&
                    now.millisecondsSinceEpoch >
                        maxDate!.millisecondsSinceEpoch;
                final bool isInSelectableDays =
                    widget.selectableDaysMap.contains(day);
                final bool isInSelectableDates = widget.selectableDates.any(
                  (date) =>
                      date!.year == now.year &&
                      date.month == now.month &&
                      date.day == now.day,
                );

                if (isEarlier ||
                    isLater ||
                    (!isInSelectableDays && !isInSelectableDates)) {
                  isSelectable = false;
                }

                final TextStyle textStyle = getDefaultDayStyle(
                  index,
                  defaultTextStyle,
                  isSelectable: isSelectable,
                  isToday: isToday,
                  isPrevMonthDay: isPrevMonthDay,
                  isNextMonthDay: isNextMonthDay,
                  isThisMonthDay: isThisMonthDay,
                );
                return renderDay(
                  now,
                  textStyle,
                  isSelectable: isSelectable,
                  isMarked: isMarked,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _init() {
    _targetDate = _selectedDate;

    _pageNum = (_targetDate!.year - minDate.year) * 12 +
        _targetDate!.month -
        minDate.month;
  }

  DateTime _lastDayOfWeek(DateTime date) {
    final day = _createUTCMiddayDateTime(date);
    return day.add(Duration(days: 7 - day.weekday % 7));
  }

  DateTime _createUTCMiddayDateTime(DateTime date) {
    // Magic const: 12 is to maintain compatibility with date_utils
    return DateTime.utc(date.year, date.month, date.day, 12);
  }

  void _setDatesAndWeeks() {
    /// Setup default calendar format
    final List<DateTime> date = [];
    for (int _cnt = 0;
        0 >=
            DateTime(minDate.year, minDate.month + _cnt)
                .difference(DateTime(maxDate!.year, maxDate!.month))
                .inDays;
        _cnt++) {
      date.add(DateTime(minDate.year, minDate.month + _cnt));
      if (0 ==
          date.last
              .difference(DateTime(_targetDate!.year, _targetDate!.month))
              .inDays) {}
    }
    _dates = date;
  }

  void _setDate([int page = -1]) {
    if (page == -1) {
      setState(() {
        _setDatesAndWeeks();
      });
    } else {
      setState(() {
        _pageNum = page;
        _targetDate = _dates[page];
        _startWeekday = _dates[page].weekday - firstDayOfWeek!;
        _endWeekday = _lastDayOfWeek(_dates[page]).weekday - firstDayOfWeek!;
      });
      _controller!.animateToPage(
        page,
        duration: const Duration(milliseconds: 1),
        curve: const Threshold(0.0),
      );
    }
  }

  TextStyle getDefaultDayStyle(
    int index,
    TextStyle defaultTextStyle, {
    required bool isSelectable,
    required bool isToday,
    required bool isPrevMonthDay,
    required bool isNextMonthDay,
    required bool isThisMonthDay,
  }) {
    return !isSelectable
        ? defaultInactiveDaysTextStyle
        : (_localeDate!.dateSymbols.WEEKENDRANGE
                    .contains((index - 1 + firstDayOfWeek!) % 7)) &&
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
