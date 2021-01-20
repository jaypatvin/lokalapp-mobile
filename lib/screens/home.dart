import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lokalapp/services/database.dart';
import 'package:lokalapp/states/currentUser.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';

import 'timeline.dart';

class Home extends StatefulWidget {
  final dynamic message;

  final Map <String, String>account;
  Home({this.message, this.account});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _userController = TextEditingController();
  dynamic message;

  Padding buildTextField(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
      child: Column(
        children: [
          Container(
            child: Theme(
              data: ThemeData(primaryColor: Color(0xFFE0E0E0)),
              child: TextField(
                controller: _userController,

                onSubmitted: (value){
                    _postMessage(context);
                },

                decoration: InputDecoration(
                  isDense: true, // Added this
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(14.0),
                    ),
                  ),
                  fillColor: Colors.white,
                  suffixIcon: Icon(
                    Icons.assignment_turned_in,
                    color: Color(0xffE0E0E0),
                  ),
                  hintText: 'What\'s on your mind?',
                  hintStyle: TextStyle(color: Color(0xFFE0E0E0)),
                ),
              ),
            ),
          ),
        
        ],
      ),
    );
  }

  Future _postMessage(BuildContext context) async {
    if (_userController.text.length > 0) {
      await Database().postMessage(widget.account, _userController.text);
      Navigator.pop(context, true);
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please type a message'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _userController.addListener(() {
      setState(() {
        this.message = _userController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser _user = Provider.of<CurrentUser>(context, listen: false);
    
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
                  child: Column(
            children: [
            buildTextField(context),
            RaisedButton(onPressed: (){
              _user.onSignOut();
            },child: Text("logout"),),
            SizedBox(height: 8,),
              Timeline(account: widget.account)
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _userController.dispose();

    super.dispose();
  }
}
