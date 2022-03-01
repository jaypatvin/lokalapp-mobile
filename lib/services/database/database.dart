import 'collections/activities.collection.dart';
import 'collections/bank_codes.collection.dart';
import 'collections/categories.collection.dart';
import 'collections/chats.collection.dart';
import 'collections/community.collection.dart';
import 'collections/invites.collection.dart';
import 'collections/notification_types.collection.dart';
import 'collections/order_status.collection.dart';
import 'collections/orders.collection.dart';
import 'collections/product_subscription_plans.collection.dart';
import 'collections/products.collection.dart';
import 'collections/shops.collections.dart';
import 'collections/users.collection.dart';
import 'storage.dart' as lokal_storage;

enum Collection {
  activities,
  bankCodes,
  categories,
  chats,
  community,
  invites,
  notificationTypes,
  orderStatus,
  orders,
  productSubscriptionsPlans,
  products,
  shops,
  users,
}

extension CollectionPath on Collection {
  String get path {
    switch (this) {
      case Collection.activities:
        return 'activities';
      case Collection.bankCodes:
        return 'bank_codes';
      case Collection.categories:
        return 'categories';
      case Collection.chats:
        return 'chats';
      case Collection.community:
        return 'community';
      case Collection.invites:
        return 'invites';
      case Collection.notificationTypes:
        return 'notification_types';
      case Collection.orderStatus:
        return 'order_status';
      case Collection.orders:
        return 'orders';
      case Collection.productSubscriptionsPlans:
        return 'product_subscription_plans';
      case Collection.products:
        return 'products';
      case Collection.shops:
        return 'shops';
      case Collection.users:
        return 'users';
    }
  }
}

class Database {
  final activities = ActivitiesCollection(Collection.activities);

  final users = UsersCollection(Collection.users);

  final bankCodes = BankCodesCollection(Collection.bankCodes);

  final categories = CategoriesCollection(Collection.categories);

  final chats = ChatsCollection(Collection.chats);

  final community = CommunityCollection(Collection.community);

  final invites = InvitesCollection(Collection.invites);

  final notificationTypes =
      NotificationTypesCollection(Collection.notificationTypes);

  final orderStatus = OrderStatusCollection(Collection.orderStatus);

  final orders = OrdersCollection(Collection.orders);

  final productSubscriptionPlans =
      ProductSubscriptionPlansCollection(Collection.productSubscriptionsPlans);

  final products = ProductsCollection(Collection.products);

  final shops = ShopsCollection(Collection.shops);

  final storage = lokal_storage.Storage();
}
