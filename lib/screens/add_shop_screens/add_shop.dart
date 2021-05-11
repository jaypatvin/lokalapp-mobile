import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/post_requests/shop_body.dart';
import '../../utils/themes.dart';
import '../../utils/utility.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/input_description.dart';
import '../../widgets/input_name.dart';
import '../../widgets/photo_box.dart';
import '../../widgets/rounded_button.dart';
import 'shop_schedule.dart';

class AddShop extends StatefulWidget {
  @override
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  File shopPhoto;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double padding = height * 0.05;
    return Scaffold(
      appBar: customAppBar(
        titleText: "Add Shop",
        onPressedLeading: () {
          Navigator.pop(context);
        },
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.fromLTRB(padding, padding, padding, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Basic Information",
              style: kTextStyle.copyWith(fontSize: 24.0),
            ),
            SizedBox(
              height: height * 0.05,
            ),
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
            SizedBox(
              height: height * 0.05,
            ),
            InputName(
              hintText: "Shop Name",
              onChanged: (value) {
                Provider.of<ShopBody>(context, listen: false)
                    .update(name: value);
              },
            ),
            SizedBox(
              height: height * 0.02,
            ),
            InputDescription(
              hintText: "Shop Description",
              onChanged: (value) {
                Provider.of<ShopBody>(context, listen: false)
                    .update(description: value);
              },
            ),
            Spacer(),
            Consumer<ShopBody>(builder: (context, shop, child) {
              bool isVisible =
                  shop.name.isNotEmpty && shop.description.isNotEmpty;
              return Visibility(
                visible: isVisible,
                child: RoundedButton(
                  label: "Set Shop Schedule",
                  height: 10,
                  minWidth: width * 0.6,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Goldplay",
                  fontColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ShopSchedule(this.shopPhoto);
                        },
                      ),
                    );
                  },
                ),
              );
            }),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
