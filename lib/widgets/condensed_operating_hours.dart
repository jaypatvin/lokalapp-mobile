import 'package:flutter/material.dart';
import 'package:lokalapp/widgets/time_picker_button.dart';

class CondensedOperatingHours extends StatelessWidget {
  final String day;
  final DateTime minTime;
  final DateTime maxTime;

  const CondensedOperatingHours({this.day, this.minTime, this.maxTime});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .20,
            child: Text(
              day,
            ),
          ),
          TimePickerButton(
            minTime: 0,
            maxTime: 24,
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          TimePickerButton(
            minTime: 0,
            maxTime: 60,
          ),
        ],
      ),
    );
  }
}
