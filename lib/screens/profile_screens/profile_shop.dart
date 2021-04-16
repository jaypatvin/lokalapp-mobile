import 'package:flutter/material.dart';
import '../../providers/cart.dart';
import '../../providers/pull_up_cart_state.dart';
import '../cart/sliding_up_cart.dart';
import 'package:provider/provider.dart';

import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../utils/themes.dart';
import '../add_product_screen/add_product.dart';
import '../edit_shop_screen/edit_shop.dart';
import 'components/settings.dart';
import 'components/store_card.dart';
import 'components/store_message.dart';
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
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Settings()));
          },
        ));
  }

  Row buildCircleAvatar(String shopImage) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 0),
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: shopImage != null && shopImage.isNotEmpty
                  ? Image.network(shopImage)
                  : null,
            ),
          ),
        )),
      ],
    );
  }

  Row buildName(String shopName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          shopName,
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
                      child: ListView(
                        children: [
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
                              //Navigator.pop(context, false);
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
                        ],
                      ),
                    );
                  },
                );
              }),
        ),
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
                child: Consumer2<CurrentUser, Shops>(
                  builder: (_, user, shops, __) {
                    var userShop = shops.findByUser(user.id).first;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [buildIconSettings(), buildIcon()],
                        ),
                        buildCircleAvatar(userShop.profilePhoto),
                        SizedBox(
                          height: 15,
                        ),
                        buildName(userShop.name)
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        body: SlidingUpCart(
          child: CustomScrollView(
            slivers: [
              Consumer3<CurrentUser, Shops, Products>(
                  builder: (context, user, shops, products, __) {
                var shop = shops.findByUser(user.id).first;
                return SliverList(
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
                        description: shop.description,
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
                      products.findByUser(user.id).isNotEmpty
                          ? Column(
                              children: [
                                StoreCard(
                                  crossAxisCount: 2,
                                  isUserProducts: true,
                                ),
                                SizedBox(height: 20.0),
                                Container(
                                  height: 40,
                                  width: 200,
                                  child: FlatButton(
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
                                              builder: (context) =>
                                                  AddProduct()));
                                    },
                                  ),
                                ),
                                Consumer2<ShoppingCart, PullUpCartState>(
                                    builder: (context, cart, cartState, _) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        (cart.items.length > 0 &&
                                                cartState.isPanelVisible
                                            ? 0.5
                                            : 0.4),
                                  );
                                })
                              ],
                            )
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
                                              builder: (context) =>
                                                  AddProduct()));
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
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
