import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../models/order.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/constants/assets.dart';
import '../../../view_models/activity/components/grouped_orders.vm.dart';
import '../../../widgets/overlays/screen_loader.dart';
import 'transaction_card.dart';

class GroupedOrders extends StatelessWidget {
  const GroupedOrders(
    this.stream,
    this.statuses,
    this.isBuyer, {
    Key? key,
  }) : super(key: key);

  final Stream<QuerySnapshot>? stream;
  final Map<int, String?> statuses;

  final bool isBuyer;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _GroupedOrdersView(stream, statuses),
      viewModel: GroupedOrdersViewModel(isBuyer: isBuyer),
    );
  }
}

class _GroupedOrdersView extends HookView<GroupedOrdersViewModel>
    with HookScreenLoader<GroupedOrdersViewModel> {
  _GroupedOrdersView(this.stream, this.statuses);
  final Stream<QuerySnapshot>? stream;
  final Map<int, String?> statuses;

  @override
  Widget screen(BuildContext context, GroupedOrdersViewModel vm) {
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
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            else if (!snapshot.hasData || snapshot.data!.docs.length == 0)
              return Center(
                child: Text(
                  'No orders yet!',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            else
              // This uses ListView.builder under the hood so is performant.
              return GroupedListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                physics: AlwaysScrollableScrollPhysics(),
                elements: snapshot.data!.docs,
                groupBy: (QueryDocumentSnapshot element) {
                  final date = (element["created_at"] as Timestamp).toDate();
                  return DateTime(date.year, date.month, date.day);
                },
                groupSeparatorBuilder: (DateTime value) {
                  return Container(
                    margin: EdgeInsets.only(top: 10.0.h, bottom: 15.0.h),
                    child: Text(
                      DateFormat.MMMMd().format(value),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(fontSize: 18.0.sp),
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
                    isBuyer: vm.isBuyer,
                    status: this.statuses[code]!,
                    onSecondButtonPress: () async => await performFuture<void>(
                      () async => await vm.onSecondButtonPress(order),
                    ),
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
