import 'package:flutter/material.dart';


class SetCustomoperatingHours extends StatefulWidget {
  bool value;
  Function onChanged;
  SetCustomoperatingHours({this.value, this.onChanged});
  @override
  _SetCustomoperatingHoursState createState() => _SetCustomoperatingHoursState();
}

class _SetCustomoperatingHoursState extends State<SetCustomoperatingHours> {
  @override
  Widget build(BuildContext context) {
    return  Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 70,
                  width: 300,
                  child: ListTile(
                    title: Text(
                      "Set custom operating hours",
                      softWrap: true,
                      style: TextStyle(
                          fontFamily: "Goldplay",
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    leading: Checkbox(
                      activeColor: Colors.black,
                      value: widget.value,
                      onChanged: widget.onChanged,
                    
                    ),
                  ),
                ),
              ],
            );
  }
}