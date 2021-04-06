import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../utils/themes.dart';
import 'profile_shop.dart';

class ProfileShopStickyStore extends StatefulWidget {
  final bool hasStore;
  ProfileShopStickyStore({this.hasStore});
  @override
  _ProfileShopStickyStoreState createState() => _ProfileShopStickyStoreState();
}

class _ProfileShopStickyStoreState extends State<ProfileShopStickyStore> {
  Widget buildShopStore(context) {
    return Container(
      height: 53,
      width: MediaQuery.of(context).size.width,
      child: ListView(shrinkWrap: true, children: [
        Container(
          child: Consumer2<CurrentUser, Shops>(
            builder: (context, user, shops, child) {
              var userShop = shops.findByUser(user.id).first;
              return ListTile(
                leading: CircleAvatar(
                    radius: 23,
                    // should refactor/simplify this
                    backgroundImage: userShop.profilePhoto != null &&
                            userShop.profilePhoto.isNotEmpty
                        ? NetworkImage(userShop.profilePhoto)
                        : null),
                title: Text(
                  userShop.name,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      "4.54",
                      style: TextStyle(color: Colors.amber, fontSize: 14),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: ProfileShop(),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: kTealColor,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildShopStore(context);
  }
}
