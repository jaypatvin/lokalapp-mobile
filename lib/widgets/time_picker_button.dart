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
  DateTime _date = DateTime.now();
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
            child: Text(DateFormat.Hms().format(_date)),
          ),

          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  // DropdownButton<int> androidDropDown() {
  //   List<DropdownMenuItem<int>> dropDownItems = [];
  //   for (int i = widget.minTime; i <= widget.maxTime; i++) {
  //     dropDownItems.add(
  //       DropdownMenuItem(
  //         child: Text(
  //           i.toString(),
  //         ),
  //         value: i,
  //       ),
  //     );
  //   }

  //   return DropdownButton<int>(
  //     hint: Text(widget.minTime.toString()),
  //     items: dropDownItems,
  //     value: _value,
  //     onChanged: (value) {
  //       setState(() => _value = value);
  //     },
  //   );
  // }

  // CupertinoTheme iOSPicker() {
  //   List<Widget> pickerItems = [];
  //   for (int i = widget.minTime; i <= widget.maxTime; i++) {
  //     pickerItems.add(
  //       Center(
  //         child: Text("$i"),
  //       ),
  //     );
  //   }
  //   return CupertinoTheme(
  //     data: CupertinoThemeData(
  //       textTheme: CupertinoTextThemeData(
  //         pickerTextStyle: TextStyle(color: Colors.white),
  //       ),
  //     ),
  //     child: CupertinoPicker(
  //       itemExtent: 32.0,
  //       onSelectedItemChanged: (selectedIndex) {
  //         setState(() {
  //           _value = widget.minTime + 1;
  //         });
  //       },
  //       children: pickerItems,
  //     ),
  //   );
  // }
}
