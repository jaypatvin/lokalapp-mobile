import 'package:flutter/material.dart';


class SetCustomoperatingHours extends StatefulWidget {
  bool value;
  Function onChanged;
  final String label;
  SetCustomoperatingHours({this.value, this.onChanged, this.label});
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
                  height: 40,
                  width: 290,
                  child: ListTile(
                    title: Text(
                      widget.label,
                      softWrap: true,
                      style: TextStyle(
                          fontFamily: "Goldplay",
                          fontSize: 13,
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
                SizedBox(height: 20,),
              ],
            );
  }
}