import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../models/order.dart';
import '../../../utils/constants/assets.dart';
import 'transaction_card.dart';

class GroupedOrders extends StatelessWidget {
  const GroupedOrders({
    Key? key,
    required this.stream,
    required this.statuses,
    required this.isBuyer,
    required this.onSecondButtonPressed,
  }) : super(key: key);

  final Stream<QuerySnapshot<Map<String, dynamic>>>? stream;
  final Map<int, String?> statuses;
  final bool isBuyer;
  final void Function(Order order) onSecondButtonPressed;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return SliverFillRemaining(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Lottie.asset(kAnimationLoading),
              ),
            );
          default:
            if (snapshot.hasError) {
              return SliverFillRemaining(
                child: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No orders yet!',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            } else {
              return SliverGroupedListView(
                elements: snapshot.data!.docs,
                groupBy: (QueryDocumentSnapshot element) {
                  final date = (element['created_at'] as Timestamp).toDate();
                  return DateTime(date.year, date.month, date.day);
                },
                groupSeparatorBuilder: (DateTime value) {
                  return Container(
                    margin: const EdgeInsets.only(
                      top: 14,
                      bottom: 12,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: Text(
                      DateFormat.MMMMd().format(value),
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Colors.black),
                    ),
                  );
                },
                order: GroupedListOrder.DESC,
                itemBuilder: (context, QueryDocumentSnapshot snapshot) {
                  final snapshotData = snapshot.data()! as Map<String, dynamic>;
                  final int? code = snapshotData['status_code'];
                  final data = {...snapshotData, 'id': snapshot.id};
                  final order = Order.fromJson(data);
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: TransactionCard(
                      order: order,
                      isBuyer: isBuyer,
                      status: statuses[code],
                      onSecondButtonPress: () => onSecondButtonPressed(order),
                    ),
                  );
                },
                itemComparator: (
                  QueryDocumentSnapshot a,
                  QueryDocumentSnapshot b,
                ) {
                  final _statusCodeA = a.get('status_code');
                  final _statusCodeB = b.get('status_code');
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
        }
      },
    );
  }
}
