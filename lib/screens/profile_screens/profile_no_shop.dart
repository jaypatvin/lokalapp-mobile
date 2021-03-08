import 'package:flutter/material.dart';
import 'package:lokalapp/screens/add_shop_screens/add%20_shop_cart.dart';
import 'package:lokalapp/screens/profile_screens/profile_not_verified.dart';
import 'package:lokalapp/screens/profile_screens/profile_shop_sticky_store.dart';
import 'package:lokalapp/screens/timeline.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';
import '../add_shop_screens/add_shop.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

// import '../../widgets/rounded_button.dart';

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
    var shops = Provider.of<CurrentUser>(context, listen: false).userShops;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              shops.length > 0
                  ? ProfileShopStickyStore(
                      hasStore: true,
                    )
                  : buildAddShopButton()
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                    maxWidth: MediaQuery.of(context).size.width),
                child: Container(
                  color: Color(0XFFF1FAFF),
                  child: Timeline(),
                ),
              )
            ],
          )
        ],
      ),
    );
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
