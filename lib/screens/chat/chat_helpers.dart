import 'package:flutter/material.dart';

import '../../utils/themes.dart';

class ChatHelpers {
  showAlert(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 22),
        // contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        content: Container(
          height: height * 0.3,
          width: width * 0.9,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Container(
            width: width * 0.9,
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        width: width * 0.25,
                        child: Icon(
                          Icons.chat_bubble,
                          size: 80,
                          color: Color(0xffCC3752),
                        ),
                      ),
                      Text(
                        "Chat",
                        style: TextStyle(color: Color(0xffCC3752)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 5, right: 15, bottom: 5),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding:
                                EdgeInsets.only(top: 30, right: 15, bottom: 5),
                            child: Text(
                              'This is where you can send ',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(right: 15, bottom: 5, top: 1),
                            child: Text(
                              'messages,photos and videos',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                              padding:
                                  EdgeInsets.only(right: 30, bottom: 5, top: 1),
                              child: Text(
                                'to other members of this ',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 14),
                              )),
                          Container(
                              padding:
                                  EdgeInsets.only(right: 25, bottom: 5, top: 1),
                              child: Text(
                                ' community. ',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 14),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Center(
                                child: Container(
                                  height: 43,
                                  width: 180,
                                  child: FlatButton(
                                    color: kTealColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(color: kTealColor),
                                    ),
                                    textColor: kTealColor,
                                    child: Text(
                                      "Okay!",
                                      style: TextStyle(
                                          fontFamily: "Goldplay",
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
