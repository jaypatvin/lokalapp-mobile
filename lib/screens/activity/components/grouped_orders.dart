import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../models/order.dart';
import '../../../providers/auth.dart';
import '../../../services/lokal_api_service.dart';
import '../../../utils/constants/assets.dart';
import '../buyer/order_received.dart';
import '../buyer/payment_option.dart';
import '../order_details.dart';
import '../seller/order_confirmed.dart';
import '../seller/payment_confirmed.dart';
import '../seller/shipped_out.dart';
import 'transaction_card.dart';

class GroupedOrders extends StatelessWidget {
  final Stream<QuerySnapshot>? stream;
  final Map<int, String?> statuses;
  final bool isBuyer;
  const GroupedOrders(this.stream, this.statuses, this.isBuyer);

  // This callback function should be in this hierarchy so that the app
  // can successfuly Navigate to other screens while keeping the context
  void onSecondButtonPress(BuildContext context, Order order) {
    if (this.isBuyer) {
      switch (order.statusCode) {
        case 200:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentOption(order: order),
            ),
          );
          break;
        case 500:
          final idToken = context.read<Auth>().idToken;
          LokalApiService.instance!.orders!
              .receive(idToken: idToken, orderId: order.id)
              .then((response) {
            if (response.statusCode == 200) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderReceived(order: order),
                ),
              );
            }
          });
          break;
        default:
          break;
      }
    } else {
      switch (order.statusCode) {
        case 100:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderConfirmed(
                order: order,
                isBuyer: this.isBuyer,
              ),
            ),
          );
          break;
        case 300:
          if (order.paymentMethod == "cod") {
            final idToken = context.read<Auth>().idToken;
            LokalApiService.instance!.orders!
                .confirmPayment(idToken: idToken, orderId: order.id)
                .then((response) {
              if (response.statusCode == 200) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentConfirmed(order: order),
                  ),
                );
              }
            });
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetails(
                  order: order,
                  isBuyer: isBuyer,
                ),
              ),
            );
          }

          break;
        case 400:
          final idToken = context.read<Auth>().idToken;
          LokalApiService.instance!.orders!
              .shipOut(
            idToken: idToken,
            orderId: order.id,
          )
              .then((response) {
            if (response.statusCode == 200) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShippedOut(order: order),
                ),
              );
            }
          });
          break;
        default:
          // do nothing
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: this.stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Lottie.asset(kAnimationLoading),
              ),
            );
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else if (!snapshot.hasData || snapshot.data!.docs.length == 0)
              return Text(
                'No orders yet!',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              );
            else
              // Without using ListView.builder, I'm not sure about the performance
              // on large sets of data
              return GroupedListView(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                elements: snapshot.data!.docs,
                groupBy: (QueryDocumentSnapshot element) {
                  final date = (element["created_at"] as Timestamp).toDate();
                  return DateTime(date.year, date.month, date.day);
                },
                groupSeparatorBuilder: (DateTime value) {
                  return Text(
                    DateFormat.MMMMd().format(value),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  );
                },
                order: GroupedListOrder.DESC,
                itemBuilder: (context, QueryDocumentSnapshot snapshot) {
                  final snapshotData = snapshot.data() as Map<String, dynamic>;
                  final int? code = snapshotData["status_code"];
                  final data = {...snapshotData, "id": snapshot.id};
                  final order = Order.fromMap(data);
                  return TransactionCard(
                    order: order,
                    isBuyer: this.isBuyer,
                    status: this.statuses[code!],
                    onSecondButtonPress: () =>
                        onSecondButtonPress(context, order),
                  );
                },
                itemComparator: (
                  QueryDocumentSnapshot a,
                  QueryDocumentSnapshot b,
                ) {
                  final _statusCodeA = a.get("status_code");
                  final _statusCodeB = b.get("status_code");
                  final statusCodeA = (_statusCodeA == 10 || _statusCodeA == 20)
                      ? _statusCodeA * 100
                      : _statusCodeA;
                  final statusCodeB = (_statusCodeB == 10 || _statusCodeB == 20)
                      ? _statusCodeB * 100
                      : _statusCodeB;

                  return statusCodeA.compareTo(statusCodeB);
                },
              );
        }
      },
    );
  }
}
