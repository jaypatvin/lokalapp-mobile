import 'package:flutter/material.dart';
import 'package:lokalapp/screens/add_shop_screens/components/time_picker_button.dart';
// import 'package:lokalapp/widgets/time_picker_button.dart';

class OperatingHours extends StatelessWidget {
  final String state;
  final DateTime time;
  Function onChanged;
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
                fontSize: 16,
                color: Colors.black,
                fontFamily: "GoldplayBold",
                fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.30,
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
