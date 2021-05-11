import 'package:flutter/material.dart';
import 'time_picker_button.dart';

class CondensedOperatingHours extends StatelessWidget {
  final String day;
  final DateTime minTime;
  final DateTime maxTime;
  final Function onChangedOpening;
  final Function onChangedClosing;
  final DateTime time;
  CondensedOperatingHours(
      {this.day,
      this.minTime,
      this.maxTime,
      this.time,
      this.onChangedOpening,
      this.onChangedClosing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .1,
          child: Text(
            day,
            softWrap: true,
            style: TextStyle(
              fontFamily: "GoldplayBold",
              // fontSize: 16
            ),
          ),
        ),
        Container(
          height: 50,
          width: 123,
          child: TimePickerButton(
            minTime: 0,
            maxTime: 24,
            onChanged: onChangedOpening,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Container(padding: const EdgeInsets.all(5), child: Text("to:")),
        Container(
          height: 50,
          width: 130,
          child: TimePickerButton(
            minTime: 0,
            maxTime: 60,
            onChanged: onChangedClosing,
            // time: time,
          ),
        ),
      ],
    );
  }
}
