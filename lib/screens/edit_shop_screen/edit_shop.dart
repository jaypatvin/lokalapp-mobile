import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lokalapp/models/user_shop_post.dart';
import 'package:lokalapp/screens/add_shop_screens/appbar_shop.dart';
import 'package:lokalapp/screens/add_shop_screens/basic_information.dart';
import 'package:lokalapp/screens/add_shop_screens/shopDescription.dart';
import 'package:lokalapp/screens/add_shop_screens/shop_name.dart';
import 'package:lokalapp/screens/edit_shop_screen/operating_hours_shop.dart';
import 'package:lokalapp/screens/edit_shop_screen/set_custom_operating_hours.dart';
import 'package:lokalapp/screens/edit_shop_screen/shop_status.dart';
import 'package:lokalapp/services/database.dart';
import 'package:lokalapp/services/local_image_service.dart';
import 'package:lokalapp/services/lokal_api_service.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/operating_hours.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;

class EditShop extends StatefulWidget {
  final bool isEdit;
  EditShop({this.isEdit});
  @override
  _EditShopState createState() => _EditShopState();
}

class _EditShopState extends State<EditShop> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  File file;
  String profilePhotoId = Uuid().v4();
  final picker = ImagePicker();
  bool _setOperatingHours = false;
  bool isLoading = false;
  String editShopName;
  bool isSwitched = false;
  String shopDescription;
  DateTime _opening = DateTime.now();
  DateTime _closing = DateTime.now();
  String openingHour;
  String closingHour;
  TextEditingController _shopNameController = TextEditingController();
  TextEditingController _shopDescriptionController = TextEditingController();
  // bool isUploading = true;
  bool isNameValid = true;
  bool isDescriptionValid = true;
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

  // Future<Us> userShop;
  @override
  initState() {
    super.initState();
    // getUser();
  }

  getUser() async {
    CurrentUser _user = Provider.of(context, listen: false);
    var user_Id = await Database().getUserDocId(_user.userUids.first);
    // UserShopPost shop = UserShopPost();
    if (user_Id != null) {
      try {
        bool success = await _user.getShop(user_Id);
        _shopNameController.text = _user.postShop.name;
        _shopDescriptionController.text = _user.postShop.description;

        if (success) {
          print('success');
        }
      } on Exception catch (_) {
        print(_);
      }
    }
  }

  Future updateShop() async {
    LocalImageService _imageService =
        Provider.of<LocalImageService>(context, listen: false);
    if (_imageService.fileExists) {
      await _imageService.uploadImage();
    }
    setState(() {
      _shopNameController.text.trim().length < 3 ||
              _shopNameController.text.isEmpty
          ? isNameValid = false
          : isNameValid = true;
      _shopDescriptionController.text.trim().length > 100
          ? isDescriptionValid = false
          : isDescriptionValid = true;
    });
    CurrentUser _user = Provider.of<CurrentUser>(context, listen: false);

    if (isNameValid && isDescriptionValid) {
      final String userId = await Database().getUserDocId(_user.userUids.first);

      try {
        _user.postShop.name = _shopDescriptionController.text;
        _user.postShop.description = _shopDescriptionController.text;

        bool success = await _user.updateShop(userId);
        if (success) {
          SnackBar snackBar = SnackBar(
            content: Text("Shop Updated!"),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      } on Exception catch (_) {
        print(_);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 83),
          child: Center(
              child: AppbarShop(
            isEdit: true,
            shopName: "Edit Shop",
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
              shopController: _shopNameController,
              errorText: isNameValid ? null : 'Shop Name too short',
              // onChanged: (value) {
              //   setState(() {
              //     editShopName = value;
              //   });
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShopDescription(
                  hintText: "Description",
                  descriptionController: _shopDescriptionController,
                  errorText:
                      isDescriptionValid ? null : 'Shop Description too long.',
                  // onChanged: (value) {
                  //   shopDescription = value;
                  // },
                )
              ],
            ),
            SizedBox(
              height: 30,
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
                              width: 150,
                              height: 100,
                              child: OperatingHours(
                                state: "Opening Time",
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
                                state: "Closing Time",
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
                label: "Set Custom Operating Hours",
                onChanged: (value) {
                  setState(() {
                    _setOperatingHours = value;
                  });
                },
                value: _setOperatingHours),
            SizedBox(
              height: 20,
            ),
            ShopStatus(),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: ListView(children: [
                    ListTile(
                      leading: isSwitched ? Text("Active") : Text("Inactive"),
                      trailing: CupertinoSwitch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                  ]),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 40,
                  width: 120,
                  child: FlatButton(
                    // height: 50,
                    // minWidth: 100,
                    color: isSwitched ? Colors.white : kTealColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: kTealColor),
                    ),
                    textColor: isSwitched ? kTealColor : Colors.black,
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontFamily: "Goldplay",
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      updateShop();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
