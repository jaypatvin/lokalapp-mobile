import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final Animation<Color?>? _colorAnimation;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => TransactionsViewModel(
        ctx,
        _statuses,
        isBuyer: _isBuyer,
      )..init(),
      builder: (ctx, _) {
        return Consumer<TransactionsViewModel>(
          builder: (ctx2, vm, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width,
                  color: _colorAnimation?.value,
                  child: Text(
                    vm.subHeader,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.white),
                  ),
                ),
                ListTile(
                  dense: true,
                  tileColor: const Color(0xFFEFEFEF),
                  title: Text(
                    vm.subscriptionSubtitle,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: kTealColor,
                    size: 14.0,
                  ),
                  onTap: vm.onGoToSubscriptionHandler,
                ),
                SizedBox(height: 10.0),
                if (vm.stream != null)
                  Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: vm.statuses.length,
                      itemBuilder: (context, index) {
                        final key = vm.statuses.keys.elementAt(index);
                        return GestureDetector(
                          onTap: () => vm.changeIndex(key),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 5.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: vm.selectedIndex == key
                                  ? const Color(0xFFFFC700)
                                  : const Color(0xFFEFEFEF),
                            ),
                            child: Text(
                              vm.statuses[key]!,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 10.0),
                vm.stream != null
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GroupedOrders(
                            vm.stream,
                            this._statuses,
                            this._isBuyer,
                          ),
                        ),
                      )
                    : Text(
                        vm.noOrderMessage,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            );
          },
        );
      },
    );
    //return Container();
  }
}
