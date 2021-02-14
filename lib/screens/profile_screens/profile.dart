import 'package:flutter/material.dart';
import 'profile_shop.dart';

import '../../states/current_user.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final Map<String, String> account;
  Profile({Key key, @required this.account}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

  Row buildIconMore() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 290),
          child: IconButton(
              icon: Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: 41,
              ),
              onPressed: () {}),
        ),
      ],
    );
  }

  Row buildCircleAvatar() {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 0),
          child: CircleAvatar(
            radius: 48,
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
              fontSize: 28,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser _user = Provider.of<CurrentUser>(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 220),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, spreadRadius: 5, blurRadius: 2)
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildIconSettings(),
                          buildIconMore(),
                        ],
                      ),
                      buildCircleAvatar(),
                      SizedBox(
                        height: 15,
                      ),
                      buildName(
                        _user.getCurrentUser.firstName,
                        _user.getCurrentUser.lastName,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: ProfileShop(hasStore: false)),
    );
  }
}
