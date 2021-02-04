import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lokalapp/screens/addShopScreens/shopDescription.dart';
import 'package:lokalapp/screens/profileScreens/profile_shop.dart';
import 'package:lokalapp/services/database.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:lokalapp/widgets/rounded_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../utils/themes.dart';
import 'condensed_operating_hours.dart';
import 'package:image/image.dart' as Im;

class AddShop extends StatefulWidget {
  final Map<String, String> account;
  final dynamic description;
  final DateTime time;
  static String id = '/addShop';
  AddShop({Key key, this.account, this.description, this.time})
      : super(key: key);
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  //DateTime _date = DateTime.now();
  // final TextEditingController _statusController = TextEditingController();
  // final TextEditingController _coverPhotoController = TextEditingController();

  // final TextEditingController _profilePhotoController = TextEditingController();
  // final TextEditingController _isClosedController = TextEditingController();
  bool _setOperatingHours = false;
  File file;
  bool isUploading = false;
  String profilePhotoId = Uuid().v4();
  final picker = ImagePicker();
  String openingHour;
  String closingHour;
  dynamic openingCustomHour;
  dynamic closingCustomHour;
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
    _user.postShop.customHours = {
      'opening': openingCustomHour,
      'closing': closingCustomHour,
    };
    _user.postShop.status = "enabled";
    _user.postShop.communityId = _user.getCurrentUser.userUids.first;
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
            ShopDescription(
              descriptionController: this._descriptionController,
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
                                  //mainAxisSize: MainAxisSize.max,
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
                                            DateFormat.Hms().format(date);
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

  Widget buildDaysOfWeek() {
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
                    openingCustomHour = value;
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
