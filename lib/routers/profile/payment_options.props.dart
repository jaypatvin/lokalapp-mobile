import 'dart:io';

import '../../widgets/schedule_picker.dart';

class SetUpPaymentOptionsProps {
  final void Function() onSubmit;
  final bool edit;

  const SetUpPaymentOptionsProps({required this.onSubmit, this.edit = false,});
}
