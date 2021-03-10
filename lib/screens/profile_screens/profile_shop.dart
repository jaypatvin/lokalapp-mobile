import 'package:flutter/material.dart';
import 'package:lokalapp/screens/add_product_screen/add_product.dart';
import 'package:lokalapp/screens/edit_shop_screen/edit_shop.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';

import 'components/store_card.dart';
import 'components/store_message.dart';
// import 'components/store_rating.dart';
// import 'profile_no_shop.dart';
import 'profile_search_bar.dart';
import 'profile_store_name.dart';

class ProfileShop extends StatefulWidget {
  @override
  _ProfileShopState createState() => _ProfileShopState();
}

class _ProfileShopState extends State<ProfileShop> {
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

  Row buildCircleAvatar() {
    var shopPhoto = Provider.of<CurrentUser>(context, listen: false)
        .userShops[0]
        .profilePhoto;
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 0),
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: shopPhoto != null && shopPhoto.isNotEmpty
                  ? Image.network(shopPhoto)
                  : null,
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
          _user.userShops[0].name,
          style: TextStyle(
              color: Colors.white,
              fontFamily: "GoldplayBold",
              fontSize: 24,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Row buildIcon() {
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
                                Navigator.pop(context, false);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => AddProduct()));
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

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<CurrentUser>(context, listen: false);
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
                      children: [buildIconSettings(), buildIcon()],
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
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
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
                          // should refactor/simplify this
                          backgroundImage: user.profilePhoto != null &&
                                  user.profilePhoto.isNotEmpty
                              ? NetworkImage(user.profilePhoto)
                              : null,
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
                  StoreMessage(
                    description: user.userShops[0].description,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: ProfileSearchBar()),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  user.userProducts.isNotEmpty
                      ? StoreCard()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             Container(
                        height: 40,
                        width: 200,
                        child: FlatButton(
                          // height: 50,
                          // minWidth: 100,
                          color: kTealColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: kTealColor),
                          ),
                          textColor: Colors.black,
                          child: Text(
                            "ADD PRODUCTS",
                            style: TextStyle(
                                fontFamily: "Goldplay",
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddProduct()));
                          },
                        ),
                      ),
                       Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                              "No products added",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Goldplay",
                              ),
                            ),
                    ],
                  ),
                           
                          ],
                        ),
                  SizedBox(
                    height: 20,
                  ),
                 
                ],
              ),
            )
          ],
        ),
      ),
    );
    // : ProfileNoShop(hasStore: false);
  }
}