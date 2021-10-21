import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';

import '../models/operating_hours.dart';
import '../utils/calendar_picker/calendar_picker.dart';
import '../utils/calendar_picker/day_of_month_picker.dart';
import '../utils/calendar_picker/weekday_picker.dart';
import '../utils/functions.utils.dart';
import '../utils/repeated_days_generator/repeated_days_generator.dart';
import '../utils/repeated_days_generator/schedule_generator.dart';
import '../utils/constants/themes.dart';
import 'app_button.dart';

/// The user can choose to repeat the schedule/subscription by day, week, or months
enum RepeatChoices {
  /// repeat by days (i.e., every 2 days, every 3 days...)
  day,

  /// repeat by weeks (i.e., every 4 weeks, every 5 weeks...)
  week,

  /// repeat by months (i.e., every 6 months, every 7 months...)
  month
}

/// An extension on RepeatChoices, as of now for getting String values
extension RepeatChoicesExtension on RepeatChoices {
  /// get string values for printing and checking purposes
  String get value {
    switch (this) {
      case RepeatChoices.day:
        return 'Day';
      case RepeatChoices.week:
        return 'Week';
      case RepeatChoices.month:
        return 'Month';
    }
  }
}

// Should we split this into different files?
// However, the SchedulePicker is the only one who uses this

/// A reusable widget used for picking schedules for shops and subscriptions.
class SchedulePicker extends StatefulWidget {
  /// The text header to be displayed above the schedule picker
  final String header;

  /// The subheader text
  final String description;

  /// Used for multiple start dates (weekday schedule picker)
  final void Function(List<DateTime>, String repeatType) onStartDatesChanged;

  /// Function to be called when repeat type (day, week, month) is changed.
  ///
  /// Since the monthPicker has two states, we need to determine if the user
  /// used the datePicker or the dropDown buttons for picking the startDate.
  final void Function(String?) onRepeatTypeChanged;

  /// Function to be called when repeat unit (every n - type) is changed
  final void Function(int?) onRepeatUnitChanged;

  final void Function(List<int>) onSelectableDaysChanged;

  /// OperatingHours is needed for subscription schedule.
  ///
  /// If this is null (which should only be used in shop creation),
  /// schedule generation is non-limited.
  final OperatingHours? operatingHours;

  /// Overrides the `RepeatChoices` enumerated on the repeatability picker.
  /// If null, defaults to `day`, `week`, and `month` respectively.
  ///
  /// Repeated choices are automatically filtered using the spread operator
  /// `[...{...elements}]`.
  final List<RepeatChoices> repeatabilityChoices;

  /// Whether the user can edit the schedule or not. Defaults to true.
  final bool editable;

  /// Whether to follow operating hours selectableDates or not. Defaults to false.
  final bool limitSelectableDates;

  final FocusNode repeatUnitFocusNode;

  /// A reusable widget used for picking schedules for shops and subscriptions.
  const SchedulePicker({
    Key? key,
    required this.header,
    required this.description,
    required this.onStartDatesChanged,
    required this.onRepeatTypeChanged,
    required this.onRepeatUnitChanged,
    required this.onSelectableDaysChanged,
    this.operatingHours,
    this.repeatabilityChoices = const [
      RepeatChoices.day,
      RepeatChoices.week,
      RepeatChoices.month,
    ],
    this.editable = true,
    this.limitSelectableDates = false,
    required this.repeatUnitFocusNode,
  }) : super(key: key);

  @override
  _SchedulePickerState createState() => _SchedulePickerState();
}

class _SchedulePickerState extends State<SchedulePicker> {
  final _scheduleGenerator = ScheduleGenerator();
  final _repeatUnitController = TextEditingController();

  List<int> _selectableDays = [];
  List<DateTime?> _selectableDates = [];

  DateTime? _startDate;
  List<DateTime> _startDates = [];
  List<DateTime> _markedStartDates = [];

  int _markedStartDayOfMonth = 0;
  int _startDayOfMonth = 0;

  String? _ordinalChoice;
  String? _monthChoice;
  String? _monthDayChoice;

  RepeatChoices _repeatChoice = RepeatChoices.day;
  String _repeatUnit = "";

  bool _usedDatePicker = true;

  List<RepeatChoices>? _repeatabilityChoices;

  @override
  void initState() {
    super.initState();

    // efficient way of removing repeated choices
    this._repeatabilityChoices = [
      ...{...widget.repeatabilityChoices}
    ];

    if (widget.operatingHours != null &&
        isValidOperatingHours(widget.operatingHours)) {
      _onOperatingHoursInit();
    } else {
      _onNonOperatingHoursInit();
      if (!this._repeatabilityChoices!.contains(RepeatChoices.day)) {
        this._repeatChoice =
            this._repeatabilityChoices!.contains(RepeatChoices.week)
                ? RepeatChoices.week
                : RepeatChoices.month;
      }
    }
  }

  // Called when operating hours is non-null and is valid.
  // Used on subscription schedule and edit-shop schedule.
  void _onOperatingHoursInit() {
    final _operatingHours = widget.operatingHours!;
    final _schedule = _scheduleGenerator.generateSchedule(_operatingHours);

    if (widget.limitSelectableDates) {
      final now = DateTime.now();
      for (var indexDay = DateTime(now.year, now.month, now.day);
          true;
          indexDay = indexDay.add(
        const Duration(days: 1),
      ),) {
        this._startDate = indexDay;
        if (_schedule.repeatType == RepeatChoices.week) {
          if (_schedule.selectableDays.contains(_startDate!.day)) {
            break;
          }
        } else {
          if (_schedule.selectableDates.any((date) =>
              date.year == _startDate!.year &&
              date.month == _startDate!.month &&
              date.day == _startDate!.day)) {
            break;
          }
        }
      }

      this._startDates = [_startDate!];
    }

    this._repeatUnit = _schedule.repeatUnit.toString();
    this._repeatUnitController.text = this._repeatUnit;
    this._repeatChoice = _schedule.repeatType;
    this._markedStartDates = _schedule.startDates;
    this._selectableDays = _schedule.selectableDays;
    this._startDate ??= _schedule.startDate;
    this._startDayOfMonth = _schedule.startDayOfMonth;
    this._selectableDates = _schedule.selectableDates;

    // Month:
    var _ordinal = 0;
    _markedStartDayOfMonth = _startDayOfMonth;
    for (DateTime indexDay = DateTime(_startDate!.year, _startDate!.month, 1);
        indexDay.day <= _startDate!.day;
        indexDay = indexDay.add(Duration(days: 1))) {
      if (indexDay.weekday == _startDate!.weekday) {
        _ordinal++;
      }
    }
    _ordinalChoice = Schedule.ordinalNumbers[_ordinal - 1];
    _monthChoice = en_USSymbols.MONTHS[_startDate!.month - 1];
    var _weekday = _startDate!.weekday;
    if (_weekday == 7) _weekday = 7;
    _monthDayChoice = en_USSymbols.WEEKDAYS[_weekday];

    _usedDatePicker = _startDayOfMonth != 0;

    // repeatType has changed!
    _onRepeatChoiceChanged(_repeatChoice);
    // repeatUnit has changed!
    widget.onRepeatUnitChanged(_schedule.repeatUnit);
    // startDate has changed!
    _onStartDateChanged();
    //widget.onStartDateChanged(_startDate);
    widget.onSelectableDaysChanged(_selectableDays);
  }

  // Only used for add-shop schedule. It should already be implied that the
  // opening and closing time picker are displayed.
  void _onNonOperatingHoursInit() {
    _repeatChoice = RepeatChoices.day;
    _repeatUnitController.text = _repeatUnit = "1";
    _ordinalChoice = Schedule.ordinalNumbers[0];
    var day = DateTime.now().weekday;
    if (day == 7) day = 0;
    _monthDayChoice = en_USSymbols.WEEKDAYS[day];
    _monthChoice = en_USSymbols.MONTHS[DateTime.now().month - 1];

    _onRepeatChoiceChanged(_repeatChoice);
    _onRepeatUnitChanged(_repeatUnit);
  }

  void _onWeekDayPickerDayPressedHandler(int? index) {
    setState(() {
      if (this._selectableDays.contains(index)) {
        this._selectableDays.remove(index);
        widget.onSelectableDaysChanged(this._selectableDays);
        if (this._markedStartDates.isEmpty) return;
        final markedStart = this._markedStartDates.first;
        var startDay = markedStart.weekday;
        if (startDay == 7) startDay = 0;
        if (startDay == index) this._markedStartDates.clear();

        var day = this._startDate!.weekday;
        if (day == 7) day = 0;
        if (day == index) {
          final now = DateTime.now();
          for (DateTime indexDay = DateTime(now.year, now.month, now.day);
              indexDay.month <= now.month + 1;
              indexDay = indexDay.add(Duration(days: 1)),) {
            var day = indexDay.weekday;
            if (day == 7) day = 0;
            if (this._selectableDays.contains(day)) {
              this._startDate = indexDay;
              break;
            } else {
              this._startDate = null;
            }
          }
        }
      } else {
        this._selectableDays.add(index!);
        widget.onSelectableDaysChanged(this._selectableDays);
        if (this._markedStartDates.isNotEmpty) return;
        final now = DateTime.now();
        for (DateTime indexDay = DateTime(now.year, now.month, now.day);
            indexDay.month <= DateTime.now().month + 1;
            indexDay = indexDay.add(Duration(days: 1))) {
          int day = indexDay.weekday;
          if (day == 7) day = 0;
          if (day == index) {
            this._startDate = indexDay;
            this._markedStartDates.add(indexDay);
            // widget.onStartDateChanged(_startDate);
            break;
          }
        }
      }
      _onStartDateChanged();
    });
  }

  // MONTH STATE:
  /* ------------------------------------------------------------------------ */
  Future<int?> showDayOfMonthPicker() async {
    return await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _DayOfMonthPickerBody(
          markedStartDayOfMonth: _markedStartDayOfMonth,
          onDayPressed: (day) {
            setState(() {
              if (_markedStartDayOfMonth == day) {
                _markedStartDayOfMonth = 0;
              } else {
                _markedStartDayOfMonth = day;
              }
            });
          },
          onCancel: () {
            _markedStartDayOfMonth = _startDayOfMonth;
            Navigator.pop(context, _startDayOfMonth);
          },
          onConfirm: () {
            this.setState(() {
              _startDayOfMonth = _markedStartDayOfMonth;
            });
            _usedDatePicker = true;
            setMonthStartDate(day: _startDayOfMonth);
            Navigator.pop(context, this._startDayOfMonth);
          },
        );
      },
    );
  }

  void setMonthStartDate({int? day, int? month}) {
    _startDate ??= DateTime.now();

    setState(() {
      _startDate = DateTime(
        _startDate!.year,
        month ?? _startDate!.month,
        day ?? _startDate!.day,
      );
    });
    // startDate has changed!
    _onStartDateChanged();
  }

  void setMonthDayOfWeek() {
    final weekdayIndex = en_USSymbols.WEEKDAYS.indexOf(_monthDayChoice!);
    final ordinalNumber = Schedule.ordinalNumbers.indexOf(_ordinalChoice) + 1;
    final month = en_USSymbols.MONTHS.indexOf(_monthChoice!);
    final startDates =
        RepeatedDaysGenerator.instance!.getRepeatedMonthDaysByNthDay(
      everyNMonths: int.tryParse(_repeatUnit) ?? 1,
      ordinal: ordinalNumber,
      weekday: weekdayIndex,
      month: month + 1,
    )..sort();
    setState(() {
      _startDate = startDates.first;
      _startDayOfMonth = 0;
    });
    // startDate has changed!
    // widget.onStartDateChanged(_startDate);
    _onStartDateChanged();
  }
  /* ------------------------------------------------------------------------ */

  Future<DateTime?> showCalendarPicker() async {
    return await showDialog<DateTime>(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (BuildContext context) {
        return _CalendarPickerBody(
          height: MediaQuery.of(context).size.height,
          repeatChoice: _repeatChoice,
          startDates: _markedStartDates,
          selectableDays: _selectableDays,
          selectableDates:
              widget.limitSelectableDates ? this._selectableDates : [],
          onDayPressed: (day) {
            setState(() {
              if (_markedStartDates.contains(day))
                _markedStartDates.clear();
              else
                _markedStartDates
                  ..clear()
                  ..add(day);
            });
          },
          onCancel: () {
            if (_startDate != null)
              _markedStartDates
                ..clear()
                ..add(_startDate!);
            Navigator.pop(context, _startDate);
          },
          onConfirm: () {
            setState(() {
              if (_markedStartDates.isNotEmpty)
                _startDate = _markedStartDates.first;
              else
                _startDate = null;
            });
            // startDate has changed!
            //widget.onStartDateChanged(_startDate);
            _onStartDateChanged();
            Navigator.pop(context, _startDate);
          },
        );
      },
    );
  }

  Widget _weekdayPicker() {
    return Column(
      children: [
        WeekdayPicker(
          onDayPressed:
              widget.editable ? _onWeekDayPickerDayPressedHandler : null,
          markedDaysMap: _selectableDays,
        ),
        SizedBox(height: 10.0.h),
        if (_selectableDays.isEmpty)
          Text(
            "Select a day or days to repeat every week",
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.normal,
                  fontSize: 16.0.sp,
                ),
          ),
        SizedBox(height: 10.0.h),
      ],
    );
  }

  String _getRepeatType() {
    if (!_usedDatePicker) {
      final weekdayIndex = en_USSymbols.WEEKDAYS.indexOf(_monthDayChoice!);
      final weekday = en_USSymbols.SHORTWEEKDAYS[weekdayIndex].toLowerCase();
      final ordinalNumber = Schedule.ordinalNumbers.indexOf(_ordinalChoice) + 1;
      final _repeatType = "$ordinalNumber-$weekday";
      return _repeatType;
    } else {
      final _repeatType = _repeatChoice.value.toLowerCase();
      return _repeatType;
    }
  }

  void _onStartDateChanged() {
    if (_repeatChoice == RepeatChoices.week) {
      int everyNWeeks = int.tryParse(_repeatUnit) ?? 0;
      if (everyNWeeks <= 0) return;
      _startDates = _scheduleGenerator.getWeekDayStartDates(
        _startDate,
        _selectableDays,
        everyNWeeks: int.parse(_repeatUnit),
      );
    } else {
      _startDates = _startDate != null ? [_startDate!] : [];
      _markedStartDates = _startDates;
    }

    print(_startDates);
    final _repeatType = _getRepeatType();
    widget.onStartDatesChanged(_startDates, _repeatType);
  }

  void _onRepeatUnitChanged(String _repeatUnit) {
    setState(() {
      this._repeatUnit = _repeatUnit;
    });
    widget.onRepeatUnitChanged(int.tryParse(_repeatUnit));
    if (_repeatChoice == RepeatChoices.week) {
      _onStartDateChanged();
    }
  }

  void _onRepeatChoiceChanged(RepeatChoices? choice) {
    if (choice == _repeatChoice) return;
    if (this.mounted)
      setState(() {
        this._repeatChoice = choice!;
      });

    _usedDatePicker = choice == RepeatChoices.month ? false : true;
    final repeatType = _getRepeatType();
    widget.onRepeatTypeChanged(repeatType);

    if (choice == RepeatChoices.week) {
      _onStartDateChanged();
    }
  }

  void Function()? _selectStartDateHandler() {
    if (_repeatChoice != RepeatChoices.week || _selectableDays.isNotEmpty) {
      return showCalendarPicker;
    } else {
      return null;
    }
  }

  void _onOrdinalChoiceChanged(String? value) {
    setState(() {
      _ordinalChoice = value;
      _usedDatePicker = false;
    });
    setMonthDayOfWeek();
  }

  void _onMonthDayChoiceChanged(String? value) {
    setState(() {
      _monthDayChoice = value;
      _usedDatePicker = false;
    });
    setMonthDayOfWeek();
  }

  void _onMonthChoiceChanged(String? value) {
    setState(() {
      _monthChoice = value;
    });

    final month = en_USSymbols.MONTHS.indexOf(_monthChoice!);
    if (_usedDatePicker) {
      setMonthStartDate(month: month + 1);
    } else {
      setMonthDayOfWeek();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.header,
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(height: 10.0.h),
        Text(
          widget.description,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.black,
              ),
        ),
        SizedBox(height: 15.0.h),
        _RepeatabilityPicker(
          onRepeatUnitChanged: _onRepeatUnitChanged,
          onRepeatChoiceChanged: _onRepeatChoiceChanged,
          repeatChoice: _repeatChoice,
          repeatUnit: _repeatUnit,
          repeatabilityChoices: _repeatabilityChoices,
          repeatUnitController: _repeatUnitController,
          repeatUnitFocusNode: widget.repeatUnitFocusNode,
          editable: widget.editable,
        ),
        const SizedBox(height: 10),
        if (_repeatChoice == RepeatChoices.week) _weekdayPicker(),
        if (_repeatChoice != RepeatChoices.month)
          _StartDatePicker(
            startDate: this._startDate,
            onSelectStartDate: _selectStartDateHandler(),
            editable: widget.editable,
          ),
        if (_repeatChoice == RepeatChoices.month)
          _DayOfMonth(
            startDayOfMonth: _startDayOfMonth,
            ordinalChoice: _ordinalChoice,
            monthDayChoice: _monthDayChoice,
            monthChoice: _monthChoice,
            ordinalNumbers: Schedule.ordinalNumbers,
            onShowDayOfMonthPicker: () => showDayOfMonthPicker(),
            onOrdinalChoiceChanged: _onOrdinalChoiceChanged,
            onMonthDayChoiceChanged: _onMonthDayChoiceChanged,
            onMonthChoiceChanged: _onMonthChoiceChanged,
            editable: widget.editable,
          ),
      ],
    );
  }
}

class _DayOfMonthPickerBody extends StatelessWidget {
  final int markedStartDayOfMonth;
  final void Function(int) onDayPressed;
  final void Function() onCancel;
  final void Function() onConfirm;
  const _DayOfMonthPickerBody({
    Key? key,
    required this.markedStartDayOfMonth,
    required this.onDayPressed,
    required this.onCancel,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
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
                style: Theme.of(context).textTheme.headline5,
              ),
              DayOfMonthPicker(
                width: MediaQuery.of(context).size.width * 0.95,
                padding: EdgeInsets.all(5.0),
                onDayPressed: this.onDayPressed,
                markedDay: this.markedStartDayOfMonth,
              ),
              Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppButton("Cancel", kTealColor, false, onCancel),
                    AppButton("Confirm", kTealColor, true, onConfirm),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarPickerBody extends StatelessWidget {
  final double height;
  final RepeatChoices repeatChoice;
  final List<DateTime?> startDates;
  final List<int> selectableDays;
  final List<DateTime?> selectableDates;
  final void Function(DateTime) onDayPressed;
  final void Function() onCancel;
  final void Function() onConfirm;
  const _CalendarPickerBody({
    Key? key,
    required this.height,
    required this.repeatChoice,
    required this.startDates,
    required this.selectableDays,
    required this.selectableDates,
    required this.onDayPressed,
    required this.onCancel,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Text(
                "Start Date",
                style: Theme.of(context).textTheme.headline5,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.65,
                padding: EdgeInsets.all(5.0),
                child: CalendarCarousel(
                  width: MediaQuery.of(context).size.width * 0.95,
                  onDayPressed: this.onDayPressed,
                  markedDatesMap: this.startDates,
                  selectableDaysMap: this.repeatChoice == RepeatChoices.week
                      ? this.selectableDays
                      : [1, 2, 3, 4, 5, 6, 0],
                  selectableDates: this.selectableDates,
                ),
              ),
              Flexible(
                child: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton("Cancel", kTealColor, false, onCancel),
                      AppButton("Confirm", kTealColor, true, onConfirm),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayOfMonth extends StatelessWidget {
  final int startDayOfMonth;
  final String? ordinalChoice;
  final String? monthDayChoice;
  final String? monthChoice;
  final List<String?> ordinalNumbers;
  final void Function() onShowDayOfMonthPicker;
  final void Function(String?) onOrdinalChoiceChanged;
  final void Function(String?) onMonthDayChoiceChanged;
  final void Function(String?) onMonthChoiceChanged;
  final bool editable;
  const _DayOfMonth({
    Key? key,
    required this.startDayOfMonth,
    required this.ordinalChoice,
    required this.monthDayChoice,
    required this.monthChoice,
    required this.ordinalNumbers,
    required this.onShowDayOfMonthPicker,
    required this.onOrdinalChoiceChanged,
    required this.onMonthDayChoiceChanged,
    required this.onMonthChoiceChanged,
    required this.editable,
  }) : super(key: key);

  // change state functions
  String getOrdinal(int input) {
    int value = input % 100;

    if (3 < value && value < 21) {
      return "${input}th";
    }

    switch (input % 10) {
      case 1:
        return "${input}st";
      case 2:
        return "${input}nd";
      case 3:
        return "${input}rd";
      default:
        return "${input}th";
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50.0.h,
          width: double.infinity,
          child: AppButton(
            this.startDayOfMonth == 0
                ? 'Select Start Day'
                : '${getOrdinal(this.startDayOfMonth)} of the month',
            kTealColor,
            true,
            this.editable ? this.onShowDayOfMonthPicker : null,
            textStyle: TextStyle(fontSize: 20.0.sp),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.01),
            child: Text(
              'or',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0.r),
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  color: Colors.grey[200],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: this.ordinalNumbers.map((String? choice) {
                      return DropdownMenuItem<String>(
                        value: choice,
                        child: Text(choice!),
                      );
                    }).toList(),
                    value: this.ordinalChoice,
                    onChanged:
                        this.editable ? this.onOrdinalChoiceChanged : null,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 20.0.sp,
                        ),
                    iconSize: 24.0.sp,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0.r),
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  color: Colors.grey[200],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: en_USSymbols.WEEKDAYS.map((String choice) {
                      return DropdownMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList(),
                    value: this.monthDayChoice,
                    onChanged:
                        this.editable ? this.onMonthDayChoiceChanged : null,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 20.0.sp,
                        ),
                    iconSize: 24.0.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Row(
          children: [
            Text(
              'Start Month',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 20.0.sp,
                  ),
            ),
            SizedBox(width: 10.0.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0.r),
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  color: Colors.grey[200],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: en_USSymbols.MONTHS.map((String choice) {
                      return DropdownMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList(),
                    value: this.monthChoice,
                    onChanged: this.editable ? this.onMonthChoiceChanged : null,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 20.0.sp,
                        ),
                    iconSize: 24.0.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StartDatePicker extends StatelessWidget {
  final DateTime? startDate;
  final void Function()? onSelectStartDate;
  final bool editable;
  const _StartDatePicker({
    Key? key,
    required this.startDate,
    required this.onSelectStartDate,
    required this.editable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Start date",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.normal, fontSize: 18.0.sp),
        ),
        SizedBox(width: 15.0.w),
        Expanded(
          child: SizedBox(
            height: 50.0.h,
            child: AppButton(
              this.startDate != null
                  ? DateFormat.MMMMd().format(this.startDate!)
                  : "Select Start Date",
              kTealColor,
              true,
              this.editable ? this.onSelectStartDate : null,
              textStyle: TextStyle(
                fontSize: 20.0.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RepeatabilityPicker extends StatelessWidget {
  final void Function(String) onRepeatUnitChanged;
  final void Function(RepeatChoices?) onRepeatChoiceChanged;
  final RepeatChoices repeatChoice;
  final String repeatUnit;
  final List<RepeatChoices>? repeatabilityChoices;
  final TextEditingController repeatUnitController;
  final FocusNode repeatUnitFocusNode;
  final bool editable;
  const _RepeatabilityPicker({
    Key? key,
    required this.onRepeatUnitChanged,
    required this.onRepeatChoiceChanged,
    required this.repeatChoice,
    required this.repeatUnit,
    required this.repeatabilityChoices,
    required this.repeatUnitController,
    required this.editable,
    required this.repeatUnitFocusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Every",
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 20.0.sp,
                  ),
            ),
            SizedBox(width: 30.0.w),
            Container(
              width: 60.0.w,
              child: TextField(
                enabled: this.editable,
                onChanged: this.onRepeatUnitChanged,
                controller: this.repeatUnitController,
                focusNode: this.repeatUnitFocusNode,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: kTealColor,
                    ),
              ),
            ),
            SizedBox(width: 30.0.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0.r),
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  color: Colors.grey[200],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<RepeatChoices>(
                    items:
                        this.repeatabilityChoices!.map((RepeatChoices choice) {
                      return DropdownMenuItem<RepeatChoices>(
                        value: choice,
                        child: Text(
                          int.tryParse(this.repeatUnit) == 1
                              ? choice.value
                              : choice.value + "s",
                        ),
                      );
                    }).toList(),
                    value: this.repeatChoice,
                    onChanged:
                        this.editable ? this.onRepeatChoiceChanged : null,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 20.0.sp,
                        ),
                    iconSize: 24.0.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0.h),
        if ((int.tryParse(repeatUnit) ?? 0) <= 0)
          Text(
            "Please enter a valid repeat value.",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}
