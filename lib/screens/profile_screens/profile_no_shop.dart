import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../providers/pull_up_cart_state.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../utils/themes.dart';
import '../add_shop_screens/add%20_shop_cart.dart';
import '../add_shop_screens/add_shop.dart';
import '../user_timeline.dart';
import 'profile_shop_sticky_store.dart';

class ProfileNoShop extends StatefulWidget {
  @override
  _ProfileNoShopState createState() => _ProfileNoShopState();
}

class _ProfileNoShopState extends State<ProfileNoShop> {
  // bool hasStore;

  Row buildSampleCartButton() {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddShopCart()));
            },
            child: Text("Add Cart"))
      ],
    );
  }

  Widget buildNoShopText() {
    return Consumer2<CurrentUser, Shops>(builder: (context, user, shops, __) {
      return shops.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(padding: const EdgeInsets.all(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    shops.findByUser(user.id).length > 0
                        ? ProfileShopStickyStore(
                            hasStore: true,
                          )
                        : buildAddShopButton()
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    color: Color(0XFFF1FAFF),
                    child: UserTimeline(),
                  ),
                ),
                Consumer2<ShoppingCart, PullUpCartState>(
                    builder: (context, cart, cartState, _) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height *
                        (cart.items.length > 0 && cartState.isPanelVisible
                            ? 0.5
                            : 0.4),
                  );
                })
              ],
            );
    });
  }

  Container buildAddShopButton() {
    return Container(
      height: 43,
      width: 180,
      child: FlatButton(
        // height: 50,
        // minWidth: 100,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: kTealColor),
        ),
        textColor: kTealColor,
        child: Text(
          "+ ADD SHOP",
          style: TextStyle(
            fontFamily: "GoldplayBold",
            fontSize: 16,
            // fontWeight: FontWeight.w600
          ),
        ),
        onPressed: () {
          pushNewScreen(
            context,
            screen: AddShop(),
            withNavBar: true, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildNoShopText();
  }
}
