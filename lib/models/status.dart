enum Status {
  enabled,
  disabled,
}

extension StatusValues on Status {
  String get value {
    switch (this) {
      case Status.enabled:
        return 'enabled';
      default:
        return 'disabled';
    }
  }
}
