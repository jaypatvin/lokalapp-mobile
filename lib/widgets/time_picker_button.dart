import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TimePickerButton extends StatefulWidget {
  final int minTime;
  final int maxTime;

  const TimePickerButton({this.minTime, this.maxTime});
  @override
  _TimePickerButtonState createState() => _TimePickerButtonState();
}

class _TimePickerButtonState extends State<TimePickerButton> {
  DateTime _date;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        DatePicker.showTime12hPicker(
          context,
          showTitleActions: true,
          onConfirm: (date) {
            setState(() {
              _date = date;
            });
          },
          currentTime: _date,
        );
      },
      color: Color(0xffF2F2F2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.12,
            child: Text(_date != null ? DateFormat.Hms().format(_date) : ""),
          ),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
