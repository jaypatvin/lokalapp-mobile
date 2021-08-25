import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../utils/shared_preference.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../cart/cart_container.dart';
import '../profile_screens/components/product_card.dart';
import '../profile_screens/components/store_card.dart';
import '../search/search.dart';
import 'checkout.dart';
import 'explore_categories.dart';
import 'order_placed.dart';
import 'order_screen_grid.dart';
import 'product_detail.dart';

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> with AfterLayoutMixin<Discover> {
  final TextEditingController _searchController = TextEditingController();
  var _userSharedPreferences = UserSharedPreferences();

  Widget getTextWidgets(context) {
    var iconText = [
      "Dessert & Pastries",
      "Meals & Snacks",
      "Drinks",
      "Fashion"
    ];
    return Row(
      children: [
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
              ),
            ),
          ),
      ],
    );
  }

  Widget get consumerShopAndProduct =>
      Consumer2<Products, Shops>(builder: (context, products, shops, __) {
        return products.isLoading || shops.isLoading
            ? Center(child: CircularProgressIndicator())
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: products.items.length,
                      itemBuilder: (ctx, index) {
                        var shop = shops.findById(products.items[index].shopId);
                        var gallery = products.items[index].gallery;
                        var isGalleryEmpty = gallery == null || gallery.isEmpty;
                        var productImage = !isGalleryEmpty
                            ? gallery.firstWhere((g) => g.url.isNotEmpty)
                            : null;
                        return Container(
                          padding: const EdgeInsets.all(0.0),
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width / 2,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetail(
                                          products.items[index])));
                            },
                            child: ProductCard(
                              productId: products.items[index].id,
                              name: products.items[index].name,
                              imageUrl: isGalleryEmpty ? '' : productImage.url,
                              price: products.items[index].basePrice,
                              shopName: shop.name,
                              shopImageUrl: shop.profilePhoto,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
      });

  Widget get rowRecent => Row(
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
      );

  Widget get recommended => Row(
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
      );
  Widget get buildSearchTextField => TextField(
        enabled: false,
        // controller: _searchController,

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
      );
  @override
  void initState() {
    super.initState();

    _userSharedPreferences = UserSharedPreferences();
    _userSharedPreferences.init();
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

    return Scaffold(
      appBar: CustomAppBar(
        titleText: "Discover",
        backgroundColor: kOrangeColor,
        buildLeading: false,
      ),
      body: CartContainer(
        child: SingleChildScrollView(
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
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Search()));
                        },
                        child: buildSearchTextField,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              recommended,
              SizedBox(
                height: 12,
              ),
              consumerShopAndProduct,
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
                                  builder: (context) => ExploreCategories()));
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
                                height: MediaQuery.of(context).size.height / 2,
                                width: MediaQuery.of(context).size.width,
                                child: ListTile(
                                  title: Container(
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
              rowRecent,
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
                    ),
                  ),
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
                                builder: (context) => OrderScreenGrid()));
                      },
                      child: Text("Order Grid"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout

    _userSharedPreferences.isDiscover ? Container() : showAlert(context);
    setState(() {
      _userSharedPreferences.isDiscover = true;
    });
  }

  @override
  dispose() {
    _userSharedPreferences?.dispose();
    super.dispose();
  }

  showAlert(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 22),
        // contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        content: Container(
          height: height * 0.3,
          width: width * 0.9,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Container(
            width: width * 0.9,
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        width: width * 0.25,
                        child: Icon(
                          Icons.web_asset_outlined,
                          size: 80,
                          color: Color(0xffCC3752),
                        ),
                      ),
                      Text(
                        "Discover",
                        style: TextStyle(color: Color(0xffCC3752)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 5, right: 15, bottom: 5),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, top: 30, right: 15, bottom: 5),
                            child: Text(
                              'Discover is where you can find',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(right: 15, bottom: 5, top: 1),
                            child: Text(
                              'food, products, services or ' + " " + " ",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                              padding:
                                  EdgeInsets.only(right: 30, bottom: 5, top: 1),
                              child: Text(
                                'anything that is being sold',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 14),
                              )),
                          Container(
                              padding:
                                  EdgeInsets.only(right: 25, bottom: 5, top: 1),
                              child: Text(
                                ' in this community. ' + " " + " " + " " + " ",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 14),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Center(
                                child: Container(
                                  height: 43,
                                  width: 180,
                                  child: FlatButton(
                                    color: kTealColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(color: kTealColor),
                                    ),
                                    textColor: kTealColor,
                                    child: Text(
                                      "Okay!",
                                      style: TextStyle(
                                          fontFamily: "Goldplay",
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
