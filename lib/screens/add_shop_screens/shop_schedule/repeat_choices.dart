enum RepeatChoices { day, week, month }

extension RepeatChoicesExtension on RepeatChoices {
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
