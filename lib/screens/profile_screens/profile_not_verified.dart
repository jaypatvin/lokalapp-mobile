import 'package:flutter/material.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';

class ProfileNotVerified extends StatefulWidget {
  @override
  _ProfileNotVerifiedState createState() => _ProfileNotVerifiedState();
}

class _ProfileNotVerifiedState extends State<ProfileNotVerified> {
  Widget buildVerifyAccount() {
    return Container(
      height: 43,
      width: 180,
      child: FlatButton(
        // height: 50,
        // minWidth: 100,
        color: Color(0XFFCC3752),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Color(0xFFCC3752)),
        ),
        textColor: Colors.black,
        child: Text(
          "VERIFY ACCOUNT",
          style: TextStyle(
            fontFamily: "GoldplayBold",
            fontSize: 16,
            // fontWeight: FontWeight.w600
          ),
        ),
        onPressed: () {
          Navigator.pop(context, false);
        },
      ),
    );
  }

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
            radius: 38,
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
          // "Bakey Bakey",
          _user.firstName + " " + _user.lastName,
          style: TextStyle(
              color: Colors.white,
              fontFamily: "GoldplayBold",
              fontSize: 24,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildVerifyAccount(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "You need to verify your account ",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "GoldplayBold",
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("before you can add a shop.",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "GoldplayBold",
                      fontWeight: FontWeight.w300))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                    maxWidth: MediaQuery.of(context).size.width),
                child: Container(
                  color: Color(0XFFF1FAFF),
                  child: Text("No posts yet",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "GoldplayBold",
                          fontWeight: FontWeight.w300)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
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
        body: buildBody());
  }
}
