import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/post_requests/shop_body.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../services/local_image_service.dart';
import '../../utils/themes.dart';
import '../../utils/utility.dart';
import '../../widgets/operating_hours.dart';
import '../../widgets/photo_box.dart';
import '../add_shop_screens/appbar_shop.dart';
import '../add_shop_screens/basic_information.dart';
import '../add_shop_screens/shopDescription.dart';
import '../add_shop_screens/shop_name.dart';
import 'operating_hours_shop.dart';
import 'set_custom_operating_hours.dart';
import 'shop_status.dart';

class EditShop extends StatefulWidget {
  final bool isEdit;
  EditShop({this.isEdit});
  @override
  _EditShopState createState() => _EditShopState();
}

class _EditShopState extends State<EditShop> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  //File file;
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
  File shopPhoto;

  Future updateShop() async {
    LocalImageService _imageService =
        Provider.of<LocalImageService>(context, listen: false);
    String mediaUrl = '';
    if (shopPhoto != null) {
      mediaUrl =
          await _imageService.uploadImage(file: shopPhoto, name: 'shop_photo');
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
    CurrentUser user = Provider.of<CurrentUser>(context, listen: false);
    var shops = Provider.of<Shops>(context, listen: false);
    var userShops =
        Provider.of<Shops>(context, listen: false).findByUser(user.id);
    var shopBody = Provider.of<ShopBody>(context, listen: false);

    if (isNameValid && isDescriptionValid) {
      try {
        shopBody.update(
          userId: user.id,
          name: _shopNameController.text,
          description: _shopDescriptionController.text,
          opening: openingHour,
          closing: closingHour,
          status: isSwitched.toString(),
          coverPhoto: mediaUrl,
        );

        bool success = await shops.update(
            id: userShops[0].id, authToken: user.idToken, data: shopBody.data);
        if (success) {
          SnackBar snackBar = SnackBar(
            content: Text("Shop Updated!"),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
          Navigator.pop(context);
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
                GestureDetector(
                  onTap: () async {
                    setState(() async {
                      this.shopPhoto = await Provider.of<MediaUtility>(context,
                              listen: false)
                          .showMediaDialog(context);
                    });
                  },
                  child: PhotoBox(file: shopPhoto, shape: BoxShape.circle),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            ShopName(
              shopController: _shopNameController,
              errorText: isNameValid ? null : 'Shop Name too short',
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
