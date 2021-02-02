import 'package:flutter/material.dart';

class ShopDescription extends StatefulWidget {
  @override
  _ShopDescriptionState createState() => _ShopDescriptionState();
}

class _ShopDescriptionState extends State<ShopDescription> {
    TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return     Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Color(0xffE0E0E0),
                  child: Card(
                    
                    child: TextField(
                      controller: _descriptionController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 1,
                              style: BorderStyle.none,
                            ),
                          ),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 18, bottom: 11, top: 30, right: 15),
                          hintText: "Shop Description",
                          hintStyle: TextStyle(
                              color: Color(0xFFBDBDBD),
                              fontFamily: "Goldplay",
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            );
  }
}