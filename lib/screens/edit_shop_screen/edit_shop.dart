import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_loader/screen_loader.dart';

import '../../providers/post_requests/operating_hours_body.dart';
import '../../providers/post_requests/shop_body.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../services/local_image_service.dart';
import '../../utils/themes.dart';
import '../../utils/utility.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/input_description.dart';
import '../../widgets/input_name.dart';
import '../../widgets/photo_box.dart';
import '../../widgets/rounded_button.dart';
import '../add_shop_screens/shop_schedule.dart';

class EditShop extends StatefulWidget {
  final bool isEdit;
  EditShop({this.isEdit});
  @override
  _EditShopState createState() => _EditShopState();
}

class _EditShopState extends State<EditShop> with ScreenLoader {
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController shopDescController = TextEditingController();
  File shopPhoto;
  File shopCoverPhoto;
  bool toggleValue = false;
  bool animating = false;
  bool editedShopSchedule = false;

  @override
  initState() {
    super.initState();

    var user = Provider.of<CurrentUser>(context, listen: false);
    var shop =
        Provider.of<Shops>(context, listen: false).findByUser(user.id).first;
    shopNameController.text = shop.name;
    shopDescController.text = shop.description;

    Provider.of<ShopBody>(context, listen: false)
      ..clear()
      ..update(
        name: shop.name,
        description: shop.description,
        coverPhoto: shop.coverPhoto,
        profilePhoto: shop.profilePhoto,
      );

    Provider.of<OperatingHoursBody>(context, listen: false)..clear();

    toggleValue = shop.status == "enabled";
  }

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
      animating = true;
    });
    var status = toggleValue ? "enabled" : "disabled";
    Provider.of<ShopBody>(context, listen: false).update(status: status);
  }

  updateShop() async {
    var shops = Provider.of<Shops>(context, listen: false);
    var shopBody = Provider.of<ShopBody>(context, listen: false);
    var user = Provider.of<CurrentUser>(context, listen: false);
    var shop = shops.findByUser(user.id).first;
    var imageService = Provider.of<LocalImageService>(context, listen: false);

    var shopPhotoUrl = shopBody.profilePhoto;
    if (shopPhoto != null) {
      try {
        shopPhotoUrl = await imageService.uploadImage(
          file: shopPhoto,
          name: "shop-photo",
        );
      } catch (e) {
        shopPhotoUrl = shopBody.profilePhoto;
      }
    }

    var shopCoverPhotoUrl = shopBody.coverPhoto;
    if (shopCoverPhoto != null) {
      try {
        shopCoverPhotoUrl = await imageService.uploadImage(
          file: shopCoverPhoto,
          name: "shop-cover-photo",
        );
      } catch (e) {
        shopCoverPhotoUrl = shopBody.coverPhoto;
      }
    }

    shopBody.update(
      name: shopNameController.text,
      description: shopDescController.text,
      profilePhoto: shopPhotoUrl,
      coverPhoto: shopCoverPhotoUrl,
      status: toggleValue ? "enabled" : "disabled",
    );

    return await shops.update(
      id: shop.id,
      data: shopBody.data,
    );
  }

  Widget buildToggleButton({double height = 40.0, double width = 100.0}) {
    return InkWell(
      onTap: toggleButton,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 1),
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: toggleValue
              ? Colors.greenAccent[100]
              : Colors.grey.withOpacity(0.5),
        ),
        child: Stack(
          children: [
            Visibility(
              visible: !animating,
              child: Padding(
                padding: toggleValue
                    ? EdgeInsets.only(left: width * 0.15)
                    : EdgeInsets.only(right: width * 0.15),
                child: Align(
                  alignment: toggleValue
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Text(
                    toggleValue ? "Open" : "Closed",
                    style: kTextStyle,
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              onEnd: () => setState(() => animating = false),
              duration: Duration(milliseconds: 500),
              curve: Curves.linear,
              top: 3.0,
              left: toggleValue ? width * 0.6 : 0.0,
              right: toggleValue ? 0.0 : width * 0.6,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: toggleValue
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: height * 0.8,
                        key: UniqueKey(),
                      )
                    : Icon(
                        Icons.remove_circle_outline,
                        color: Colors.grey,
                        size: height * 0.8,
                        key: UniqueKey(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPhotoSection(double height, double width) {
    var shopBody = Provider.of<ShopBody>(context, listen: false);
    return Container(
      height: height * 0.25,
      child: Stack(
        children: [
          Center(
            child: PhotoBox(
              file: shopCoverPhoto,
              shape: BoxShape.rectangle,
              width: width,
              height: height * 0.25,
              url: shopBody.coverPhoto,
              displayBorder: false,
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                var photo =
                    await Provider.of<MediaUtility>(context, listen: false)
                        .showMediaDialog(context);
                setState(() {
                  shopPhoto = photo;
                });
              },
              child: PhotoBox(
                file: shopPhoto,
                shape: BoxShape.circle,
                url: shopBody.profilePhoto,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _updateShopSchedule() async {
    var operatingHoursBody =
        Provider.of<OperatingHoursBody>(context, listen: false);

    var user = Provider.of<CurrentUser>(context, listen: false);
    var shops = Provider.of<Shops>(context, listen: false);
    var userShop = shops.findByUser(user.id).first;
    return await shops.setOperatingHours(
      id: userShop.id,
      data: operatingHoursBody.data,
    );
  }

  @override
  Widget screen(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double padding = height * 0.05;
    return Scaffold(
      appBar: CustomAppBar(
        titleText: "Edit Shop",
        onPressedLeading: () {
          Navigator.pop(context);
        },
        bottom: PreferredSize(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            height: height * 0.06,
            color: Color(0XFFF1FAFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Shop Status",
                  style: kTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                buildToggleButton(
                  height: height * 0.04,
                  width: width * 0.22,
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(height * 0.06),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.fromLTRB(0.0, padding, 0.0, 0.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Basic Information",
                style: kTextStyle.copyWith(fontSize: 24.0),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              buildPhotoSection(height, width),
              SizedBox(
                height: height * 0.02,
              ),
              InkWell(
                  child: Text(
                    "+ Edit Cover Photo",
                    style: kTextStyle.copyWith(
                      decoration: TextDecoration.underline,
                      color: kTealColor,
                    ),
                  ),
                  onTap: () async {
                    var photo =
                        await Provider.of<MediaUtility>(context, listen: false)
                            .showMediaDialog(context);
                    setState(() {
                      shopCoverPhoto = photo;
                    });
                  }),
              SizedBox(
                height: height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: InputName(
                  controller: shopNameController,
                  hintText: "Shop Name",
                  onChanged: (value) {
                    Provider.of<ShopBody>(context, listen: false)
                        .update(name: value);
                  },
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: InputDescription(
                  controller: shopDescController,
                  hintText: "Shop Description",
                  onChanged: (value) {
                    Provider.of<ShopBody>(context, listen: false)
                        .update(description: value);
                  },
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                width: width * 0.8,
                height: height * 0.06,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ShopSchedule(
                          shopPhoto,
                          forEditing: true,
                          onShopEdit: () {
                            setState(() {
                              editedShopSchedule = true;
                            });
                          },
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    primary: kTealColor,
                    textStyle: kTextStyle.copyWith(
                      color: kTealColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: kTealColor),
                    ),
                  ),
                  child: Text("Change Shop Schedule"),
                ),
              ),
              SizedBox(height: height * 0.01),
              RoundedButton(
                label: "Apply Changes",
                height: 10,
                minWidth: width * 0.6,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: "Goldplay",
                fontColor: Colors.white,
                onPressed: () async {
                  try {
                    await performFuture<void>(() async {
                      bool success = await updateShop();
                      if (!success) throw "Update shop error";

                      if (editedShopSchedule) {
                        success = await _updateShopSchedule();
                        if (!success) throw "Update operating hours error";
                      }
                    });
                    Provider.of<Shops>(context, listen: false).fetch();
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
