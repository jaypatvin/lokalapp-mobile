import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';
import '../../../../app/app_router.dart';
import '../../../../models/failure_exception.dart';
import '../../../../models/post_requests/shop/shop_update.request.dart';
import '../../../../models/shop.dart';
import '../../../../providers/post_requests/operating_hours_body.dart';
import '../../../../providers/post_requests/shop_body.dart';
import '../../../../providers/shops.dart';
import '../../../../services/local_image_service.dart';
import '../../../../state/view_model.dart';
import '../../../../utils/constants/assets.dart';
import '../../../../utils/media_utility.dart';

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

  final Shop shop;

  bool _editedShopSchedule = false;

  String? _nameErrorText;
  String? get nameErrorText => _nameErrorText;

  String? _descriptionErrorText;
  String? get descriptionErrorText => _descriptionErrorText;

  String? _deliveryOptionErrorText;
  String? get deliveryOptionErrorText => _deliveryOptionErrorText;

  late bool _forDelivery;
  bool get forDelivery => _forDelivery;

  late bool _forPickup;
  bool get forPickup => _forPickup;

  final _appRouter = locator<AppRouter>();

  @override
  void init() {
    super.init();
    _shopName = shop.name;
    _shopDescription = shop.description;
    _isShopOpen = shop.status == ShopStatus.enabled;
    _forDelivery = shop.deliveryOptions.delivery;
    _forPickup = shop.deliveryOptions.pickup;

    context.read<ShopBody>()
      ..clear(notify: false)
      ..update(
        name: shop.name,
        description: shop.description,
        coverPhoto: shop.coverPhoto,
        profilePhoto: shop.profilePhoto,
        isClose: shop.isClose,
        status: shop.status,
        userId: shop.userId,
        paymentOptions: [...(shop.paymentOptions ?? const [])],
        deliveryOptions: shop.deliveryOptions,
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
    final status = _isShopOpen ? ShopStatus.enabled : ShopStatus.disabled;
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
    return context.read<Shops>().setOperatingHours(
          id: shop.id,
          request: operatingHoursBody.request,
        );
  }

  void onShopNameChanged(String value) {
    if (_nameErrorText?.isNotEmpty ?? false) {
      _nameErrorText = null;
    }
    _shopName = value;
    context.read<ShopBody>().update(name: value);
    notifyListeners();
  }

  void onShopDescriptionChange(String value) {
    if (_descriptionErrorText?.isNotEmpty ?? false) {
      _descriptionErrorText = null;
    }
    _shopDescription = value;
    context.read<ShopBody>().update(description: value);
    notifyListeners();
  }

  void onChangeShopSchedule() {
    _appRouter.navigateTo(
      AppRoute.profile,
      ProfileScreenRoutes.shopSchedule,
      arguments: ShopScheduleArguments(
        shopPhoto: shopPhoto,
        forEditing: true,
        onShopEdit: () {
          _editedShopSchedule = true;
          _appRouter.popUntil(
            AppRoute.profile,
            predicate: ModalRoute.withName(ProfileScreenRoutes.editShop),
          );
        },
      ),
    );
  }

  void onEditPaymentOptions() {
    _appRouter.navigateTo(
      AppRoute.profile,
      ProfileScreenRoutes.setUpPaymentOptions,
      arguments: SetUpPaymentOptionsArguments(
        onSubmit: () => _appRouter.popScreen(AppRoute.profile),
        edit: true,
      ),
    );
  }

  void onPickupTap() {
    if (_deliveryOptionErrorText?.isNotEmpty ?? false) {
      _deliveryOptionErrorText = null;
    }
    _forPickup = !_forPickup;
    context.read<ShopBody>().update(
          deliveryOptions: DeliveryOptions(
            delivery: _forDelivery,
            pickup: _forPickup,
          ),
        );

    notifyListeners();
  }

  void onDeliveryTap() {
    if (_deliveryOptionErrorText?.isNotEmpty ?? false) {
      _deliveryOptionErrorText = null;
    }
    _forDelivery = !_forDelivery;
    context.read<ShopBody>().update(
          deliveryOptions: DeliveryOptions(
            delivery: _forDelivery,
            pickup: _forPickup,
          ),
        );
    notifyListeners();
  }

  Future<bool> _updateShop() async {
    final shopBody = context.read<ShopBody>();
    final imageService = context.read<LocalImageService>();

    String? shopPhotoUrl = shopBody.profilePhoto;
    if (shopPhoto != null) {
      try {
        shopPhotoUrl = await imageService.uploadImage(
          file: shopPhoto!,
          src: kShopImagesSrc,
        );
      } catch (e) {
        shopPhotoUrl = shopBody.profilePhoto;
        showToast('Failed to upload Shop Photo. Try again.');
      }
    }

    var shopCoverPhotoUrl = shopBody.coverPhoto;
    if (shopCoverPhoto != null) {
      try {
        shopCoverPhotoUrl = await imageService.uploadImage(
          file: shopCoverPhoto!,
          src: kShopImagesSrc,
        );
      } catch (e) {
        shopCoverPhotoUrl = shopBody.coverPhoto;
        showToast('Failed to upload Shop Cover Photo. Try again.');
      }
    }

    shopBody.update(
      name: shopName,
      description: shopDescription,
      profilePhoto: shopPhotoUrl,
      coverPhoto: shopCoverPhotoUrl,
      status: isShopOpen ? ShopStatus.enabled : ShopStatus.enabled,
    );

    try {
      return context.read<Shops>().update(
            id: shop.id,
            request: ShopUpdateRequest(
              name: shopName,
              description: shopDescription,
              profilePhoto: shopPhotoUrl,
              coverPhoto: shopCoverPhotoUrl,
              status: isShopOpen ? ShopStatus.enabled : ShopStatus.disabled,
              paymentOptions: shopBody.request.paymentOptions,
            ),
          );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> _updateShopSchedule() async {
    try {
      final operatingHoursBody = context.read<OperatingHoursBody>();
      return context
          .read<Shops>()
          .setOperatingHours(id: shop.id, request: operatingHoursBody.request);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> onApplyChanges() async {
    try {
      if (_shopName.isEmpty) {
        _nameErrorText = 'Shop Name should not be empty';
      }
      if (_shopDescription.isEmpty) {
        _descriptionErrorText = 'Shop Description should not be empty';
      }
      if (!_forDelivery && !_forPickup) {
        _deliveryOptionErrorText =
            'At least one of the options must be selected.';
      }

      if (_nameErrorText != null ||
          _descriptionErrorText != null ||
          _deliveryOptionErrorText != null) {
        notifyListeners();
        return;
      }

      bool success = await _updateShop();
      if (!success) throw FailureException('Update shop error');

      if (_editedShopSchedule) {
        success = await _updateShopSchedule();
        if (!success) throw FailureException('Update operating hours error');
      }

      _appRouter.popScreen(AppRoute.profile);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }
}
