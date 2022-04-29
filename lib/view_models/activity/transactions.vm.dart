import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../models/order.dart';
import '../../models/shop.dart';
import '../../providers/auth.dart';
import '../../providers/shops.dart';
import '../../services/api/api.dart';
import '../../services/api/order_api.dart';
import '../../services/database/collections/orders.collection.dart';
import '../../services/database/database.dart';
import '../../state/view_model.dart';

class TransactionsViewModel extends ViewModel {
  TransactionsViewModel(
    this.initialStatuses, {
    this.isBuyer = true,
  });

  final Map<int, String?> initialStatuses;
  final bool isBuyer;
  final OrderAPI _apiService = locator<OrderAPI>();

  final _statuses = <int, String?>{};
  UnmodifiableMapView<int, String?> get statuses =>
      UnmodifiableMapView(_statuses);

  final Map<int, Stream<QuerySnapshot<Map<String, dynamic>>>> _streams = {};
  UnmodifiableMapView<int, Stream<QuerySnapshot>> get streams =>
      UnmodifiableMapView(_streams);

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  Stream<QuerySnapshot<Map<String, dynamic>>>? _stream;
  Stream<QuerySnapshot<Map<String, dynamic>>>? get stream => _stream;

  late final String subHeader;
  late final String subscriptionSubtitle;
  late final String noOrderMessage;

  final OrdersCollection _db = locator<Database>().orders;

  final _appRouter = locator<AppRouter>();

  Shop? shop;

  @override
  void init() {
    _initializeStatuses();
    _selectedIndex = _statuses.keys.first;
    _initializeStreams();
    _stream = _streams[_selectedIndex];

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
      return;
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
    _appRouter.navigateTo(
      AppRoute.activity,
      ActivityRoutes.subscriptions,
      arguments: SubscriptionsArguments(isBuyer: isBuyer),
    );
  }

  void createShopHandler() {
    locator<AppRouter>().jumpToTab(AppRoute.profile);
  }

  Future<void> onSecondButtonPress(Order order) async {
    try {
      if (isBuyer) {
        switch (order.statusCode) {
          case 200:
            _appRouter.navigateTo(
              AppRoute.activity,
              ActivityRoutes.paymentOptionScreen,
              arguments: PaymentOptionScreenArguments(order: order),
            );
            break;
          case 500:
            final success = await _apiService.receive(orderId: order.id);
            if (success) {
              _appRouter.navigateTo(
                AppRoute.activity,
                ActivityRoutes.orderReceived,
                arguments: OrderReceivedArguments(order: order),
              );
            }
            break;
          case 600:
            if (order.products.any((product) => product.reviewId == null)) {
              _appRouter.navigateTo(
                AppRoute.activity,
                ActivityRoutes.reviewOrder,
                arguments: ReviewOrderArguments(order: order),
              );
            } else {
              _appRouter.navigateTo(
                AppRoute.activity,
                ActivityRoutes.viewReviews,
                arguments: ViewReviewsArguments(order: order),
              );
            }
            break;
          default:
            break;
        }
      } else {
        switch (order.statusCode) {
          case 100:
            final success = await _apiService.confirm(orderId: order.id);
            if (success) showToast('Order Confirmed');
            break;
          case 300:
            if (order.paymentMethod == PaymentMethod.cod) {
              final success =
                  await _apiService.confirmPayment(orderId: order.id);
              if (success) showToast('Payment Confirmed');
            } else {
              _appRouter.navigateTo(
                AppRoute.activity,
                ActivityRoutes.orderDetails,
                arguments: OrderDetailsArguments(
                  order: order,
                  isBuyer: isBuyer,
                ),
              );
            }
            break;
          case 400:
            final success = await _apiService.shipOut(orderId: order.id);
            if (success) showToast('Order has been shipped out.');
            break;
          default:
            // do nothing
            break;
        }
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast('Error performing task. Please try again.');
    }
  }
}
