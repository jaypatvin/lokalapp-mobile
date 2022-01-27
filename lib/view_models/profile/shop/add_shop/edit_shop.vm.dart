import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../../models/app_navigator.dart';
import '../../../../models/user_shop.dart';
import '../../../../providers/post_requests/operating_hours_body.dart';
import '../../../../providers/post_requests/shop_body.dart';
import '../../../../providers/shops.dart';
import '../../../../routers/app_router.dart';
import '../../../../routers/profile/props/payment_options.props.dart';
import '../../../../screens/profile/add_shop/edit_shop.dart';
import '../../../../screens/profile/add_shop/payment_options.dart';
import '../../../../screens/profile/add_shop/shop_schedule.dart';
import '../../../../services/local_image_service.dart';
import '../../../../state/view_model.dart';
import '../../../../utils/utility.dart';

class EditShopViewModel extends ViewModel {
  EditShopViewModel({required this.shop});

  late String _shopName;
  String get shopName => _shopName;

  late String _shopDescription;
  String get shopDescription => _shopDescription;

  File? _shopPhoto;
  File? get shopPhoto => _shopPhoto;

  File? _shopCoverPhoto;
  File? get shopCoverPhoto => _shopCoverPhoto;

  late bool _isShopOpen;
  bool get isShopOpen => _isShopOpen;

  final ShopModel shop;

  bool _editedShopSchedule = false;

  String? _errorNameText;
  String? get errorNameText => _errorNameText;

  @override
  void init() {
    super.init();
    _shopName = shop.name!;
    _shopDescription = shop.description ?? '';
    _isShopOpen = shop.status == 'enabled';

    context.read<ShopBody>()
      ..clear(notify: false)
      ..update(
        name: shop.name,
        description: shop.description,
        coverPhoto: shop.coverPhoto,
        profilePhoto: shop.profilePhoto,
        paymentOptions: [...(shop.paymentOptions ?? const [])],
        notify: false,
      );
    context.read<OperatingHoursBody>().clear(notify: false);
  }

  @override
  void onBuild() {
    super.onBuild();
    debugPrint('onBuild called');
  }

  void toggleButton() {
    _isShopOpen = !_isShopOpen;
    final status = _isShopOpen ? 'enabled' : 'disabled';
    context.read<ShopBody>().update(status: status);
  }

  Future<void> onShopPhotoPick() async {
    final photo = await context.read<MediaUtility>().showMediaDialog(context);
    _shopPhoto = photo;
    notifyListeners();
  }

  Future<void> onCoverPhotoPick() async {
    final photo = await context.read<MediaUtility>().showMediaDialog(context);
    _shopCoverPhoto = photo;
    notifyListeners();
  }

  Future<bool> updateShopSchedule() async {
    final operatingHoursBody = context.read<OperatingHoursBody>();
    return context
        .read<Shops>()
        .setOperatingHours(id: shop.id!, data: operatingHoursBody.data);
  }

  void onShopNameChanged(String value) {
    _shopName = value;
    if (errorNameText?.isNotEmpty ?? false) {
      _errorNameText = null;
    }
    context.read<ShopBody>().update(name: value);
    notifyListeners();
  }

  void onShopDescriptionChange(String value) {
    _shopDescription = value;
    context.read<ShopBody>().update(description: value);
    notifyListeners();
  }

  void onChangeShopSchedule() {
    AppRouter.profileNavigatorKey.currentState?.push(
      AppNavigator.appPageRoute(
        builder: (_) => ShopSchedule(
          shopPhoto: shopPhoto,
          forEditing: true,
          onShopEdit: () {
            _editedShopSchedule = true;
            Navigator.popUntil(
              context,
              ModalRoute.withName(
                EditShop.routeName,
              ),
            );
          },
        ),
      ),
    );
  }

  void onEditPaymentOptions() {
    AppRouter.profileNavigatorKey.currentState?.pushNamed(
      SetUpPaymentOptions.routeName,
      arguments: SetUpPaymentOptionsProps(
        onSubmit: () => AppRouter.profileNavigatorKey.currentState?.pop(),
        edit: true,
      ),
    );
  }

  Future<bool> _updateShop() async {
    final shopBody = context.read<ShopBody>();
    final imageService = context.read<LocalImageService>();

    var shopPhotoUrl = shopBody.profilePhoto;
    if (shopPhoto != null) {
      try {
        shopPhotoUrl = await imageService.uploadImage(
          file: shopPhoto!,
          name: 'shop-photo',
        );
      } catch (e) {
        shopPhotoUrl = shopBody.profilePhoto;
      }
    }

    var shopCoverPhotoUrl = shopBody.coverPhoto;
    if (shopCoverPhoto != null) {
      try {
        shopCoverPhotoUrl = await imageService.uploadImage(
          file: shopCoverPhoto!,
          name: 'shop-cover-photo',
        );
      } catch (e) {
        shopCoverPhotoUrl = shopBody.coverPhoto;
      }
    }

    shopBody.update(
      name: shopName,
      description: shopDescription,
      profilePhoto: shopPhotoUrl,
      coverPhoto: shopCoverPhotoUrl,
      status: isShopOpen ? 'enabled' : 'disabled',
    );

    return context.read<Shops>().update(id: shop.id!, data: shopBody.toMap());
  }

  Future<bool> _updateShopSchedule() async {
    final operatingHoursBody =
        Provider.of<OperatingHoursBody>(context, listen: false);
    return context
        .read<Shops>()
        .setOperatingHours(id: shop.id!, data: operatingHoursBody.data);
  }

  Future<void> onApplyChanges() async {
    try {
      if (shopName.isEmpty) {
        _errorNameText = 'Shop Name cannot be empty.';
        notifyListeners();
      }

      bool success = await _updateShop();
      if (!success) throw 'Update shop error';

      if (_editedShopSchedule) {
        success = await _updateShopSchedule();
        if (!success) throw 'Update operating hours error';
      }

      AppRouter.profileNavigatorKey.currentState?.pop();
    } catch (e) {
      showToast(e.toString());
    }
  }
}
