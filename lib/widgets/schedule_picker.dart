import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import 'package:lokalapp/utils/repeated_days_generator/repeated_days_generator.dart';
import 'package:lokalapp/widgets/app_button.dart';

import '../models/operating_hours.dart';
import '../utils/calendar_picker/calendar_picker.dart';
import '../utils/calendar_picker/day_of_month_picker.dart';
import '../utils/calendar_picker/weekday_picker.dart';
import '../utils/functions.utils.dart';
import '../utils/repeated_days_generator/schedule_generator.dart';
import '../utils/themes.dart';
import 'rounded_button.dart';

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
      default:
        return null;
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
  final void Function(List<DateTime>) onStartdatesChanged;

  /// Start date for the schedule generation
  final void Function(
    DateTime, {
    String repeatType,
  }) onStartDateChanged;

  /// Function to be called when repeat type (day, week, month) is changed.
  ///
  /// Since the monthPicker has two states, we need to determine if the user
  /// used the datePicker or the dropDown buttons for picking the startDate.
  final void Function(String) onRepeatTypeChanged;

  /// Function to be called when repeat unit (every n - type) is changed
  final void Function(int) onRepeatUnitChanged;

  final void Function(List<int>) onSelectableDaysChanged;

  /// OperatingHours is needed for subscription schedule.
  ///
  /// If this is null (which should only be used in shop creation),
  /// schedule generation is non-limited.
  final OperatingHours operatingHours;

  /// A reusable widget used for picking schedules for shops and subscriptions.
  const SchedulePicker({
    Key key,
    @required this.header,
    @required this.description,
    @required this.onStartdatesChanged,
    @required this.onStartDateChanged,
    @required this.onRepeatTypeChanged,
    @required this.onRepeatUnitChanged,
    @required this.onSelectableDaysChanged,
    this.operatingHours,
  }) : super(key: key);

  @override
  _SchedulePickerState createState() => _SchedulePickerState();
}

class _SchedulePickerState extends State<SchedulePicker> {
  final _scheduleGenerator = ScheduleGenerator();

  List<int> _selectableDays = [];
  List<DateTime> _selectableDates = [];

  DateTime _startDate;
  List<DateTime> _startDates = [];

  int _markedStartDayOfMonth = 0;
  int _startDayOfMonth = 0;

  String _ordinalChoice;
  String _monthChoice;
  String _monthDayChoice;

  RepeatChoices _repeatChoice = RepeatChoices.day;
  String _repeatUnit = "";

  bool _usedDatePicker = true;

  @override
  void initState() {
    super.initState();

    if (widget.operatingHours != null &&
        isValidOperatingHours(widget.operatingHours)) {
      _onOperatingHoursInit();
    } else {
      _onNonOperatingHoursInit();
    }
  }

  // Called when operating hours is non-null and is valid.
  // Used on subscription schedule and edit-shop schedule.
  void _onOperatingHoursInit() {
    final _operatingHours = widget.operatingHours;

    final _schedule = _scheduleGenerator.generateSchedule(_operatingHours);

    this._repeatUnit = _schedule.repeatUnit.toString();
    this._repeatChoice = _schedule.repeatType;
    this._startDates = _schedule.startDates;
    this._selectableDays = _schedule.selectableDays;
    this._startDate = _schedule.startDate;
    this._startDayOfMonth = _schedule.startDayOfMonth;
    this._selectableDates = _schedule.selectableDates;

    // Month:
    var _ordinal = 0;
    _markedStartDayOfMonth = _startDayOfMonth;
    for (DateTime indexDay = DateTime(_startDate.year, _startDate.month, 1);
        indexDay.day <= _startDate.day;
        indexDay = indexDay.add(Duration(days: 1))) {
      if (indexDay.weekday == _startDate.weekday) {
        _ordinal++;
      }
    }
    _ordinalChoice = Schedule.ordinalNumbers[_ordinal - 1];
    _monthChoice = en_USSymbols.MONTHS[_startDate.month - 1];
    var _weekday = _startDate.weekday;
    if (_weekday == 7) _weekday = 7;
    _monthDayChoice = en_USSymbols.WEEKDAYS[_weekday];

    _usedDatePicker = _startDayOfMonth == 0;

    // startDates have changed!
    widget.onStartdatesChanged(_startDates);
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
    _ordinalChoice = Schedule.ordinalNumbers[0];
    var day = DateTime.now().weekday;
    if (day == 0) day = 7;
    _monthDayChoice = en_USSymbols.WEEKDAYS[day];
    _monthChoice = en_USSymbols.MONTHS[DateTime.now().month - 1];
  }

  void _onWeekDayPickerDayPressedHandler(int index) {
    setState(() {
      if (this._selectableDays.contains(index)) {
        this._selectableDays.remove(index);
        widget.onSelectableDaysChanged(this._selectableDays);
        if (this._startDates.isEmpty) return;
        final markedStart = this._startDates.first;
        var startDay = markedStart.weekday;
        if (startDay == 7) startDay = 0;
        if (startDay == index) this._startDates.clear();

        var day = this._startDate.weekday;
        if (day == 7) day = 0;
        if (day == index) {
          final now = DateTime.now();
          for (DateTime indexDay = DateTime(now.year, now.month, now.day);
              indexDay.month <= now.month + 1;
              indexDay = indexDay.add(Duration(days: 1)),) {
            var day = indexDay.weekday;
            if (day == 7) day = 0;
            if (this._selectableDays.contains(day)) {
              widget.onStartdatesChanged(_startDates);
              this._startDate = indexDay;
              return;
            } else {
              widget.onStartdatesChanged(_startDates);
              this._startDate = null;
            }
          }
        }
      } else {
        this._selectableDays.add(index);
        widget.onSelectableDaysChanged(this._selectableDays);
        if (this._startDates.isNotEmpty) return;
        final now = DateTime.now();
        for (DateTime indexDay = DateTime(now.year, now.month, now.day);
            indexDay.month <= DateTime.now().month + 1;
            indexDay = indexDay.add(Duration(days: 1))) {
          int day = indexDay.weekday;
          if (day == 7) day = 0;
          if (day == index) {
            this._startDate = indexDay;
            this._startDates.add(indexDay);
            // widget.onStartDateChanged(_startDate);
            _onStartDateChanged();
            widget.onStartdatesChanged(_startDates);
            return;
          }
        }
      }
    });
  }

  // MONTH STATE:
  /* ------------------------------------------------------------------------ */
  Future<int> showDayOfMonthPicker() async {
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
            //repeatChoice = RepeatChoices.month;
            setMonthStartDate(day: _startDayOfMonth);
            Navigator.pop(context, this._startDayOfMonth);
          },
        );
      },
    );
  }

  void setMonthStartDate({int day, int month}) {
    _startDate ??= DateTime.now();

    setState(() {
      _startDate = DateTime(
        _startDate.year,
        month ?? _startDate.month,
        day ?? _startDate.day,
      );
    });
    // startDate has changed!
    // widget.onStartDateChanged(_startDate);
    _onStartDateChanged();
  }

  void setMonthDayOfWeek() {
    final weekdayIndex = en_USSymbols.WEEKDAYS.indexOf(_monthDayChoice);
    final ordinalNumber = Schedule.ordinalNumbers.indexOf(_ordinalChoice) + 1;
    final month = en_USSymbols.MONTHS.indexOf(_monthChoice);
    final startDates =
        RepeatedDaysGenerator.instance.getRepeatedMonthDaysByNthDay(
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

  Future<DateTime> showCalendarPicker() async {
    return await showDialog<DateTime>(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (BuildContext context) {
        return _CalendarPickerBody(
          height: MediaQuery.of(context).size.height,
          repeatChoice: _repeatChoice,
          startDates: _startDates,
          selectableDays: _selectableDays,
          selectableDates: this._selectableDates,
          onDayPressed: (day) {
            setState(() {
              if (_startDates.contains(day)) {
                _startDates.clear();
              } else {
                _startDates
                  ..clear()
                  ..add(day);
              }
              // startDates have changed!
              widget.onStartdatesChanged(_startDates);
            });
          },
          onCancel: () {
            _startDates
              ..clear()
              ..add(_startDate);
            widget.onStartdatesChanged(_startDates);
            Navigator.pop(context, _startDate);
          },
          onConfirm: () {
            setState(() {
              if (_startDates.isNotEmpty)
                _startDate = _startDates.first;
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
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        WeekdayPicker(
          onDayPressed: _onWeekDayPickerDayPressedHandler,
          markedDaysMap: _selectableDays,
        ),
        SizedBox(
          height: height * 0.02,
        ),
        if (_selectableDays.isEmpty)
          Text(
            "Select a day or days to repeat every week",
            style: kTextStyle.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.normal,
            ),
          ),
        SizedBox(
          height: height * 0.02,
        ),
      ],
    );
  }

  String _getRepeatType() {
    if (!_usedDatePicker) {
      final weekdayIndex = en_USSymbols.WEEKDAYS.indexOf(_monthDayChoice);
      final weekday = en_USSymbols.SHORTWEEKDAYS[weekdayIndex].toLowerCase();
      final ordinalNumber = Schedule.ordinalNumbers.indexOf(_ordinalChoice) + 1;
      final _repeatType = "$ordinalNumber-$weekday";
      // setState(() {
      //   _startDate = _getStartDateByNthDay(
      //     ordinalNumber: ordinalNumber,
      //     weekdayIndex: weekdayIndex,
      //   );
      // });
      print(_repeatType);
      return _repeatType;
    } else {
      final _repeatType = _repeatChoice.value?.toLowerCase();
      print(_repeatType);
      return _repeatType;
    }
  }

  void _onStartDateChanged() {
    final _repeatType = _getRepeatType();
    widget.onStartDateChanged(this._startDate, repeatType: _repeatType);
  }

  void _onRepeatUnitChanged(String _repeatUnit) {
    setState(() {
      this._repeatUnit = _repeatUnit;
    });
    widget.onRepeatUnitChanged(int.tryParse(_repeatUnit));
  }

  void _onRepeatChoiceChanged(RepeatChoices choice) {
    if (choice == _repeatChoice) return;
    if (this.mounted)
      setState(() {
        this._repeatChoice = choice;
      });

    _usedDatePicker = choice == RepeatChoices.month ? false : true;
    final repeatType = _getRepeatType();
    widget.onRepeatTypeChanged(repeatType);
  }

  void Function() _selectStartDateHandler() {
    if (_repeatChoice != RepeatChoices.week || _selectableDays.isNotEmpty) {
      return showCalendarPicker;
    } else {
      return null;
    }
  }

  void _onOrdinalChoiceChanged(String value) {
    setState(() {
      _ordinalChoice = value;
      _usedDatePicker = false;
    });
    setMonthDayOfWeek();
  }

  void _onMonthDayChoiceChanged(String value) {
    setState(() {
      _monthDayChoice = value;
      _usedDatePicker = false;
    });
    setMonthDayOfWeek();
  }

  void _onMonthChoiceChanged(String value) {
    setState(() {
      _monthChoice = value;
    });

    final month = en_USSymbols.MONTHS.indexOf(_monthChoice);
    if (_usedDatePicker) {
      setMonthStartDate(month: month + 1);
    } else {
      setMonthDayOfWeek();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.header,
          style: kTextStyle.copyWith(fontSize: 24.0),
        ),
        Text(
          widget.description,
          style: kTextStyle.copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: height * 0.02,
        ),
        _RepeatabilityPicker(
          onRepeatUnitChanged: _onRepeatUnitChanged,
          onRepeatChoiceChanged: _onRepeatChoiceChanged,
          repeatChoice: _repeatChoice,
          repeatUnit: _repeatUnit,
        ),
        SizedBox(height: height * 0.02),
        if (_repeatChoice == RepeatChoices.week) _weekdayPicker(),
        if (_repeatChoice != RepeatChoices.month)
          _StartDatePicker(
            startDate: this._startDate,
            onSelectStartDate: _selectStartDateHandler(),
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
    Key key,
    @required this.markedStartDayOfMonth,
    @required this.onDayPressed,
    @required this.onCancel,
    @required this.onConfirm,
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
                style: kTextStyle.copyWith(
                  fontSize: 24.0,
                ),
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
  final List<DateTime> startDates;
  final List<int> selectableDays;
  final List<DateTime> selectableDates;
  final void Function(DateTime) onDayPressed;
  final void Function() onCancel;
  final void Function() onConfirm;
  const _CalendarPickerBody({
    Key key,
    @required this.height,
    @required this.repeatChoice,
    @required this.startDates,
    @required this.selectableDays,
    @required this.selectableDates,
    @required this.onDayPressed,
    @required this.onCancel,
    @required this.onConfirm,
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
                style: kTextStyle.copyWith(
                  fontSize: 24.0,
                ),
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
  final String ordinalChoice;
  final String monthDayChoice;
  final String monthChoice;
  final List<String> ordinalNumbers;
  final void Function() onShowDayOfMonthPicker;
  final void Function(String) onOrdinalChoiceChanged;
  final void Function(String) onMonthDayChoiceChanged;
  final void Function(String) onMonthChoiceChanged;
  const _DayOfMonth({
    Key key,
    @required this.startDayOfMonth,
    @required this.ordinalChoice,
    @required this.monthDayChoice,
    @required this.monthChoice,
    @required this.ordinalNumbers,
    @required this.onShowDayOfMonthPicker,
    @required this.onOrdinalChoiceChanged,
    @required this.onMonthDayChoiceChanged,
    @required this.onMonthChoiceChanged,
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
        RoundedButton(
          textAlign: TextAlign.start,
          minWidth: double.infinity,
          label: this.startDayOfMonth == 0
              ? 'Select Start Day'
              : '${getOrdinal(this.startDayOfMonth)} of the month',
          onPressed: onShowDayOfMonthPicker,
          fontColor: Colors.white,
          fontSize: 20.0,
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.01),
            child: Text(
              'or',
              style: kTextStyle.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  color: Colors.grey[200],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: this.ordinalNumbers.map((String choice) {
                      return DropdownMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList(),
                    value: this.ordinalChoice,
                    onChanged: this.onOrdinalChoiceChanged,
                    style: kTextStyle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
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
                    onChanged: this.onMonthDayChoiceChanged,
                    style: kTextStyle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
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
              style: kTextStyle.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
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
                    onChanged: this.onMonthChoiceChanged,
                    style: kTextStyle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
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
  final DateTime startDate;
  final void Function() onSelectStartDate;
  const _StartDatePicker({
    Key key,
    @required this.startDate,
    @required this.onSelectStartDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Start date",
          style: kTextStyle.copyWith(
              fontWeight: FontWeight.normal, fontSize: 18.0),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
        ),
        Expanded(
          child: RoundedButton(
            textAlign: TextAlign.start,
            minWidth: double.infinity,
            label: this.startDate != null
                ? DateFormat.MMMMd().format(this.startDate)
                : "Select Start Date",
            onPressed: this.onSelectStartDate,
            // _repeatChoice != RepeatChoices.week ||
            //         _selectableDays.isNotEmpty
            //     ? showCalendarPicker
            //     : null,
            fontColor: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }
}

class _RepeatabilityPicker extends StatelessWidget {
  final void Function(String) onRepeatUnitChanged;
  final void Function(RepeatChoices) onRepeatChoiceChanged;
  final RepeatChoices repeatChoice;
  final String repeatUnit;
  const _RepeatabilityPicker({
    Key key,
    @required this.onRepeatUnitChanged,
    @required this.onRepeatChoiceChanged,
    @required this.repeatChoice,
    @required this.repeatUnit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Every",
          style: kTextStyle.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 20.0,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: TextField(
            onChanged: this.onRepeatUnitChanged,
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
            style: kTextStyle.copyWith(
              color: kTealColor,
              fontSize: 32.0,
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: Colors.transparent,
              ),
              color: Colors.grey[200],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<RepeatChoices>(
                items: RepeatChoices.values.map((RepeatChoices choice) {
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
                onChanged: this.onRepeatChoiceChanged,
                style: kTextStyle.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
