import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../providers/shops.dart';
import '../../../routers/app_router.dart';
import '../../../services/database.dart';
import '../../../state/view_model.dart';

class SubscriptionsViewModel extends ViewModel {
  SubscriptionsViewModel({required this.isBuyer});
  final bool isBuyer;

  Stream<QuerySnapshot<Map<String, dynamic>>>? stream;
  late final Database _db;

  @override
  void init() {
    _db = Database.instance;
    final user = context.read<Auth>().user!;

    if (isBuyer) {
      stream = _db.getUserSubscriptions(user.id);
    } else {
      final shops = context.read<Shops>().findByUser(user.id);
      if (shops.isNotEmpty) {
        final shop = shops.first;
        stream = _db.getShopSubscribers(shop.id);
      } else {
        context.read<Shops>().addListener(shopChangeListener);
      }
    }
  }

  void shopChangeListener() {
    final user = context.read<Auth>().user!;
    final shops = context.read<Shops>().findByUser(user.id);
    if (shops.isEmpty) return;

    stream = _db.getShopSubscribers(shops.first.id);
    context.read<Shops>().removeListener(shopChangeListener);
    notifyListeners();
  }

  void createShopHandler() {
    context.read<AppRouter>().jumpToTab(AppRoute.profile);
  }
}
