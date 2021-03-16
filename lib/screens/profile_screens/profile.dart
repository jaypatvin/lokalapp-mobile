import 'package:flutter/material.dart';
import 'package:lokalapp/screens/add_product_screen/add_product.dart';
import 'package:lokalapp/screens/edit_shop_screen/edit_shop.dart';
import 'package:lokalapp/screens/profile_screens/profile_no_shop.dart';
import 'profile_shop.dart';

import '../../states/current_user.dart';
import 'package:provider/provider.dart';

class ProfileShopMain extends StatefulWidget {
  // final Map<String, String> account;
  // ProfileShopMain({Key key, @required this.account}) : super(key: key);

  @override
  _ProfileShopMainState createState() => _ProfileShopMainState();
}
//QHdK73bGFQRmgmPr3enN

class _ProfileShopMainState extends State<ProfileShopMain> {
  // final bool hasStore;

  Padding buildIconSettings() {
    return Padding(
        padding: const EdgeInsets.only(left: 5),
        child: IconButton(
          icon: Icon(
            Icons.settings,
            size: 38,
          ),
          color: Colors.white,
          onPressed: () {},
        ));
  }

  buildIconMore(context) {
    return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: IconButton(
          icon: Icon(
            Icons.more_horiz,
            size: 38,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context, true);
          },
        ));
  }

  Row buildCircleAvatar(String imgUrl) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 0),
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: imgUrl.isNotEmpty ? Image.network(imgUrl) : null,
            ),
          ),
        )),
      ],
    );
  }

  Row buildName(String firstName, String lastName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          firstName + " " + lastName,
          style: TextStyle(
              color: Colors.white,
              fontFamily: "GoldplayBold",
              fontSize: 24,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser user = Provider.of<CurrentUser>(context, listen: false);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 220),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
            ],
          ),
          width: MediaQuery.of(context).size.width,
          height: 450,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xffFFC700), Colors.black45]),
            ),
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildIconSettings(),
                      buildIconMore(context),
                    ],
                  ),
                  buildCircleAvatar(user.profilePhoto ?? ""),
                  SizedBox(
                    height: 15,
                  ),
                  buildName(user.firstName, user.lastName)
                ],
              ),
            ),
          ),
        ),
      ),
      body: ProfileNoShop(),
    ));
  }
}
