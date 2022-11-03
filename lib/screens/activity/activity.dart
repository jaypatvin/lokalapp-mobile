import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../services/database/database.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import 'transactions.dart';

class Activity extends HookWidget {
  static const routeName = '/activity';
  const Activity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabColor = useState<Color?>(kTealColor);
    final buyerStatuses = useRef(<int, String?>{});
    final sellerStatuses = useRef(<int, String?>{});

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 250),
    );
    final colorAnimation = ColorTween(
      begin: kTealColor,
      end: kPurpleColor,
    ).animate(animationController);

    colorAnimation.addListener(() => tabColor.value = colorAnimation.value);
    final tabController = useTabController(initialLength: 2);
    final tabSelectionHandler = useCallback(
      () {
        if (animationController.isAnimating) return;
        animationController.animateTo(tabController.animation!.value);
      },
      [tabController, animationController],
    );

    tabController.animation?.addListener(tabSelectionHandler);

    final future = useMemoized(
      () async => context.read<Database>().orderStatus.getOrderStatuses(),
    );
    final snapshot = useFuture(future);

    if (snapshot.connectionState != ConnectionState.done || snapshot.hasError) {
      return SizedBox.expand(
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
      final dataMap = doc.data();
      buyerStatuses.value[statusCode] = dataMap['buyer_status'];
      sellerStatuses.value[statusCode] = dataMap['seller_status'];
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1FAFF),
        elevation: 0,
        bottom: TabBar(
          controller: tabController,
          unselectedLabelColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          indicator: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
            color: tabColor.value,
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
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: Colors.black),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Transactions.isBuyer(
            buyerStatuses.value,
          ),
          Transactions.isSeller(
            sellerStatuses.value,
          ),
        ],
      ),
    );
  }
}
