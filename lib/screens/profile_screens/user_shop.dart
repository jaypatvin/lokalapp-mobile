import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lokalapp/screens/chat/components/chat_avatar.dart';
import 'package:lokalapp/screens/profile_screens/components/shop_header.dart';
import 'package:lokalapp/screens/profile_screens/components/shop_product_field.dart';
import 'package:lokalapp/widgets/search_text_field.dart';
import 'package:persistent_bottom_nav_bar/models/nested_will_pop_scope.dart';
import 'package:provider/provider.dart';

import '../../providers/activities.dart';
import '../../providers/user.dart';
import '../../utils/themes.dart';
import '../home/timeline.dart';
import 'components/my_profile_list.dart';
import 'components/profile_header.dart';
import 'components/user_shop_banner.dart';

class UserShop extends StatefulWidget {
  const UserShop({Key key}) : super(key: key);

  @override
  _UserShopState createState() => _UserShopState();
}

class _UserShopState extends State<UserShop> {
  Widget _buildBanner() {
    final user = context.read<CurrentUser>();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 5.0.w),
      child: ListTile(
        leading: ChatAvatar(
          displayName: user.displayName,
          displayPhoto: user.profilePhoto,
        ),
        title: Text(
          user.displayName,
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
      backgroundColor: kInviteScreenColor,
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
