import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/themes.dart';
import 'draft_post.dart';
import 'timeline.dart';

class Home extends StatelessWidget {
  Padding buildTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 0),
      child: Column(
        children: [
          Container(
            child: Theme(
              data: ThemeData(primaryColor: Colors.grey.shade400),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DraftPost()));
                },
                child: TextField(
                  enabled: false,
                  textAlign: TextAlign.justify,
                  decoration: InputDecoration(
                    isDense: true, // Added this
                    filled: true,
                    contentPadding: EdgeInsets.only(
                        left: 18, bottom: 11, top: 14, right: 15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      // borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                    ),
                    fillColor: Colors.white,
                    suffixIcon: Icon(
                      Icons.assignment_turned_in,
                      color: Color(0xffE0E0E0),
                    ),
                    hintText: 'What\'s on your mind?',

                    alignLabelWithHint: true,
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                buildTextField(context),
                SizedBox(
                  height: 8,
                ),
                Timeline(),
              ],
            ),
          ),
        ));
  }
}
