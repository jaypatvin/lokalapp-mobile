import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

import '../../../providers/post_requests/shop_body.dart';
import '../../../routers/app_router.dart';
import '../../../routers/profile/props/shop_schedule.props.dart';
import '../../../utils/media_utility.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/inputs/input_description_field.dart';
import '../../../widgets/inputs/input_name_field.dart';
import '../../../widgets/photo_box.dart';
import 'shop_schedule.dart';

class AddShop extends StatefulWidget {
  static const routeName = '/profile/addShop';
  @override
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  File? shopPhoto;

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardBarColor: Colors.grey.shade200,
      actions: [
        KeyboardActionsItem(
          focusNode: _nameFocusNode,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(),
                child: Text(
                  'Done',
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
                  'Done',
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
        titleText: 'Add Shop',
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: KeyboardActions(
        config: _buildConfig(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: height * 0.02,
            ),
            GestureDetector(
              onTap: () async {
                final photo =
                    await Provider.of<MediaUtility>(context, listen: false)
                        .showMediaDialog(context);
                setState(() {
                  shopPhoto = photo;
                });
              },
              child: PhotoBox(
                imageSource: PhotoBoxImageSource(file: shopPhoto),
                shape: BoxShape.circle,
                width: 140.w,
                height: 140.w,
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: InputNameField(
                hintText: 'Shop Name',
                focusNode: _nameFocusNode,
                onChanged: (value) =>
                    context.read<ShopBody>().update(name: value),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: InputDescriptionField(
                hintText: 'Shop Description',
                focusNode: _descriptionFocusNode,
                onChanged: (value) {
                  context.read<ShopBody>().update(description: value);
                },
              ),
            ),
            SizedBox(height: 20.0.h),
            Consumer<ShopBody>(
              builder: (context, shop, child) {
                final bool isNotEmpty = (shop.name?.isNotEmpty ?? false) &&
                    (shop.description?.isNotEmpty ?? false);
                return SizedBox(
                  width: width * 0.8,
                  child: AppButton.filled(
                    text: 'Set Shop Schedule',
                    onPressed: isNotEmpty
                        ? () => context.read<AppRouter>().navigateTo(
                              AppRoute.profile,
                              ShopSchedule.routeName,
                              arguments: ShopScheduleProps(shopPhoto),
                            )
                        : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
