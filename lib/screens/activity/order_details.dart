import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/order.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/activity/order_details.vm.dart';
import '../../widgets/overlays/screen_loader.dart';
import 'components/order_details_buttons.dart';
import 'components/transaction_details.dart';

/// This Widget will display all states/conditions of the order details to avoid
/// code repetition.
class OrderDetails extends StatelessWidget {
  final bool isBuyer;
  final String subheader;
  final Order order;
  const OrderDetails({
    required this.order,
    this.isBuyer = true,
    this.subheader = '',
  });

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _OrderDetailsView(subheader: subheader),
      viewModel: OrderDetailsViewModel(order: order, isBuyer: isBuyer),
    );
  }
}

class _OrderDetailsView extends HookView<OrderDetailsViewModel>
    with HookScreenLoader {
  _OrderDetailsView({Key? key, this.subheader = ''}) : super(key: key);
  final String subheader;
  @override
  Widget screen(BuildContext context, OrderDetailsViewModel vm) {
    final _address = useMemoized<String>(() {
      final _address = vm.order.deliveryAddress;
      final _addressList = [
        _address.street,
        _address.barangay,
        _address.subdivision,
        _address.city,
      ];

      return _addressList.where((text) => text.isNotEmpty).join(', ');
    });

    final _instructions = useMemoized<String>(
      () => vm.order.instruction.isNotEmpty
          ? vm.order.instruction
          : 'No instructions.',
    );

    final _modeOfPayment = useMemoized<String>(() {
      if (vm.order.paymentMethod == PaymentMethod.bank) {
        return 'Bank Transfer/Deposit';
      } else if (vm.order.paymentMethod == PaymentMethod.eWallet) {
        return 'Wallet Transfer/Deposit';
      } else {
        return 'Cash on Delivery';
      }
    });

    final _textInfo = useMemoized<SizedBox>(
      () {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notes:',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                _instructions,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 16.0.h),
              Text(
                'Delivery Address:',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                _address,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 16.0.h),
              if (vm.order.statusCode >= 300)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mode of Payment: ',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Expanded(
                      child: Text(
                        _modeOfPayment,
                        style: Theme.of(context).textTheme.bodyText1,
                        // maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
      [_address],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: vm.isBuyer ? kTealColor : const Color(0xFF57183F),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Order Details',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Colors.white,
                  ),
            ),
            Visibility(
              visible: subheader.isNotEmpty,
              child: Text(
                subheader,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color:
                          vm.order.statusCode == 10 || vm.order.statusCode == 20
                              ? kOrangeColor
                              : Colors.white,
                    ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 16.0.h, left: 32.0.w, right: 32.0.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TransactionDetails(
                transaction: vm.order,
                isBuyer: vm.isBuyer,
              ),
              SizedBox(height: 12.0.h),
              _textInfo,
              SizedBox(height: 24.0.h),
              OrderDetailsButtons(
                statusCode: vm.order.statusCode,
                isBuyer: vm.isBuyer,
                order: vm.order,
                onPress: (action) async => performFuture(
                  () => vm.onPress(action),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
