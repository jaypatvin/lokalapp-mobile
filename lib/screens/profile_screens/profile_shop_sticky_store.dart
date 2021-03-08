import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/models/user_shop.dart';
import 'package:lokalapp/screens/profile_screens/components/store_rating.dart';
import 'package:lokalapp/screens/profile_screens/profile_shop.dart';
import 'package:lokalapp/screens/profile_screens/profile_store_name.dart';
import 'package:lokalapp/services/database.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ProfileShopStickyStore extends StatefulWidget {
  final bool hasStore;
  ProfileShopStickyStore({this.hasStore});
  @override
  _ProfileShopStickyStoreState createState() => _ProfileShopStickyStoreState();
}

class _ProfileShopStickyStoreState extends State<ProfileShopStickyStore> {
  String shopName;
  // List<ShopModel> shopPhoto;
  String url;
  @override
  initState() {
    super.initState();
    getUser();
    // _getShopImage();
  }

  getUser() async {
    CurrentUser _user = Provider.of(context, listen: false);

    if (_user.id != null) {
      try {
        var success = await _user.getShops();
        // final shopPhoto = storageRef.child(_user.userShops[0].profilePhoto);

        // var urlPhoto = await shopPhoto.getDownloadURL();

        if (success) {
          setState(() {
            shopName = _user.userShops[0].name;
            // url = urlPhoto;
          });
          print(_user.userShops[0].profilePhoto);
        }
      } on Exception catch (_) {
        print(_);
      }
    }
  }

  Widget buildShopStore(context) {
    CurrentUser _shop = Provider.of<CurrentUser>(context, listen: false);

    return Container(
      height: 53,
      width: MediaQuery.of(context).size.width,
      child: ListView(shrinkWrap: true, children: [
        Container(
          child: ListTile(
            leading:
                CircleAvatar(radius: 23, backgroundImage: NetworkImage("")),
            title: Text(
              shopName,
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

class FireStorageService extends ChangeNotifier {
  FireStorageService();
  static Future<dynamic> loadImage(BuildContext context, String Image) async {
    return await FirebaseStorage.instance.ref().child(Image).getDownloadURL();
  }
}
