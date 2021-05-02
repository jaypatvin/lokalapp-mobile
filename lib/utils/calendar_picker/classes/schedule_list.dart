import 'dart:collection';

class ScheduleList {
  //Map<DateTime, bool> _schedule;
  List<DateTime> _schedule;

  ScheduleList(this._schedule);

  List<DateTime> get schedule => UnmodifiableListView(_schedule);

  void add(DateTime date) {
    if (!_schedule.contains(date)) _schedule.add(date);
  }

  void remove(DateTime date) {
    if (_schedule.contains(date)) _schedule.remove(date);
  }

  void addAll(List<DateTime> dates) {
    _schedule.addAll(dates);
  }

  void removeAll(List<DateTime> dates) {
    for (var date in dates) {
      if (_schedule.contains(date)) _schedule.remove(date);
    }
  }

  void clear() {
    if (_schedule != null) {
      _schedule.clear();
    } else {
      _schedule = [];
    }
  }

  bool contains(DateTime date) {
    return _schedule.contains(date);
  }
}
