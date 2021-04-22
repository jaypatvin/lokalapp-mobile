import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../utils/themes.dart';
import '../discover/order_confirmation.dart';
import 'pull_up_panel_header.dart';

class PullUpPanel extends StatelessWidget {
  final ScrollController scrollController;
  final bool renderBorder;
  PullUpPanel({
    this.scrollController,
    this.renderBorder,
  });
  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  renderBorder ? Border.all(color: Color(0xFFFF7A00)) : null,
              borderRadius: BorderRadius.vertical(top: Radius.circular(36.0))),
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PullUpPanelHeader(),
                Consumer<ShoppingCart>(
                  builder: (context, cart, child) {
                    return ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        String key = cart.items.keys.elementAt(index);
                        int quantity = cart.items[key].quantity;
                        var products =
                            Provider.of<Products>(context, listen: false);
                        var product = products.findById(key);
                        var productImage = product.gallery.firstWhere((image) =>
                            image.url != null && image.url.isNotEmpty);
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 70.00,
                                        height: 60.00,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image:
                                                NetworkImage(productImage.url),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            child: Text(
                                              product.name,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "GoldplayBold",
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          InkWell(
                                            child: Text(
                                              "Edit",
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: "Goldplay",
                                                fontWeight: FontWeight.w300,
                                                decoration:
                                                    TextDecoration.underline,
                                                color: kTealColor,
                                              ),
                                            ),
                                            onTap: () {},
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(height: 60.0),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'x$quantity',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "GoldplayBold",
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Container(
                                            // padding: const EdgeInsets.all(0.0),
                                            child: Text(
                                              product.basePrice.toString(),
                                              // textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: "GoldplayBold",
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 9,
                              ),
                              Divider(
                                color: Colors.grey,
                                indent: 0,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderConfirmation(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Checkout",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "GoldplayBold",
                              fontWeight: FontWeight.w700,
                              color: kTealColor,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Container(
                            // color: kTealColor,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kTealColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Icon(
                                Icons.arrow_forward,
                                size: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
