import 'package:flutter/material.dart';

import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/themes.dart';
import '../../utils/hooks/automatic_keep_alive.dart';
import '../../view_models/activity/transactions.vm.dart';
import '../../widgets/app_button.dart';
import '../../widgets/overlays/screen_loader.dart';
import '../../widgets/persistent_header_delegate_builder.dart';
import 'components/grouped_orders.dart';

class Transactions extends StatelessWidget {
  factory Transactions.isBuyer(
    Map<int, String?> statuses, {
    Color backgroundColor = kTealColor,
  }) {
    return Transactions._(
      statuses,
      true,
      backgroundColor,
    );
  }

  factory Transactions.isSeller(
    Map<int, String?> _statuses, {
    Color backgroundColor = kPurpleColor,
  }) {
    return Transactions._(
      _statuses,
      false,
      backgroundColor,
    );
  }

  const Transactions._(
    this._statuses,
    this._isBuyer,
    this._backgroundColor,
  );

  final Map<int, String?> _statuses;
  final bool _isBuyer;
  final Color _backgroundColor;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _TransactionsView(
        _backgroundColor,
      ),
      viewModel: TransactionsViewModel(
        _statuses,
        isBuyer: _isBuyer,
      ),
    );
  }
}

class _TransactionsView extends HookView<TransactionsViewModel>
    with HookScreenLoader {
  _TransactionsView(
    this._backgroundColor, {
    Key? key,
  }) : super(key: key);

  final Color _backgroundColor;
  @override
  Widget screen(BuildContext context, TransactionsViewModel vm) {
    useAutomaticKeepAlive();
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: PersistentHeaderDelegateBuilder(
            minHeight: 5.0,
            maxHeight: 5.0,
            child: SizedBox(
              height: 5.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _backgroundColor,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 37),
            width: MediaQuery.of(context).size.width,
            color: _backgroundColor,
            child: Text(
              vm.subHeader,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
        ),
        SliverPersistentHeader(
          floating: true,
          delegate: PersistentHeaderDelegateBuilder(
            // Sizes + padding of the children
            maxHeight: 29 + 20 + 60,
            minHeight: 29 + 20 + 60,
            child: SizedBox(
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      color: const Color(0xFFEFEFEF),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: vm.onGoToSubscriptionHandler,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              vm.subscriptionSubtitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(color: Colors.black),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: kTealColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 29 + 20,
                      color: Colors.white,
                      padding: const EdgeInsets.only(top: 20),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: vm.statuses.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final key = vm.statuses.keys.elementAt(index);
                          final _keyString =
                              '${vm.isBuyer ? "buyer" : "seller"}_status_$key';
                          return GestureDetector(
                            onTap: () => vm.changeIndex(key),
                            key: Key(_keyString),
                            child: Container(
                              key: Key(_keyString),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: vm.selectedIndex == key
                                    ? const Color(0xFFFFC700)
                                    : const Color(0xFFEFEFEF),
                              ),
                              child: Center(
                                child: Text(
                                  vm.statuses[key]!,
                                  key: Key(_keyString),
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (vm.stream != null)
          GroupedOrders(
            stream: vm.stream,
            statuses: vm.initialStatuses,
            isBuyer: vm.isBuyer,
            onSecondButtonPressed: vm.onSecondButtonPress,
          ),
        if (vm.stream == null)
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  vm.noOrderMessage,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 10),
                if (vm.shop == null && !vm.isBuyer)
                  AppButton.transparent(
                    text: 'Create Shop',
                    color: kPurpleColor,
                    onPressed: vm.createShopHandler,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
