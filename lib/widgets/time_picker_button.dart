import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:lokalapp/models/user_shop_post.dart';
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
          // onChanged: (value){setState(() {
          //   time = value;
          // });},
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: this.width,
            height: this.height,
            color: Color(0xffF2F2F2),
            child: Text(DateFormat.Hms().format(_date)),
          ),
          Icon(
            Icons.arrow_drop_down_sharp,
            color: kTealColor,
            size: 35,
          ),
        ],
      ),
    );
  }
}
