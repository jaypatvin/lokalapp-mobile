import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/post_requests/shop_body.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../services/local_image_service.dart';
import '../../utils/utility.dart';
import '../../widgets/operating_hours.dart';
import '../../widgets/photo_box.dart';
import '../../widgets/rounded_button.dart';
import '../edit_shop_screen/operating_hours_shop.dart';
import '../edit_shop_screen/set_custom_operating_hours.dart';
import 'appbar_shop.dart';
import 'basic_information.dart';
import 'components/condensed_operating_hours.dart';
import 'shopDescription.dart';
import 'shop_name.dart';

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
  TimeOfDay _date = TimeOfDay.now();
  bool _setOperatingHours = false;
  bool isUploading = false;
  String shopPhotoId = Uuid().v4();
  final picker = ImagePicker();
  String openingHour;
  String closingHour;
  String openingCustomHour;
  String closingCustomHour;
  String description;
  DateTime _opening = DateTime.now();
  DateTime _closing = DateTime.now();
  String shopName;
  File shopPhoto;

  Future createStore() async {
    setState(() {
      isUploading = true;
    });
    String mediaUrl = "";
    if (shopPhoto != null) {
      mediaUrl = await Provider.of<LocalImageService>(context, listen: false)
          .uploadImage(file: shopPhoto, name: 'shop_photo');
    }
    CurrentUser user = Provider.of<CurrentUser>(context, listen: false);
    ShopBody shopBody = Provider.of<ShopBody>(context, listen: false);
    Shops shops = Provider.of<Shops>(context, listen: false);
    try {
      shopBody.update(
        userId: user.id,
        communityId: user.communityId,
        name: shopName,
        description: description,
        profilePhoto: mediaUrl,
        coverPhoto: "",
        isClosed: false,
        opening: openingHour,
        closing: closingHour,
        useCustomHours: _setOperatingHours,
        customHours:
            customHours.map((key, value) => MapEntry(key, value.toString())),
      );
      bool success = await shops.create(user.idToken, shopBody.data);
      if (success) {
        shops.fetch(user.idToken);
        Navigator.pop(context);
      }
    } on Exception catch (_) {
      print(_);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false, // added as above is deprecated
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 80),
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
                GestureDetector(
                  onTap: () async {
                    var photo =
                        await Provider.of<MediaUtility>(context, listen: false)
                            .showMediaDialog(context);
                    setState(() {
                      shopPhoto = photo;
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
                                    openingHour =
                                        DateFormat("h:mm a").format(date);
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
                                    closingHour =
                                        DateFormat("h:mm a").format(date);
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
              value: _setOperatingHours,
              onChanged: (value) {
                setState(() {
                  _setOperatingHours = value;
                });
              },
            ),
            SizedBox(height: 10),
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
                  onChangedOpening: (value) {
                    setState(() {
                      _openingCustom = value;
                      openingCustomHour =
                          DateFormat("h:mm a").format(_openingCustom);
                      customHours[day] = Days();
                      customHours[day].opening = openingCustomHour;
                    });
                  },
                  onChangedClosing: (value) {
                    setState(() {
                      _closingCustom = value;
                      closingCustomHour =
                          DateFormat("h:mm a").format(_closingCustom);

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
