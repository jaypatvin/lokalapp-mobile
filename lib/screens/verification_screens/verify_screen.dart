import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/local_image_service.dart';
import '../../states/current_user.dart';
import '../../utils/themes.dart';
import '../../widgets/rounded_button.dart';
import '../bottom_navigation.dart';
import 'verify_confirmation_screen.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  List<String> _ids = [
    "Driver's License",
    "Old Philippine Passport (Issued before 15 Aug 2016)",
    "New Philippine Passport",
    "Unified Multipurpose ID",
  ];

  String _chosenIdType;

  Future<void> selectImage(parentContext) async {
    return await showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Upload Picture"),
          children: [
            SimpleDialogOption(
              child: Text("Camera"),
              onPressed: () {
                Provider.of<LocalImageService>(context, listen: false)
                    .launchCamera();
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: Text("Gallery"),
              onPressed: () {
                Provider.of<LocalImageService>(context, listen: false)
                    .launchGallery();
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  Widget androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (var id in _ids) {
      dropDownItems.add(
        DropdownMenuItem(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              id,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          value: id,
        ),
      );
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        hint: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Select type of ID",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        value: _chosenIdType,
        isExpanded: true,
        items: dropDownItems,
        focusColor: Colors.white,
        icon: Icon(
          Icons.arrow_drop_down,
          color: kTealColor,
        ),
        iconSize: 24.0,
        onChanged: (value) {
          setState(() => _chosenIdType = value);
        },
      ),
    );
  }

  Widget iOSPicker() {
    List<Widget> pickerItems = [];

    for (var id in _ids) {
      pickerItems.add(
        Center(
          child: Text(
            id,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          pickerTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ),
      ),
      child: CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          setState(() => _chosenIdType = _ids[selectedIndex]);
        },
        children: pickerItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                    color: kTealColor,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNavigation()),
                          (route) => false);
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        color: kTealColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "GoldPlay",
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Text(
                "Verify Your Account",
                style: TextStyle(
                  fontSize: 30.0,
                  color: kNavyColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Goldplay",
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Text(
                "In order to access all of Lokal's features, we need to verify your identity",
                style: TextStyle(
                  fontSize: 16.0,
                  color: kNavyColor,
                  fontFamily: "Goldplay",
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Container(
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
                child: Platform.isIOS ? iOSPicker() : androidDropDown(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              ButtonTheme(
                minWidth: double.infinity,
                height: MediaQuery.of(context).size.height * 0.05,
                child: FlatButton(
                  child: Text(
                    "UPLOAD PHOTO OF ID",
                    style: TextStyle(
                        color: Color(0XFF09A49A),
                        fontFamily: "Goldplay",
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: Color(0XFF09A49A))),
                  onPressed: () {
                    selectImage(context);
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              RoundedButton(
                onPressed: () async {
                  LocalImageService picker =
                      Provider.of<LocalImageService>(context, listen: false);
                  if (picker.fileExists) {
                    String mediaUrl = await picker.uploadImage();

                    if (mediaUrl != null && mediaUrl.isNotEmpty) {
                      Provider.of<CurrentUser>(context, listen: false)
                        ..updateUserRegistrationInfo(
                          idPhoto: mediaUrl,
                          idType: _chosenIdType,
                        )
                        ..verifyUser().then((bool verified) {
                          if (verified) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VerifyConfirmationScreen()),
                                (route) => false);
                          } else {
                            // failed, do nothing
                          }
                        });
                    }
                  }
                },
                height: MediaQuery.of(context).size.height * 0.05,
                label: "SUBMIT",
                fontSize: 16.0,
                minWidth: MediaQuery.of(context).size.width * 0.30,
                fontFamily: "GoladplayBold",
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
