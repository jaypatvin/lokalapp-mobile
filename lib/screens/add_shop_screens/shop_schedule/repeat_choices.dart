enum RepeatChoices { days, weeks, months }

extension RepeatChoicesExtension on RepeatChoices {
  String get value {
    switch (this) {
      case RepeatChoices.days:
        return 'Days';
      case RepeatChoices.weeks:
        return 'Weeks';
      case RepeatChoices.months:
        return 'Months';
      default:
        return null;
    }
  }
}
