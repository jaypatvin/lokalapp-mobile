import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/activity/transactions.vm.dart';
import 'components/grouped_orders.dart';

class Transactions extends StatelessWidget {
  const Transactions(
    this._statuses,
    this._isBuyer,
    this._colorAnimation, {
    Key? key,
  }) : super(key: key);

  final Map<int, String?> _statuses;
  final bool _isBuyer;
  final Animation<Color?> _colorAnimation;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _TransactionsView(
        _colorAnimation,
      ),
      viewModel: TransactionsViewModel(
        _statuses,
        isBuyer: _isBuyer,
      ),
    );
  }
}

class _TransactionsView extends HookView<TransactionsViewModel> {
  const _TransactionsView(
    this._colorAnimation, {
    Key? key,
  }) : super(key: key);

  final Animation<Color?> _colorAnimation;
  @override
  Widget render(BuildContext context, TransactionsViewModel vm) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(20.0.h),
          width: MediaQuery.of(context).size.width,
          color: _colorAnimation.value,
          child: Text(
            vm.subHeader,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.white),
          ),
        ),
        ListTile(
          dense: true,
          tileColor: const Color(0xFFEFEFEF),
          title: Text(
            vm.subscriptionSubtitle,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(fontSize: 18.0.sp),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: kTealColor,
            size: 14.0.r,
          ),
          onTap: vm.onGoToSubscriptionHandler,
        ),
        SizedBox(height: 10.0.h),
        if (vm.stream != null)
          Container(
            height: 25.0.h, // MediaQuery.of(context).size.height * 0.04,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: vm.statuses.length,
              itemBuilder: (context, index) {
                final key = vm.statuses.keys.elementAt(index);
                return GestureDetector(
                  onTap: () => vm.changeIndex(key),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 3.0.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0.w,
                      vertical: 3.0.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0.r),
                      color: vm.selectedIndex == key
                          ? const Color(0xFFFFC700)
                          : const Color(0xFFEFEFEF),
                    ),
                    child: Text(
                      vm.statuses[key]!,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                );
              },
            ),
          ),
        SizedBox(height: 10.0),
        vm.stream != null
            ? Expanded(
                child: GroupedOrders(
                  vm.stream,
                  vm.initialStatuses,
                  vm.isBuyer,
                ),
              )
            : Expanded(
                child: Center(
                  child: Text(
                    vm.noOrderMessage,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
      ],
    );
  }
}
