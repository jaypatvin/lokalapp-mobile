import 'package:flutter/material.dart';
import 'package:lokalapp/widgets/time_picker_button.dart';

class OperatingHours extends StatelessWidget {
  final String state;

  const OperatingHours({this.state});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .25,
          child: Text(
            state,
          ),
        ),
        TimePickerButton(
          minTime: 0,
          maxTime: 24,
        ),
      ],
    );
  }
}
