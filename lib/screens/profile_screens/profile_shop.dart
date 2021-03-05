import 'package:flutter/material.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:provider/provider.dart';

import 'components/store_card.dart';
import 'components/store_message.dart';
// import 'components/store_rating.dart';
// import 'profile_no_shop.dart';
import 'profile_search_bar.dart';
import 'profile_store_name.dart';

class ProfileShop extends StatelessWidget {
  final bool hasStore;
  ProfileShop({this.hasStore});

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
            Navigator.pop(context);
          },
        ));
  }

  Row buildCircleAvatar() {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 0),
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.network(
                  "https://hips.hearstapps.com/digitalspyuk.cdnds.net/17/38/1505816350-screen-shot-2017-09-19-at-111641.jpg?crop=0.502xw:1.00xh;0.0952xw,0&resize=480:*"),
            ),
          ),
        )),
      ],
    );
  }

  Row buildName(context) {
    CurrentUser _user = Provider.of<CurrentUser>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Bakey Bakey",
          // _user.firstName + " " + _user.lastName,
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
            height: 500,
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
                      children: [buildIconSettings(), buildIconMore(context)],
                    ),
                    buildCircleAvatar(),
                    SizedBox(
                      height: 15,
                    ),
                    buildName(context)
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 45,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 18),
                    child: CircleAvatar(
                      radius: 23,
                      backgroundImage: NetworkImage(
                          "https://media.istockphoto.com/vectors/bakery-hand-written-lettering-logo-vector-id1166282839?b=1&k=6&m=1166282839&s=612x612&w=0&h=fOgckd0dFcbS3UWVbKAFmCwrc0ti9A56FB-J0GEp9LA="),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        // padding: const EdgeInsets.only(left: 15),
                        child: ProfileStoreName(),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text("No reviews yet",
                          style: TextStyle(
                            fontFamily: "Goldplay",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ),
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
        ),
      ),
    );
    // : ProfileNoShop(hasStore: false);
  }
}
