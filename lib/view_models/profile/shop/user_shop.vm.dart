import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../app/app_router.dart';
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

  final _appRouter = locator<AppRouter>();

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
    Shop? _shop;

    if (shopId != null) {
      _shop = context.read<Shops>().findById(shopId);
    }

    if (shopId == null && _shop == null) {
      final _shops = context.read<Shops>().findByUser(userId);
      if (_shops.isEmpty) throw 'Error: no shop found.';

      _shop = _shops.first;
    }

    if (_shop == null) throw FailureException('Error: no shop found.');
    shop = _shop;
  }

  void refresh() {
    _shopSetup();
    notifyListeners();
  }

  void onSettingsTap() {
    _appRouter.navigateTo(AppRoute.profile, ProfileScreenRoutes.settings);
  }

  void onEditTap() {
    _appRouter.navigateTo(AppRoute.profile, ProfileScreenRoutes.editShop);
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
        isDismissible: true,
        builder: (_) => message,
      );
      if (response == null || !response) {
        _appRouter.popScreen(AppRoute.root);
        return;
      } else {
        _appRouter.popScreen(AppRoute.root);
        final _route = _appRouter.currentTabRoute;
        _appRouter.pushDynamicScreen(
          _route,
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
    _appRouter.navigateTo(
      AppRoute.profile,
      ProfileScreenRoutes.addProduct,
    );
  }

  void goToProfile() {
    if (isCurrentUser) {
      _appRouter
        ..jumpToTab(AppRoute.profile)
        ..popUntil(
          AppRoute.profile,
          predicate: (route) => route.isFirst,
        );
    } else {
      final appRoute = _appRouter.currentTabRoute;
      if (user != null) {
        _appRouter.pushDynamicScreen(
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
    final _items = context.read<Products>().findByShop(shop.id);
    _products = [..._items];
    notifyListeners();
  }

  void onProductTap(String id) {
    final product = _products.firstWhereOrNull((p) => p.id == id);
    if (product == null) throw 'Product does not exist!';
    if (isCurrentUser) {
      _appRouter.navigateTo(
        AppRoute.profile,
        ProfileScreenRoutes.addProduct,
        arguments: AddProductArguments(productId: product.id),
      );
      return;
    }
    _appRouter.navigateTo(
      AppRoute.discover,
      DiscoverRoutes.productDetail,
      arguments: ProductDetailArguments(product: product),
    );
  }

  void onSearchTermChanged(String? value) {
    if (_searchTerm == value) return;
    _searchTerm = value;
    notifyListeners();
  }
}
