import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:lokalapp/screens/checkout.dart';
import 'package:lokalapp/screens/discover/explore_categories.dart';
import 'package:lokalapp/screens/discover/order_placed.dart';
import 'package:lokalapp/screens/discover/order_screen_grid.dart';
import 'package:lokalapp/screens/order_confirmation.dart';
import 'package:lokalapp/screens/profile_screens/components/product_card.dart';
import 'package:lokalapp/screens/profile_screens/components/store_card.dart';
import 'package:lokalapp/states/current_user.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';

// import '../states/current_user.dart';
// import '../utils/themes.dart';
// import 'profile_screens/components/product_card.dart';
// import 'profile_screens/components/store_card.dart';
class Discover extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  Widget getTextWidgets(context) {
    var iconText = [
      "Dessert & Pastries",
      "Meals & Snacks",
      "Drinks",
      "Fashion"
    ];
    return Row(children: [
      for (var text in iconText)
        Expanded(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: "Goldplay"),
                ))),
    ]);
    // iconText
    //     .map((item) =>
    //         Container(width: 30, height: 10, child: Text('$item[index]')))
    //     .toList());
  }

  @override
  Widget build(BuildContext context) {
    List icon = List.generate(
      4,
      (i) => Container(
        padding: const EdgeInsets.only(right: 3),
        child: CircleAvatar(
          radius: 41,
          backgroundColor: Color(0XFFF1FAFF),
          child: Icon(
            Icons.food_bank,
            color: kTealColor,
            size: 38,
          ),
        ),
      ),
    ).toList();

    var user = Provider.of<CurrentUser>(context, listen: false);
    var products = user.userProducts;
    var shop = user.userShops[0];

    List card = List.generate(
      products.length,
      (index) {
        var gallery = products[index].gallery;
        var isGalleryEmpty = gallery == null || gallery.isEmpty;
        var productImage =
            !isGalleryEmpty ? gallery.firstWhere((g) => g.order == 0) : null;
        return Container(
          padding: const EdgeInsets.all(0.0),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width / 2,
          child: ProductCard(
            name: products[index].name,
            imageUrl: isGalleryEmpty ? '' : productImage.url,
            price: products[index].basePrice,
            shopName: shop.name,
            shopImageUrl: shop.profilePhoto,
          ),
        );
      },
    ).toList();

    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 100),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12, spreadRadius: 5, blurRadius: 2)
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(color: Color(0XFFFF7A00)),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            "Discover",
                            style: TextStyle(
                                fontFamily: "Goldplay",
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Color(0XFFFFC700)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        child: Theme(
                          data: ThemeData(primaryColor: Color(0xffF2F2F2)),
                          child: TextField(
                            controller: _searchController,
                            onTap: () {},
                            decoration: InputDecoration(
                              isDense: true, // Added this
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(25.0),
                                ),
                              ),
                              fillColor: Color(0xffF2F2F2),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Color(0xffBDBDBD),
                                size: 30,
                              ),
                              hintText: 'Search',
                              labelStyle: TextStyle(fontSize: 20),
                              hintStyle: TextStyle(color: Color(0xffBDBDBD)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Recommended",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "GoldplayBold",
                              fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: card),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Explore Categories",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "GoldplayBold",
                              fontSize: 20),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ExploreCategories()));
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(
                                  fontFamily: "Goldplay",
                                  color: kTealColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.arrow_forward_outlined,
                                color: kTealColor,
                                size: 16,
                              ),
                              onPressed: () {})
                        ],
                      )
                    ],
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 3),
                        height: MediaQuery.of(context).size.height / 6,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                            // shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListTile(
                                      title: Container(
                                        // padding:
                                        // const EdgeInsets.only(right: 5.0),
                                        child: Row(
                                          children: icon,
                                        ),
                                      ),
                                      subtitle: getTextWidgets(context),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    )
                  ]),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Recent",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "GoldplayBold",
                              fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: StoreCard(
                        crossAxisCount: 2,
                      )),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderPlaced()));
                          },
                          child: Text("Order placed"))
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Checkout()));
                          },
                          child: Text("Checkout"))
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderConfirmation()));
                          },
                          child: Text("Order Confirmation"))
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderScreenGrid()));
                          },
                          child: Text("Order Grid"))
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )));
  }
}
