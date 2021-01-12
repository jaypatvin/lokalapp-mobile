import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/states/currentUser.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controller = TextEditingController();

  Padding buildTextField() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
      child: Container(
        child: Theme(
          data: ThemeData(primaryColor: Color(0xffE0E0E0)),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              isDense: true, // Added this
              // contentPadding: EdgeInsets.all(10),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: Icon(
                Icons.assignment_turned_in,
                color: Color(0xffE0E0E0),
              ),
              hintText: 'What\'s on your mind?',
              hintStyle: TextStyle(color: Color(0xffE0E0E0)),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(12.0),
                ),
                borderSide: BorderSide(color: Color(0xffE0E0E0), width: 2.0),
              ),
              // enabledBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.grey, width: 2.0),
              // ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser _user = Provider.of<CurrentUser>(context);

    return Scaffold(
        backgroundColor: Color(0xffF1FAFF),
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
              ],
            ),
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Container(
              decoration: BoxDecoration(color: kTealColor),
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text(
                        "White Plains",
                        style: TextStyle(
                            fontFamily: "Goldplay",
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color(0XFFFFC700)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: buildTextField());
  }
}
