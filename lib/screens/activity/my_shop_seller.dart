import 'package:flutter/material.dart';
import 'package:lokalapp/providers/cart.dart';
import 'package:lokalapp/providers/products.dart';
import 'package:lokalapp/providers/shops.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:provider/provider.dart';

import 'components/for_delivery_card.dart';
import 'components/prep_order_card.dart';
import 'components/to_confirm_card.dart';

class MyShopSeller extends StatefulWidget {
  @override
  _MyShopSellerState createState() => _MyShopSellerState();
}

class _MyShopSellerState extends State<MyShopSeller> {
  final Map<int, String> shopFilters = {
    0: 'All',
    1: 'For Confirmation',
    2: 'For Payment',
    3: 'For Delivery'
  };
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var user = Provider.of<CurrentUser>(context, listen: false);

    var products =
        Provider.of<Products>(context, listen: false).findByUser(user.id).first;

    var cart = Provider.of<ShoppingCart>(context, listen: false).items;

    var shops =
        Provider.of<Shops>(context, listen: false).findByUser(user.id).last;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width,
            color: Color(0xFF57183F),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'These are the products you ordered from other stores.',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Earnings",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "16,980,00.00",
                      style: TextStyle(color: Color(0XFFFF7A00)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Items Sold",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "127",
                      style: TextStyle(color: Color(0XFFFF7A00)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Most Popular",
                      style: TextStyle(color: Colors.white),
                    ),
                    // SizedBox(
                    //   width: 15,
                    // ),
                    Text(
                      "Cheesecake Bars",
                      style: TextStyle(color: Color(0XFFFF7A00)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
              height: 40,
              width: size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: shopFilters.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          selectedIndex = index;
                        }),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: selectedIndex == index
                                ? const Color(0xFFFFC700)
                                : const Color(0xFFEFEFEF),
                          ),
                          child: Text(shopFilters[index]),
                        ),
                      ),
                    ],
                  );
                },
              )),
          SizedBox(height: 10.0),
          Container(
            height: size.height * 0.45,
            width: size.width,
            child: ListView(shrinkWrap: true, children: [
              Container(
                  padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  child: Text(
                    "May 14",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "GoldplayBold",
                        fontWeight: FontWeight.w500),
                  )),
              SizedBox(
                height: 8,
              ),
              ToConfirmCard(
                username: shops.name,
                width: size.width * 0.9,
                price: products.basePrice,
                productName: products.name,
              ),
              SizedBox(
                height: 10,
              ),
              ForDeliveryCard(
                username: shops.name,
                width: size.width * 0.9,
                price: products.basePrice,
                productName: products.name,
              ),
              SizedBox(
                height: 10,
              ),
              PrepOrderCard(
                username: shops.name,
                width: size.width * 0.9,
                price: products.basePrice,
                productName: products.name,
              ),
              SizedBox(
                height: 30,
              ),
            ]),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
