import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../widgets/inputs/search_text_field.dart';
import '../chat/components/chat_avatar.dart';
import 'components/shop_header.dart';
import 'components/shop_product_field.dart';

class UserShop extends StatefulWidget {
  static const String routeName = "/profile/shop";
  const UserShop({Key? key}) : super(key: key);

  @override
  _UserShopState createState() => _UserShopState();
}

class _UserShopState extends State<UserShop> {
  Widget _buildBanner() {
    final user = context.read<Auth>().user!;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 5.0.w),
      child: ListTile(
        leading: ChatAvatar(
          displayName: user.displayName,
          displayPhoto: user.profilePhoto,
        ),
        title: Text(
          user.displayName!,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14.0.sp,
          ),
        ),
        trailing: Text(
          "No reviews yet",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ShopHeader(),
            _buildBanner(),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SearchTextField(enabled: false),
                    Center(
                      child: ShopProductField(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
