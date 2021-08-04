import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/order.dart';
import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../providers/users.dart';
import '../../chat/components/chat_avatar.dart';

class TransactionDetails extends StatelessWidget {
  final Order transaction;
  final String status;
  final bool isBuyer;

  const TransactionDetails({
    this.status = "",
    @required this.transaction,
    @required this.isBuyer,
  });

  Widget _buildAvatar(BuildContext context, String name, String displayPhoto) {
    return Row(
      children: [
        ChatAvatar(
          displayName: name,
          displayPhoto: displayPhoto ?? "",
          radius: 20.0,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.01,
        ),
        Text(name, style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = isBuyer
        ? transaction.shopName
        : Provider.of<Users>(context, listen: false)
            .findById(transaction.buyerId)
            .displayName;

    final displayPhoto = isBuyer
        ? Provider.of<Shops>(context, listen: false)
            .findById(transaction.shopId)
            .profilePhoto
        : Provider.of<Users>(context, listen: false)
            .findById(transaction.buyerId)
            .profilePhoto;

    final price = this
        .transaction
        .products
        .fold(0.0, (double prev, product) => prev + product.productPrice);

    final isStatus = status != null && status.isNotEmpty;

    final displayStatus =
        (transaction.statusCode == 300 && transaction.paymentMethod == "cod")
            ? "Cash on Delivery"
            : this.status;

    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isStatus
                  ? Text(
                      displayStatus,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    )
                  : _buildAvatar(context, name, displayPhoto),
              // Text('For ${DateFormat.MMMd().format(transaction.deliveryDate)}')
              RichText(
                maxLines: 1,
                text: TextSpan(
                  text: "For ",
                  children: [
                    TextSpan(
                      text: DateFormat.MMMd().format(transaction.deliveryDate),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    color: Colors.black,
                    fontFamily: "Goldplay",
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),

          // ------ dirty code, for cleanup
          if (isStatus) _buildAvatar(context, name, displayPhoto),
          if (isStatus)
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          // ------

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: this.transaction.products.length,
            itemBuilder: (ctx, index) {
              final item = this.transaction.products[index];
              final product = Provider.of<Products>(context, listen: false)
                  .findById(item.productId);

              return Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.12,
                      height: MediaQuery.of(context).size.width * 0.12,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(product.gallery.first.url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      item.productName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text('x${item.quantity}'),
                    Text(
                      'P ${item.quantity * item.productPrice}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Divider(
            color: Colors.grey,
            indent: 0,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Align(
              alignment: Alignment.centerRight,
              //child: Text('Order Total P$price'),
              child: RichText(
                text: TextSpan(
                  text: "Order Total ",
                  children: [
                    TextSpan(
                      text: "P $price",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Goldplay",
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
