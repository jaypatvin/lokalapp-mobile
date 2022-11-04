import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../models/failure_exception.dart';
import '../../../models/lokal_images.dart';
import '../../../models/lokal_user.dart';
import '../../../models/post_requests/shared/application_log.dart';
import '../../../models/product.dart';
import '../../../models/shop.dart';
import '../../../providers/auth.dart';
import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../providers/users.dart';
import '../../../routers/app_router.dart';
import '../../../routers/discover/product_detail.props.dart';
import '../../../screens/discover/product_detail.dart';
import '../../../screens/profile/add_product/add_product.dart';
import '../../../screens/profile/add_shop/edit_shop.dart';
import '../../../screens/profile/profile_screen.dart';
import '../../../screens/profile/settings/settings.dart';
import '../../../screens/profile/shop/report_shop.dart';
import '../../../services/application_logger.dart';
import '../../../state/view_model.dart';
import '../../../utils/constants/themes.dart';
import '../../../utils/functions.utils.dart';

class UserShopViewModel extends ViewModel {
  UserShopViewModel(this.userId, [this.shopId]);

  final String userId;
  final String? shopId;

  late final bool isCurrentUser;
  late final LokalUser? user;
  late Shop shop;

  late List<Product> _products;
  UnmodifiableListView<Product> get products {
    if (_searchTerm?.isNotEmpty ?? false) {
      return UnmodifiableListView(
        _products.where(
          (product) => product.name.toLowerCase().contains(
                _searchTerm!.toLowerCase(),
              ),
        ),
      );
    }

    return UnmodifiableListView(_products);
  }

  List<Color> get shopHeaderColors => isCurrentUser
      ? const [Color(0xffFFC700), Colors.black45]
      : const [kPinkColor, Colors.black45];

  bool get displaySettingsButton => isCurrentUser;
  bool get displayEditButton => isCurrentUser;

  String? _searchTerm;
  String? get searchTerm => _searchTerm;

  @override
  void init() {
    _shopSetup();
    isCurrentUser = context.read<Auth>().user!.id == userId;
    user = isCurrentUser
        ? context.read<Auth>().user
        : context.read<Users>().findById(userId);

    _products = context.read<Products>().findByShop(shop.id);

    if (!isCurrentUser) {
      context.read<ApplicationLogger>().log(
        actionType: ActionTypes.shopView,
        metaData: {'shop_id': shop.id},
      );
    }
  }

  void _shopSetup() {
    Shop? shop;

    if (shopId != null) {
      shop = context.read<Shops>().findById(shopId);
    }

    if (shopId == null && shop == null) {
      final shops = context.read<Shops>().findByUser(userId);
      if (shops.isEmpty) throw 'Error: no shop found.';

      shop = shops.first;
    }

    if (shop == null) throw FailureException('Error: no shop found.');
    this.shop = shop;
  }

  void refresh() {
    _shopSetup();
    notifyListeners();
  }

  void onSettingsTap() {
    AppRouter.profileNavigatorKey.currentState?.pushNamed(Settings.routeName);
  }

  void onEditTap() {
    AppRouter.profileNavigatorKey.currentState?.pushNamed(EditShop.routeName);
  }

  void onOptionsTap({Widget? options}) {
    if (options != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        useRootNavigator: true,
        builder: (_) => options,
      );
    }
  }

  Future<void> onReportShop({Widget? message}) async {
    if (message != null) {
      final response = await showModalBottomSheet<bool>(
        context: context,
        useRootNavigator: true,
        builder: (_) => message,
      );
      if (response == null || !response) {
        AppRouter.rootNavigatorKey.currentState?.pop();
        return;
      } else {
        AppRouter.rootNavigatorKey.currentState?.pop();
        final appRouter = context.read<AppRouter>();
        final route = appRouter.currentTabRoute;
        appRouter.pushDynamicScreen(
          route,
          AppNavigator.appPageRoute(
            builder: (_) => ReportShop(
              shopId: shop.id,
            ),
          ),
        );
      }
    }
  }

  void onShopPhotoTap() {
    if (shop.profilePhoto != null) {
      openGallery(
        context,
        0,
        [
          LokalImages(
            url: shop.profilePhoto!,
            order: 0,
          ),
        ],
      );
    }
  }

  void addProduct() {
    context
        .read<AppRouter>()
        .navigateTo(AppRoute.profile, AddProduct.routeName);
  }

  void goToProfile() {
    if (isCurrentUser) {
      context.read<AppRouter>()
        ..jumpToTab(AppRoute.profile)
        ..keyOf(AppRoute.profile).currentState?.popUntil(
              (route) => route.isFirst,
            );
    } else {
      final appRoute = context.read<AppRouter>().currentTabRoute;
      if (user != null) {
        context.read<AppRouter>().pushDynamicScreen(
              appRoute,
              AppNavigator.appPageRoute(
                builder: (_) => ProfileScreen(
                  userId: user!.id,
                ),
              ),
            );
      }
    }
  }

  void updateProducts() {
    final items = context.read<Products>().findByShop(shop.id);
    _products = [...items];
    notifyListeners();
  }

  void onProductTap(String id) {
    final product = _products.firstWhereOrNull((p) => p.id == id);
    if (product == null) throw 'Product does not exist!';
    if (isCurrentUser) {
      context.read<AppRouter>().navigateTo(
        AppRoute.profile,
        AddProduct.routeName,
        arguments: {'productId': product.id},
      );
      return;
    }
    context.read<AppRouter>().navigateTo(
          AppRoute.discover,
          ProductDetail.routeName,
          arguments: ProductDetailProps(product),
        );
  }

  void onSearchTermChanged(String? value) {
    if (_searchTerm == value) return;
    _searchTerm = value;
    notifyListeners();
  }
}
