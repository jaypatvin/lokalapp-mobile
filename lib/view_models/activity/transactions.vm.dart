import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/app_navigator.dart';
import '../../models/order.dart';
import '../../models/user_shop.dart';
import '../../providers/auth.dart';
import '../../providers/shops.dart';
import '../../routers/app_router.dart';
import '../../screens/activity/buyer/order_received.dart';
import '../../screens/activity/buyer/payment_option.dart';
import '../../screens/activity/order_details.dart';
import '../../screens/activity/seller/order_confirmed.dart';
import '../../screens/activity/seller/payment_confirmed.dart';
import '../../screens/activity/seller/shipped_out.dart';
import '../../screens/activity/subscriptions/subscriptions.dart';
import '../../services/api/api.dart';
import '../../services/api/order_api_service.dart';
import '../../services/database.dart';
import '../../state/view_model.dart';

class TransactionsViewModel extends ViewModel {
  TransactionsViewModel(
    this.initialStatuses, {
    this.isBuyer = true,
  });

  final Map<int, String?> initialStatuses;
  final bool isBuyer;
  late final OrderAPIService _apiService;

  final _statuses = <int, String?>{};
  UnmodifiableMapView<int, String?> get statuses =>
      UnmodifiableMapView(_statuses);

  final Map<int, Stream<QuerySnapshot>> _streams = {};
  UnmodifiableMapView<int, Stream<QuerySnapshot>> get streams =>
      UnmodifiableMapView(_streams);

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  Stream<QuerySnapshot>? _stream;
  Stream<QuerySnapshot>? get stream => _stream;

  late final String subHeader;
  late final String subscriptionSubtitle;
  late final String noOrderMessage;

  // final String noOrderMessage = 'You have no orders yet!';

  final _db = Database.instance;

  ShopModel? shop;

  @override
  void init() {
    _initializeStatuses();
    _selectedIndex = _statuses.keys.first;
    _initializeStreams();
    _stream = _streams[_selectedIndex];
    _apiService = OrderAPIService(context.read<API>());

    subHeader = isBuyer
        ? 'These are the products you ordered from other stores.'
        : 'These are the products other people ordered from your stores.';
    subscriptionSubtitle = isBuyer ? 'Subscriptions' : 'Subscriber Orders';

    noOrderMessage = shop != null || isBuyer
        ? 'You have no orders yet!'
        : 'You have not created a shop yet!';
  }

  void _initializeStatuses() {
    final _statusCodes = initialStatuses.keys.toList().map((key) {
      if (key == 10 || key == 20) {
        // We're multiplying statuses 10 and 20 (cancelled & declined orders)
        // by 100 to put them in the bottom of the list (after sorting).
        // This will make it easier to display each statuses as filters on top
        // from the most urgent to the least
        key *= 100;
      }
      return key;
    }).toList()
      ..sort();

    _statuses[0] = 'All';
    for (final code in _statusCodes) {
      // Reverse the multiplication from above to get the correct string value
      // from the firestore collection of statuses
      final _key = (code == 1000 || code == 2000) ? code ~/ 100 : code;
      _statuses[code] = initialStatuses[_key];
    }
  }

  void _initializeStreams() {
    final userId = context.read<Auth>().user!.id;
    if (!isBuyer) {
      final shops = context.read<Shops>().findByUser(userId);
      if (shops.isEmpty) {
        context.read<Shops>().addListener(shopChangeListener);
        return;
      }

      shopChangeListener(notify: false);
    }

    for (final key in _statuses.keys) {
      final statusCode = (key == 1000 || key == 2000) ? key ~/ 100 : key;
      _streams[key] = _db.getUserOrders(
        userId,
        statusCode: statusCode == 0 ? null : statusCode,
      );
    }
  }

  void shopChangeListener({bool notify = true}) {
    final userId = context.read<Auth>().user!.id;
    final shops = context.read<Shops>().findByUser(userId);
    if (shops.isEmpty) return;

    final shopId = shops.first.id;

    for (final key in _statuses.keys) {
      final statusCode = (key == 1000 || key == 2000) ? key ~/ 100 : key;

      _streams[key] = _db.getShopOrders(
        shopId,
        statusCode: statusCode == 0 ? null : statusCode,
      );
    }

    context.read<Shops>().removeListener(shopChangeListener);
    if (notify) notifyListeners();
  }

  void changeIndex(int key) {
    if (key == selectedIndex) return;

    _selectedIndex = key;
    _stream = _streams[key];

    notifyListeners();
  }

  void onGoToSubscriptionHandler() {
    AppRouter.activityNavigatorKey.currentState?.push(
      AppNavigator.appPageRoute(
        builder: (_) => Subscriptions(isBuyer: isBuyer),
      ),
    );
  }

  void createShopHandler() {
    context.read<AppRouter>().jumpToTab(AppRoute.profile);
  }

  Future<void> onSecondButtonPress(Order order) async {
    try {
      if (isBuyer) {
        switch (order.statusCode) {
          case 200:
            AppRouter.activityNavigatorKey.currentState?.push(
              AppNavigator.appPageRoute(
                builder: (_) => PaymentOptionScreen(order: order),
              ),
            );
            break;
          case 500:
            final success = await _apiService.receive(orderId: order.id!);
            if (success) {
              AppRouter.activityNavigatorKey.currentState?.push(
                AppNavigator.appPageRoute(
                  builder: (_) => OrderReceived(order: order),
                ),
              );
            }

            break;
          default:
            break;
        }
      } else {
        switch (order.statusCode) {
          case 100:
            final success = await _apiService.confirm(orderId: order.id!);
            if (success) {
              AppRouter.activityNavigatorKey.currentState?.push(
                AppNavigator.appPageRoute(
                  builder: (_) => OrderConfirmed(
                    order: order,
                    isBuyer: isBuyer,
                  ),
                ),
              );
            }
            break;
          case 300:
            if (order.paymentMethod == 'cod') {
              final success =
                  await _apiService.confirmPayment(orderId: order.id!);
              if (success) {
                AppRouter.activityNavigatorKey.currentState?.push(
                  AppNavigator.appPageRoute(
                    builder: (_) => PaymentConfirmed(order: order),
                  ),
                );
              }
            } else {
              AppRouter.activityNavigatorKey.currentState?.push(
                AppNavigator.appPageRoute(
                  builder: (_) => OrderDetails(
                    order: order,
                    isBuyer: isBuyer,
                  ),
                ),
              );
            }
            break;
          case 400:
            final success = await _apiService.shipOut(orderId: order.id!);
            if (success) {
              AppRouter.activityNavigatorKey.currentState?.push(
                AppNavigator.appPageRoute(
                  builder: (_) => ShippedOut(order: order),
                ),
              );
            }
            break;
          default:
            // do nothing
            break;
        }
      }
    } catch (_) {
      showToast('Error performing task. Please try again.');
    }
  }
}
