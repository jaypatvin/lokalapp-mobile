import 'package:flutter/material.dart';
import 'package:lokalapp/screens/profile_screens/settings/settings.dart';
import 'package:provider/provider.dart';

import '../../providers/user.dart';
import '../cart/sliding_up_cart.dart';
import 'edit_profile.dart';
import 'profile_no_shop.dart';

class ProfileShopMain extends StatefulWidget {
  @override
  _ProfileShopMainState createState() => _ProfileShopMainState();
}

class _ProfileShopMainState extends State<ProfileShopMain> {
  Padding buildIconSettings() {
    return Padding(
        padding: const EdgeInsets.only(left: 5),
        child: IconButton(
          icon: Icon(
            Icons.settings,
            size: 38,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Settings()));
          },
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditProfile()));
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
    var user = Provider.of<CurrentUser>(context);
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
        body: SlidingUpCart(child: ProfileNoShop()),
      ),
    );
  }
}
