import 'package:flutter/material.dart';
import 'package:lokalapp/widgets/time_picker_button.dart';

class CondensedOperatingHours extends StatelessWidget {
  final String day;
  final DateTime minTime;
  final DateTime maxTime;
   Function onChanged;
   Function onCustom;
  final DateTime time;
   CondensedOperatingHours({this.day, this.minTime, this.maxTime, this.time, this.onChanged, this.onCustom});


  

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .25,
          child: Text(
            day,
            softWrap: true,
            style: TextStyle(fontFamily: "GoldplayBold", fontSize: 18),
          ),
        ),
        Container(
          height: 50,
          width: 130,
          child: TimePickerButton(
            minTime: 0,
            maxTime: 24,
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Container(
          height:50,
          width: 130,
          child: TimePickerButton(
            minTime: 0,

            maxTime: 60,
            onChanged: onCustom,
            // time: time,
          ),
        ),
      ],
    );
  }
}
