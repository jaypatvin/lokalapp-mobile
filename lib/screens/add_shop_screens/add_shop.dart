import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

import '../../providers/post_requests/shop_body.dart';
import '../../utils/constants/themes.dart';
import '../../utils/utility.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/input_description.dart';
import '../../widgets/input_name.dart';
import '../../widgets/photo_box.dart';
import 'shop_schedule.dart';

class AddShop extends StatefulWidget {
  @override
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  File? shopPhoto;

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey.shade200,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _nameFocusNode,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(),
                child: Text(
                  "Done",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black,
                      ),
                ),
              );
            },
          ],
        ),
        KeyboardActionsItem(
          focusNode: _descriptionFocusNode,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(),
                child: Text(
                  "Done",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black,
                      ),
                ),
              );
            },
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final padding = height * 0.05;
    return Scaffold(
      appBar: CustomAppBar(
        titleText: "Add Shop",
        onPressedLeading: () {
          Navigator.pop(context);
        },
      ),
      body: KeyboardActions(
        config: _buildConfig(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
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
              height: height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: InputName(
                hintText: "Shop Name",
                focusNode: this._nameFocusNode,
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
                hintText: "Shop Description",
                focusNode: this._descriptionFocusNode,
                onChanged: (value) {
                  context.read<ShopBody>().update(description: value);
                },
              ),
            ),
            SizedBox(height: 10.0.h),
            Consumer<ShopBody>(builder: (context, shop, child) {
              bool isNotEmpty =
                  shop.name!.isNotEmpty && shop.description!.isNotEmpty;
              return SizedBox(
                width: width * 0.8,
                child: AppButton(
                  "Set Shop Schedule",
                  kTealColor,
                  true,
                  isNotEmpty
                      ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => ShopSchedule(
                                this.shopPhoto,
                              ),
                            ),
                          )
                      : null,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
