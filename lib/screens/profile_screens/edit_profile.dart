import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:lokalapp/providers/user.dart';

import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/utils/utility.dart';

import 'package:lokalapp/widgets/photo_box.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _fNameController = TextEditingController();

  TextEditingController _lNameController = TextEditingController();

  TextEditingController _streetController = TextEditingController();

  TextEditingController _locationController = TextEditingController();

  var updatedProfileUrl;
  bool updatedImage = false;
  buildInput(String initialVal, Function onChanged, context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.only(top: 6),
      // height: MediaQuery.of(context).size.height * 0.5,
      child: TextFormField(
        initialValue: initialVal,
        onChanged: onChanged,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 13,
          ),
          hintText: '',
          hintStyle: TextStyle(
            fontFamily: "GoldplayBold",
            fontSize: 14,
            color: Colors.white,
            // fontWeight: FontWeight.w500
          ),
          alignLabelWithHint: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                30.0,
              ),
            ),
          ),
          errorText: '',
        ),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontFamily: "GoldplayBold",
          fontSize: 20.0,
          // fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  // Future updateUser(context) async {
  //   var user = Provider.of<CurrentUser>(context, listen: false);
  //   try {
  //     LokalUser lokalUser = LokalUser(
  //       firstName: _fNameController.text,
  //       lastName: _lNameController.text,
  //       // address: _streetController.text
  //     );

  //     await Database()
  //         .updateUser(lokalUser,key, value);
  //     Navigator.pop(context);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Widget get buildButton => Container(
        height: 43,
        width: 190,
        padding: const EdgeInsets.all(2),
        child: FlatButton(
          color: kTealColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: kTealColor),
          ),
          textColor: Colors.black,
          child: Text(
            "Apply Changes",
            style: TextStyle(
                fontFamily: "Goldplay",
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            // updateUser(context);
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<CurrentUser>(context, listen: false);
    return Scaffold(
        backgroundColor: Color(0xffF1FAFF),
        resizeToAvoidBottomInset: true,
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
                margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_sharp,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        "Edit Profile",
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
        body: ListView(
            // physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              Column(children: [
                SizedBox(
                  height: 30,
                ),
                Stack(children: [
                  updatedImage
                      ? Center(
                          child: PhotoBox(
                              file: updatedProfileUrl, shape: BoxShape.circle),
                        )
                      : CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(user.profilePhoto)),
                  updatedImage
                      ? Container()
                      : Positioned(
                          top: 40,
                          left: 40,
                          right: 40,
                          bottom: 40,
                          child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                              child: Container(
                                color: Colors.black.withOpacity(0),
                              )),
                        ),
                  Positioned(
                      top: 5,
                      left: 13,
                      right: 5,
                      bottom: 0,
                      child: Row(
                        children: [
                          updatedImage
                              ? Text("")
                              : Icon(
                                  Icons.create,
                                  color: Colors.white,
                                  size: 16,
                                ),
                          TextButton(
                            onPressed: () async {
                              setState(() async {
                                updatedProfileUrl =
                                    await Provider.of<MediaUtility>(context,
                                            listen: false)
                                        .showMediaDialog(context);
                                updatedImage = true;
                              });
                            },
                            child: Text(
                              updatedImage ? " " : "Edit Photo",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  fontFamily: "GoldplayBold",
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      )),
                ]),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                buildInput(user.firstName, (value) {
                  _fNameController.text = value;
                }, context),
                buildInput(user.lastName, (value) {
                  _lNameController.text = value;
                }, context),
                SizedBox(
                  height: 20,
                ),
                buildInput(user.address.street, (value) {
                  _streetController.text = value;
                }, context),
                SizedBox(
                  height: 15,
                ),
                buildButton
              ])
            ]));
  }
}
