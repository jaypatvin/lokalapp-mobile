import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lokalapp/screens/add_shop_screens/appbar_shop.dart';
import 'package:lokalapp/screens/add_shop_screens/basic_information.dart';
import 'package:lokalapp/screens/add_shop_screens/shop_name.dart';
import 'package:lokalapp/screens/edit_shop_screen/operating_hours_shop.dart';
import 'package:lokalapp/screens/edit_shop_screen/set_custom_operating_hours.dart';
import 'package:lokalapp/screens/profileScreens/profile_shop.dart';
import 'package:lokalapp/services/database.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:lokalapp/widgets/condensed_operating_hours.dart';
import 'package:lokalapp/widgets/operating_hours.dart';
import 'package:lokalapp/widgets/rounded_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../utils/themes.dart';
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
  String description;
  DateTime _opening = DateTime.now();
  DateTime _closing = DateTime.now();
  String shopName;
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
    try {
      _user.postShop.userId = _user.getCurrentUser.userUids.first;
      _user.postShop.communityId = _user.getCurrentUser.communityId;
      _user.postShop.name = shopName;
      _user.postShop.description = description;
      _user.postShop.profilePhoto = mediaUrl;
      _user.postShop.coverPhoto = "";
      _user.postShop.isClosed = false;
      _user.postShop.opening = openingHour;
      _user.postShop.closing = closingHour;
      _user.postShop.useCustomHours = _setOperatingHours;
      _user.postShop.customHours =
          customHours.map((key, value) => MapEntry(key, value.toString()));
      _user.postShop.status = "enabled";
      bool success = await _user.createShop();
      if (success) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileShop(hasStore: true)));
      }
    } on Exception catch (_) {
      print(_);
    }
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
        width: 150.0,
        height: 140.0,
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
        width: 150.0,
        height: 140.0,
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
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 83),
          child: Center(
              child: AppbarShop(
            isEdit: false,
            shopName: "Add Shop",
          ))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            BasicInformation(),
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
            ShopName(
              onChanged: (value) {
                setState(() {
                  shopName = value;
                });
              },
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShopDescription(
                  onChanged: (value) {
                    description = value;
                  },
                )
              ],
            ),
            SizedBox(
              height: 40,
            ),
            OperatingHoursShop(),
            SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 50,
                    width: 330,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.30,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: OperatingHours(
                                state: "Opening",
                                onChanged: (date) {
                                  setState(() {
                                    _opening = date;
                                    openingHour = DateFormat.Hms()
                                        .format(date); //date.toIso8601String();
                                  });
                                },
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
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 50,
                    width: 330,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.50,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: OperatingHours(
                                state: "Closing",
                                onChanged: (date) {
                                  setState(() {
                                    _closing = date;
                                    closingHour = DateFormat.Hms()
                                        .format(date); //date.toIso8601String();
                                  });
                                },
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
            SetCustomoperatingHours(
              value: _setOperatingHours,
              onChanged: (value) {
                setState(() {
                  _setOperatingHours = value;
                });
              },
            ),

            Container(
                child: _setOperatingHours ? buildDaysOfWeek() : Container()),
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
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    for (String day in daysOfWeek) {
      condensedOperatingHours.add(
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CondensedOperatingHours(
                  day: day,
                  onChanged: (value) {
                    setState(() {
                      _openingCustom = value;
                      openingCustomHour =
                          DateFormat.Hms().format(_openingCustom);
                      customHours[day] = Days();
                      customHours[day].opening = openingCustomHour;
                    });
                  },
                  onCustom: (value) {
                    setState(() {
                      _closingCustom = value;
                      closingCustomHour =
                          DateFormat.Hms().format(_closingCustom);
                      customHours[day].closing = closingCustomHour;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Wrap(
      spacing: 5.0,
      runSpacing: 2.0,
      direction: Axis.vertical,
      children: condensedOperatingHours,
    );
  }
}

class Days {
  String opening;
  String closing;
  Days({this.opening, this.closing});

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
