import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:lokalapp/utils/themes.dart';

class TimePickerButton extends StatefulWidget {
  final int minTime;
  final int maxTime;
  final double width;
  final double height;
  final   DateTime time;
    Function onChanged;
   TimePickerButton(
      {this.minTime, this.maxTime, this.height, this.width, this.time, this.onChanged});
  @override
  _TimePickerButtonState createState() => _TimePickerButtonState();
}

class _TimePickerButtonState extends State<TimePickerButton> {
  DateTime _date = DateTime.now();
  String day;
  double height;
  double width;
  DateTime time;


  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        DatePicker.showTime12hPicker(
          context,
          
          showTitleActions: true,
          onChanged: widget.onChanged,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: this.width,
                height: this.height,
                color: Color(0xffF2F2F2),
                child: Text(DateFormat.Hms().format(_date)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [

              Icon(
                Icons.arrow_drop_down_sharp,
                color: kTealColor,
                size: 35,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
