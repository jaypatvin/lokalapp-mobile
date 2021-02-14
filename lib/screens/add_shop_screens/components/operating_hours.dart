import 'package:flutter/material.dart';
import 'time_picker_button.dart';

class OperatingHours extends StatelessWidget {
  final String state;
  final DateTime time;
  final Function onChanged;
  OperatingHours({this.state, this.time, this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 8,
        ),
        Container(
          width: MediaQuery.of(context).size.width * .33,
          child: Text(
            state,
            softWrap: true,
            style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontFamily: "GoldplayBold",
                fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.50,
            height: MediaQuery.of(context).size.height * 0.1,
            child: TimePickerButton(
              minTime: 0,
              maxTime: 24,
              onChanged: onChanged,
              time: time,
            ),
          ),
        ),
      ],
    );
  }
}
