import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../providers/shops.dart';
import '../../../services/database.dart';
import '../../../state/view_model.dart';

class SubscriptionsViewModel extends ViewModel {
  SubscriptionsViewModel({required this.isBuyer});
  final bool isBuyer;

  late final Stream<QuerySnapshot<Map<String, dynamic>>> stream;
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
      }
    }
  }
}
