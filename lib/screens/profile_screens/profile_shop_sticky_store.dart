import 'package:flutter/material.dart';
import 'package:lokalapp/screens/profile_screens/components/store_rating.dart';
import 'package:lokalapp/screens/profile_screens/profile_shop.dart';
import 'package:lokalapp/screens/profile_screens/profile_store_name.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ProfileShopStickyStore extends StatefulWidget {
  @override
  _ProfileShopStickyStoreState createState() => _ProfileShopStickyStoreState();
}

class _ProfileShopStickyStoreState extends State<ProfileShopStickyStore> {
  Widget buildShopStore(context) {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      // height: MediaQuery.of(context).size.height * 0.02,
      height: 53,
      width: MediaQuery.of(context).size.width,
      child: ListView(shrinkWrap: true, children: [
        Container(
          // padding: const EdgeInsets.only(bottom: 50),
          child: ListTile(
            leading: CircleAvatar(
              radius: 23,
              backgroundImage: NetworkImage(
                  "https://media.istockphoto.com/vectors/bakery-hand-written-lettering-logo-vector-id1166282839?b=1&k=6&m=1166282839&s=612x612&w=0&h=fOgckd0dFcbS3UWVbKAFmCwrc0ti9A56FB-J0GEp9LA="),
            ),
            title: Text(
              "Bakey Bakey",
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
