import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

import '../../services/database.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import 'transactions.dart';

class Activity extends HookWidget {
  static const routeName = '/activity';
  const Activity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _tabColor = useState<Color?>(kTealColor);
    final _buyerStatuses = useRef(<int, String?>{});
    final _sellerStatuses = useRef(<int, String?>{});

    final _animationController = useAnimationController(
      duration: const Duration(milliseconds: 250),
    );
    final _colorAnimation = ColorTween(
      begin: kTealColor,
      end: kPurpleColor,
    ).animate(_animationController);

    _colorAnimation.addListener(() => _tabColor.value = _colorAnimation.value);
    final _tabController = useTabController(initialLength: 2);
    final _tabSelectionHandler = useCallback(
      () {
        if (_animationController.isAnimating) return;
        _animationController.animateTo(_tabController.animation!.value);
      },
      [_tabController, _animationController],
    );

    _tabController.animation?.addListener(_tabSelectionHandler);

    final future = useMemoized(
      () async => Database.instance.getOrderStatuses().get(),
    );
    final snapshot = useFuture(future);

    if (snapshot.connectionState != ConnectionState.done || snapshot.hasError) {
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
    }

    for (final doc in snapshot.data!.docs) {
      final statusCode = int.parse(doc.id);
      final dataMap = doc.data()! as Map<String, dynamic>;
      _buyerStatuses.value[statusCode] = dataMap['buyer_status'];
      _sellerStatuses.value[statusCode] = dataMap['seller_status'];
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1FAFF),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          indicator: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30.0),
            ),
            color: _tabColor.value,
          ),
          labelStyle: Theme.of(context).textTheme.headline6,
          tabs: const [
            Tab(text: 'My Orders'),
            Tab(text: 'My Shop'),
          ],
        ),
        title: Center(
          child: Text(
            'Activity',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Transactions.isBuyer(
            _buyerStatuses.value,
          ),
          Transactions.isSeller(
            _sellerStatuses.value,
          ),
        ],
      ),
    );
  }
}
