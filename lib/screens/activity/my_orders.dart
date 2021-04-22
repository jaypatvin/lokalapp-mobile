import 'package:flutter/material.dart';
import 'package:lokalapp/providers/cart.dart';
import 'package:lokalapp/providers/products.dart';
import 'package:lokalapp/providers/shops.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:lokalapp/screens/activity/for_delivery_buyer.dart';
import 'package:lokalapp/screens/activity/order_details.dart';
import 'package:lokalapp/screens/activity/to_pay.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:provider/provider.dart';

import 'components/for_delivery_card.dart';
import 'components/prep_order_card.dart';
import 'components/to_confirm_card.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  int selectedIndex;
  final Map<int, String> orderFilters = {
    0: 'All',
    1: 'For Confirmation',
    2: 'To Pay',
    3: 'For Delivery'
  };

  navigation() {
    switch (selectedIndex) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyOrders()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OrderDetails()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ToPay()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ForDeliveryBuyer()));
        break;
      default:
        return Container();
        break;
    }
  }

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
        Provider.of<Shops>(context, listen: false).findByUser(user.id).first;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width,
          color: kTealColor,
          child: Text(
            'These are the products you ordered from other stores.',
            style: TextStyle(color: Colors.white),
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
              itemCount: orderFilters.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                        navigation();
                      },
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
                        child: Text(orderFilters[index]),
                      ),
                    ),
                  ],
                );
              },
            )),
        SizedBox(height: 10.0),
        Container(
          height: size.height * 0.60,
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
    );
  }
}
