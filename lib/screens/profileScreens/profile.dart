import 'package:flutter/material.dart';
import 'package:lokalapp/screens/add_product_screen/add_product.dart';
import 'package:lokalapp/screens/edit_shop_screen/edit_shop.dart';
import 'package:lokalapp/screens/profileScreens/profile_shop.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final Map<String, String> account;
  Profile({Key key, @required this.account}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool showBottomSheet = true;
  Padding buildIconSettings() {
    return Padding(
        padding: const EdgeInsets.only(left: 3),
        child: IconButton(
          icon: Icon(
            Icons.settings,
            size: 35,
          ),
          color: Colors.white,
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => EditShop()));
          },
        ));
  }

  Row buildIconMore() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 250),
          child: IconButton(
              icon: Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: 38,
              ),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                          height: 140,
                          color: Colors.white,
                          padding: EdgeInsets.only(
                              left: 50, top: 10, bottom: 10, right: 40),
                          child: ListView(children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditShop()));
                              },
                              child: ListTile(
                                leading: Text(
                                  "Edit Shop",
                                  softWrap: true,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Goldplay",
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddProduct()));
                              },
                              child: ListTile(
                                leading: Text(
                                  "Add Product",
                                  softWrap: true,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Goldplay",
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            )
                          ]));
                    });
              }),
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
    CurrentUser _user = Provider.of<CurrentUser>(context);
    return SafeArea(
      child: Scaffold(
          key: scaffoldKey,
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
