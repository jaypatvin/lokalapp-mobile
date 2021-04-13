import 'package:flutter/material.dart';
import 'package:lokalapp/providers/products.dart';
import 'package:lokalapp/providers/shops.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:lokalapp/screens/activity/delivered_seller.dart';
import 'package:lokalapp/screens/activity/my_shop.dart';
import 'package:lokalapp/screens/activity/seller_confirmation.dart';
import 'package:lokalapp/screens/activity/view_proof_of_payment_seller.dart';
import 'package:provider/provider.dart';

import 'components/for_delivery_card.dart';
import 'components/prep_order_card.dart';
import 'components/to_confirm_card.dart';

class SellerMyShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var user = Provider.of<CurrentUser>(context, listen: false);

    var shops =
        Provider.of<Shops>(context, listen: false).findByUser(user.id).first;

    var products =
        Provider.of<Products>(context, listen: false).findByUser(user.id).first;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF57183F),
        bottom: PreferredSize(
            child: Container(
              color: Color(0XFFCC3752),
              height: 60.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Padding(padding: const EdgeInsets.only(left: 30)),
                  SizedBox(
                    width: 26,
                  ),
                  Text(
                    "My Shop",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "GoldplayBold",
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      onPressed: () {})
                ],
              ),
            ),
            preferredSize: Size.fromHeight(60.0)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyShop()));
                      },
                      child: Text(
                        "My Orders",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "GoldplayBold",
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "My Shop",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "GoldplayBold",
                          color: Colors.black),
                    ),
                  )),
                ),
                Expanded(
                  child: Container(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "History",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "GoldplayBold",
                            color: Colors.black),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                      height: 180,
                      color: Colors.grey.shade300,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Total Earnings",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "GoldplayBold"),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "15,890.00",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "GoldplayBold"),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Items Sold",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "GoldplayBold"),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Text(
                                "127",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "GoldplayBold"),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Most Popular",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "GoldplayBold"),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Cheesecake Bars",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "GoldplayBold"),
                              )
                            ],
                          ),
                        ],
                      )),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SellerConfirmation()));
                      },
                      child: Text(
                        "For Confirmation",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "GoldplayBold",
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ViewProofOfPaymentSeller()));
                      },
                      child: Text(
                        "To Pay",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "GoldplayBold",
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DeliveredSeller()));
                      },
                      child: Text(
                        "For Delivery",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "GoldplayBold",
                            color: Colors.black),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ToConfirmCard(
              username: shops.name.toString(),
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
            )
          ],
        ),
      ),
    );
  }
}
