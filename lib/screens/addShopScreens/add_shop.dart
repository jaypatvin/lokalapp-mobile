import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lokalapp/models/user_shop_post.dart';
import 'package:lokalapp/screens/bottom_navigation.dart';
import 'package:lokalapp/screens/profileScreens/profile_shop.dart';
import 'package:lokalapp/services/database.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:lokalapp/widgets/condensed_operating_hours.dart';
import 'package:lokalapp/widgets/operating_hours.dart';
import 'package:lokalapp/widgets/rounded_button.dart';
import 'package:lokalapp/widgets/time_picker_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../utils/themes.dart';
import '../profile.dart';
import 'shopDescription.dart';
import 'package:image/image.dart' as Im;

class AddShop extends StatefulWidget {
  final Map<String, String> account;
  final dynamic description;
  final DateTime time;
  final String day;
  static String id = '/addShop';
  AddShop({Key key, this.account, this.description, this.time, this.day})
      : super(key: key);
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _date = DateTime.now();
  bool _setOperatingHours = false;
  File file;
  bool isUploading = false;
  String profilePhotoId = Uuid().v4();
  final picker = ImagePicker();
  String openingHour;
  String closingHour;
  String openingCustomHour;
  String closingCustomHour;

  DateTime _opening = DateTime.now();
  DateTime _closing = DateTime.now();

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$profilePhotoId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 90));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask = storageRef
        .child("profilePhotoId_$profilePhotoId.jpg")
        .putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future createStore() async {
    setState(() {
      isUploading = true;
    });
    String mediaUrl = "";
    if (file != null) {
      await compressImage();
      mediaUrl = await uploadImage(file);
    }
    CurrentUser _user = Provider.of<CurrentUser>(context, listen: false);

    _user.postShop.userUid = _user.getCurrentUser.userUids.first;
    _user.postShop.name = _shopNameController.text;
    _user.postShop.description = _descriptionController.text;
    _user.postShop.profilePhoto = mediaUrl;
    _user.postShop.coverPhoto = "";
    _user.postShop.isClosed = false;
    _user.postShop.opening = openingHour;
    _user.postShop.closing = closingHour;
    _user.postShop.useCustomHours = _setOperatingHours;
    _user.postShop.customHours =
        customHours.map((key, value) => MapEntry(key, value.toString()));
    _user.postShop.status = true.toString();
    await Database().getCommunityIdFromInvite(_user.getCurrentUser.communityId);
    bool success = await _user.createShop();
    if (success) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ProfileShop(hasStore: true)),
          (route) => false);
    }
  }

  PreferredSize buildAppBar() {
    return PreferredSize(
      preferredSize: Size(double.infinity, 130),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
          ],
        ),
        width: MediaQuery.of(context).size.width,
        height: 500,
        child: Container(
          decoration: BoxDecoration(color: Color(0xff57183f)),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 95, 0, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_sharp,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    SizedBox(
                      width: 98,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Add Shop",
                          style: TextStyle(
                              color: Color(0xFFFFC700),
                              fontFamily: "Goldplay",
                              fontSize: 28,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildShopName() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 1.3,
          child: TextField(
            onTap: () {},
            controller: _shopNameController,
            decoration: InputDecoration(
              fillColor: Color(0xffF2F2F2),
              filled: true,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 18,
              ),
              hintText: "Shop Name",
              hintStyle: TextStyle(
                  fontFamily: "GoldplayBold",
                  fontSize: 16,
                  color: Color(0xFFBDBDBD),
                  fontWeight: FontWeight.w500),
              alignLabelWithHint: true,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    30.0,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  handleGallery() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        file = File(pickedImage.path);
      });
      // Navigator.pop(context);
    }
  }

  handleCamera() async {
    // Navigator.pop(context);
    final pickedImage = await picker.getImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    if (pickedImage != null) {
      setState(() {
        file = File(pickedImage.path);
      });
      //  Navigator.pop(context);
    }
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Upload Picture"),
            children: [
              SimpleDialogOption(
                child: Text("Camera"),
                onPressed: () {
                  handleCamera();
                },
              ),
              SimpleDialogOption(
                child: Text("Gallery"),
                onPressed: () {
                  handleGallery();
                },
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Widget photoBox() {
    return GestureDetector(
      onTap: () {
        selectImage(context);
      },
      child: Container(
        width: 180.0,
        height: 170.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: kTealColor),
        ),
        child: IconButton(
          onPressed: () {
            selectImage(context);
          },
          icon: Icon(
            Icons.add,
            color: kTealColor,
            size: 50,
          ),
        ),
      ),
    );
  }

  Widget photoBoxWithPic() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 180.0,
        height: 170.0,
        decoration: BoxDecoration(
          image: DecorationImage(fit: BoxFit.cover, image: FileImage(file)),
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: kTealColor),
        ),
        child: IconButton(
          onPressed: () {},
          icon: file == null
              ? Icon(
                  Icons.add,
                  color: kTealColor,
                  size: 50,
                )
              : Icon(null),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Basic Information",
                  style: TextStyle(
                      fontFamily: "Goldplay",
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                file == null ? photoBox() : photoBoxWithPic(),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            buildShopName(),
            SizedBox(
              height: 25,
            ),
            Row(
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
                      minLines: 1,
                      maxLines: 10,
                      textInputAction: TextInputAction.newline,
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
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Operating Hours",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Goldplay",
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                )
              ],
            ),
            SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 60,
                    width: 350,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * .33,
                          child: Text(
                            "Opening",
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                fontFamily: "GoldplayBold",
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.50,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: FlatButton(
                                onPressed: () {
                                  DatePicker.showTime12hPicker(
                                    context,
                                    showTitleActions: true,
                                    onConfirm: (date) {
                                      setState(() {
                                        _opening = date;
                                        openingHour = DateFormat.Hms().format(
                                            date); //date.toIso8601String();
                                      });
                                    },
                                    currentTime: _opening,
                                  );
                                },
                                color: Color(0xffF2F2F2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 350,
                                      color: Color(0xffF2F2F2),
                                      child: Text(
                                          DateFormat.Hms().format(_opening)),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down_sharp,
                                      color: kTealColor,
                                      size: 35,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 60,
                    width: 350,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * .33,
                          child: Text(
                            "Closing",
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                fontFamily: "GoldplayBold",
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.50,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: FlatButton(
                                onPressed: () {
                                  DatePicker.showTime12hPicker(
                                    context,
                                    showTitleActions: true,
                                    onConfirm: (date) {
                                      setState(() {
                                        closingHour =
                                            DateFormat.Hms().format(_date);
                                        _closing = date;
                                      });
                                    },
                                    currentTime: _closing,
                                  );
                                },
                                color: Color(0xffF2F2F2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 350,
                                      color: Color(0xffF2F2F2),
                                      child: Text(
                                          DateFormat.Hms().format(_closing)),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down_sharp,
                                      color: kTealColor,
                                      size: 35,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 80,
                  width: 300,
                  child: ListTile(
                    title: Text(
                      "Set custom operating hours",
                      softWrap: true,
                      style: TextStyle(
                          fontFamily: "GoldplayBold",
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    leading: Checkbox(
                      activeColor: Colors.black,
                      value: _setOperatingHours,
                      onChanged: (value) {
                        setState(() {
                          _setOperatingHours = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(child: buildDaysOfWeek()),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            RoundedButton(
              label: "SUBMIT",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: "GoldplayBold",
              onPressed: () {
                createStore();
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            // Row(children: [],)
          ],
        ),
      ),
    );
  }

  
  Map<String, Days> customHours = Map();

  Widget buildDaysOfWeek() {
    DateTime _openingCustom = DateTime.now();
    DateTime _closingCustom = DateTime.now();

    List<String> daysOfWeek = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    List<Widget> condensedOperatingHours = [];
    CurrentUser _user = Provider.of<CurrentUser>(context, listen: false);

    for (String day in daysOfWeek) {
      condensedOperatingHours.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: CondensedOperatingHours(
                day: day,
                onChanged: (value) {
                  setState(() {
                    _openingCustom = value;
                    openingCustomHour = DateFormat.Hms().format(_openingCustom);
                    customHours[day] = Days();
                    customHours[day].opening = openingCustomHour;
                  });
                },
                onCustom: (value) {
                  setState(() {
                    _closingCustom = value;
                    closingCustomHour = DateFormat.Hms().format(_closingCustom);
                    
                    customHours[day].closing = closingCustomHour;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      children: condensedOperatingHours,
    );
  }
}

class Days {
  String opening;
  String closing;
  Days({this.opening, this.closing});

  // factory Days.fromJson(Map<String, dynamic> parsedJson){
  //   return Days(opening: parsedJson['opening'], closing: parsedJson['closing']);
  // }

  Map<String, dynamic> toMap() {
    return {
      'opening': opening,
      'closing': closing,
    };
  }

  factory Days.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Days(opening: map['opening'], closing: map['closing']);
  }

  String toJson() => json.encode(toMap());

  factory Days.fromJson(String source) => Days.fromMap(json.decode(source));
}
