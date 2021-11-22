import 'dart:io';

import '../../widgets/schedule_picker.dart';

class CustomizeAvailabilityProps {
  const CustomizeAvailabilityProps({
    required this.repeatChoice,
    required this.selectableDays,
    required this.startDate,
    required this.repeatEvery,
    required this.usedDatePicker,
    this.shopPhoto,
    this.forEditing = false,
    this.onShopEdit,
  });

  final RepeatChoices repeatChoice;
  final int? repeatEvery;
  final List<int> selectableDays;
  final DateTime startDate;
  final File? shopPhoto;
  final bool usedDatePicker;
  final bool forEditing;
  final Function? onShopEdit;
}
