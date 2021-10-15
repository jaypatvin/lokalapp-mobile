import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../utils/themes.dart';
import '../../widgets/app_button.dart';
import '../discover/product_detail.dart';
import 'checkout_shop.dart';
import 'components/order_details.dart';

class CheckoutCart extends StatelessWidget {
  const CheckoutCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _CheckOutCartAppBar(),
      body: Consumer<ShoppingCart>(
        builder: (_, cart, __) {
          return Container(
            child: ListView.builder(
              itemCount: cart.orders.length,
              itemBuilder: (ctx, index) {
                // get shopId from Map
                final key = cart.orders.keys.elementAt(index);
                final shop = context.read<Shops>().findById(key)!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 24.0),
                    Text(
                      shop.name!,
                      style: TextStyle(
                        color: kNavyColor,
                        fontFamily: "Goldplay",
                        fontWeight: FontWeight.w800,
                        fontSize: 24.0,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Card(
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: cart.orders[key]!.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (_, orderIndex) {
                                  // get the shopOrders
                                  final orders = cart.orders[key]!;
                                  // get productId from Map using orderIndex
                                  final _key =
                                      orders.keys.elementAt(orderIndex);
                                  final product =
                                      context.read<Products>().findById(_key);
                                  return OrderDetails(
                                    product: product!,
                                    quantity: orders[_key]!.quantity,
                                    onEditTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              ProductDetail(product)),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 12.0),
                              Container(
                                width: double.infinity,
                                child: AppButton(
                                  "Checkout",
                                  kTealColor,
                                  false,
                                  () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ShopCheckout(shop: shop),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _CheckOutCartAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final double height;

  const _CheckOutCartAppBar({this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kTealColor,
      leading: Container(
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Shopping Cart",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Goldplay",
              fontWeight: FontWeight.w600,
              fontSize: 24.0,
            ),
          ),
          SizedBox(width: 8.0),
          Container(
            padding: EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              color: kOrangeColor,
              borderRadius: BorderRadius.circular(25.0),
            ),
            constraints: BoxConstraints(
              minWidth: 18.0,
              minHeight: 18.0,
            ),
            child: Consumer<ShoppingCart>(
              builder: (_, cart, __) {
                return Center(
                  child: Text(
                    cart.orders.length.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Goldplay",
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
