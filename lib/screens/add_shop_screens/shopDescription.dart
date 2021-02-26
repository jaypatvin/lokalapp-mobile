import 'package:flutter/material.dart';
import 'package:lokalapp/services/database.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:provider/provider.dart';

class ShopDescription extends StatefulWidget {
  Function onChanged;
  String hintText;
  String errorText;
  TextEditingController descriptionController;
  ShopDescription(
      {this.descriptionController,
      this.onChanged,
      this.hintText,
      this.errorText});
  @override
  _ShopDescriptionState createState() => _ShopDescriptionState();
}

class _ShopDescriptionState extends State<ShopDescription> {
  final maxLines = 10;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.all(12),
          height: maxLines * 15.0,
          width: MediaQuery.of(context).size.width * 0.7,
          color: Color(0xffE0E0E0),
          child: TextField(
            controller: widget.descriptionController,
            onChanged: widget.onChanged,
            cursorColor: Colors.black,
            keyboardType: TextInputType.multiline,
            maxLines: maxLines,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                errorText: widget.errorText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.grey.shade500,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
                ),
                // errorBorder: InputBorder.none,
                // disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 18, bottom: 11, top: 30, right: 15),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 14,
                  fontFamily: "GoldplayBold",
                  // fontWeight: FontWeight.w500,
                )),
          ),
        ),
      ],
    );
  }
}
