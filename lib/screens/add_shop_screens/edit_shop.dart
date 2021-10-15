import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../widgets/screen_loader.dart';

import '../../providers/post_requests/operating_hours_body.dart';
import '../../providers/post_requests/shop_body.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../services/local_image_service.dart';
import '../../utils/themes.dart';
import '../../utils/utility.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/input_description.dart';
import '../../widgets/input_name.dart';
import '../../widgets/photo_box.dart';
import 'shop_schedule.dart';

class EditShop extends StatefulWidget {
  static const routeName = "/profile/shop/edit";
  final bool? isEdit;
  EditShop({this.isEdit});
  @override
  _EditShopState createState() => _EditShopState();
}

class _EditShopState extends State<EditShop> with ScreenLoader {
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController shopDescController = TextEditingController();
  File? shopPhoto;
  File? shopCoverPhoto;
  bool toggleValue = false;
  bool animating = false;
  bool editedShopSchedule = false;

  @override
  initState() {
    super.initState();

    final user = context.read<CurrentUser>();
    final shop = context.read<Shops>().findByUser(user.id).first;
    shopNameController.text = shop.name!;
    shopDescController.text = shop.description!;

    context.read<ShopBody>()
      ..clear()
      ..update(
        name: shop.name,
        description: shop.description,
        coverPhoto: shop.coverPhoto,
        profilePhoto: shop.profilePhoto,
      );

    context.read<OperatingHoursBody>().clear();

    toggleValue = shop.status == "enabled";
  }

  void _toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
      animating = true;
    });
    final status = toggleValue ? "enabled" : "disabled";
    context.read<ShopBody>().update(status: status);
  }

  Future<bool> _updateShop() async {
    final shops = context.read<Shops>();
    final shopBody = context.read<ShopBody>();
    final user = context.read<CurrentUser>();
    final shop = shops.findByUser(user.id).first;
    final imageService = context.read<LocalImageService>();

    var shopPhotoUrl = shopBody.profilePhoto;
    if (shopPhoto != null) {
      try {
        shopPhotoUrl = await imageService.uploadImage(
          file: shopPhoto!,
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
          file: shopCoverPhoto!,
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

  InkWell _buildToggleButton({double height = 40.0, double width = 100.0}) {
    return InkWell(
      onTap: _toggleButton,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 1),
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0.r),
          color: toggleValue ? kTealColor : kPinkColor,
        ),
        child: Stack(
          children: [
            Visibility(
              visible: !animating,
              child: Padding(
                padding: toggleValue
                    ? EdgeInsets.only(left: width * 0.10)
                    : EdgeInsets.only(right: width * 0.10),
                child: Align(
                  alignment: toggleValue
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Text(
                    toggleValue ? "Open" : "Closed",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              onEnd: () => setState(() => animating = false),
              duration: Duration(milliseconds: 300),
              curve: Curves.linear,
              // top: height * 0.1,
              height: height,
              left: toggleValue ? width * 0.6 : 0.0,
              right: toggleValue ? 0.0 : width * 0.6,
              child: Icon(
                Icons.circle,
                color: Colors.white,
                size: height * 0.8,
                key: UniqueKey(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onShopPhotoPick() async {
    final photo = await context.read<MediaUtility>().showMediaDialog(context);
    setState(() {
      shopPhoto = photo;
    });
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
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: height * 0.02,
            ),
            color: Color(0XFFF1FAFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Shop Status",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                _buildToggleButton(
                  height: 40.0.h,
                  width: 90.0.w,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Basic Information",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  _ShopPhotoSection(
                    shopCoverPhoto: this.shopCoverPhoto,
                    onShopPhotoPick: _onShopPhotoPick,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  InkWell(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          MdiIcons.squareEditOutline,
                          size: 18.0.sp,
                          color: kTealColor,
                        ),
                        Text(
                          "Edit Cover Photo",
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                decoration: TextDecoration.underline,
                                color: kTealColor,
                              ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      final photo = await context
                          .read<MediaUtility>()
                          .showMediaDialog(context);
                      setState(() => shopCoverPhoto = photo);
                    },
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: InputName(
                      controller: shopNameController,
                      hintText: "Shop Name",
                      onChanged: (value) =>
                          context.read<ShopBody>().update(name: value),
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
                    child: AppButton(
                      "Change Shop Schedule",
                      kTealColor,
                      false,
                      () {
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
                                Navigator.popUntil(
                                  context,
                                  ModalRoute.withName(
                                    EditShop.routeName,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: width * 0.8,
                    child: AppButton(
                      "Edit Payment Options",
                      kTealColor,
                      false,
                      () {},
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  SizedBox(
                    width: width * 0.6,
                    child: AppButton(
                      "Apply Changes",
                      kTealColor,
                      true,
                      () async {
                        try {
                          await performFuture<void>(() async {
                            bool success = await _updateShop();
                            if (!success) throw "Update shop error";

                            if (editedShopSchedule) {
                              success = await _updateShopSchedule();
                              if (!success)
                                throw "Update operating hours error";
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopPhotoSection extends StatelessWidget {
  final File? shopCoverPhoto;
  final File? shopPhoto;
  final void Function()? onShopPhotoPick;
  const _ShopPhotoSection({
    Key? key,
    this.shopCoverPhoto,
    this.shopPhoto,
    this.onShopPhotoPick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shopBody = context.read<ShopBody>();
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.25,
      child: Stack(
        children: [
          Center(
            child: PhotoBox(
              file: shopCoverPhoto,
              shape: BoxShape.rectangle,
              width: double.infinity,
              height: height * 0.25,
              url: shopBody.coverPhoto,
              displayBorder: false,
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: this.onShopPhotoPick,
              child: Stack(
                children: [
                  PhotoBox(
                    width: 140.0,
                    height: 140.0,
                    file: this.shopPhoto,
                    shape: BoxShape.circle,
                    url: shopBody.profilePhoto,
                  ),
                  Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: new BoxDecoration(
                      color: Colors.black.withOpacity(0.30),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            MdiIcons.squareEditOutline,
                            size: 18.0.sp,
                            color: Colors.white,
                          ),
                          Text(
                            "Edit Photo",
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
