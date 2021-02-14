import 'package:flutter/material.dart';

import 'components/store_card.dart';
import 'components/store_message.dart';
import 'components/store_rating.dart';
import 'profile_no_shop.dart';
import 'profile_search_bar.dart';
import 'profile_store_name.dart';

class ProfileShop extends StatelessWidget {
  final bool hasStore;
  ProfileShop({this.hasStore});
  @override
  Widget build(BuildContext context) {
    return hasStore
        ? SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 18),
                      child: CircleAvatar(
                        radius: 26,
                        backgroundImage: NetworkImage(
                            "https://media.istockphoto.com/vectors/bakery-hand-written-lettering-logo-vector-id1166282839?b=1&k=6&m=1166282839&s=612x612&w=0&h=fOgckd0dFcbS3UWVbKAFmCwrc0ti9A56FB-J0GEp9LA="),
                      ),
                    ),
                    ProfileStoreName(),
                    StoreRating(),
                    Container(
                        padding: EdgeInsets.all(12.2),
                        child: Text(
                          "4.45",
                          style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                  ],
                ),
                StoreMessage(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: ProfileSearchBar()),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                StoreCard()
              ],
            ),
          )
        : ProfileNoShop(hasStore: false);
  }
}
