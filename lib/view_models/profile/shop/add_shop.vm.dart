import 'dart:io';

import 'package:provider/provider.dart';

import '../../../models/shop.dart';
import '../../../providers/post_requests/shop_body.dart';
import '../../../routers/app_router.dart';
import '../../../routers/profile/props/shop_schedule.props.dart';
import '../../../screens/profile/add_shop/shop_schedule.dart';
import '../../../state/view_model.dart';
import '../../../utils/media_utility.dart';

class AddShopViewModel extends ViewModel {
  AddShopViewModel({required this.mediaUtility});
  final MediaUtility mediaUtility;

  File? _shopPhoto;
  File? get shopPhoto => _shopPhoto;

  String _name = '';
  String get name => _name;

  String _description = '';
  String get description => _description;

  String? _nameErrorText;
  String? get nameErrorText => _nameErrorText;

  String? _descriptionErrorText;
  String? get descriptionErrorText => _descriptionErrorText;

  String? _deliveryOptionErrorText;
  String? get deliveryOptionErrorText => _deliveryOptionErrorText;

  bool _forDelivery = true;
  bool get forDelivery => _forDelivery;

  bool _forPickup = true;
  bool get forPickup => _forPickup;

  Future<void> onAddPhoto() async {
    _shopPhoto = await mediaUtility.showMediaDialog(context);
    notifyListeners();
  }

  void onNameChanged(String value) {
    if (_nameErrorText?.isNotEmpty ?? false) {
      _nameErrorText = null;
    }
    _name = value;
    context.read<ShopBody>().update(name: value);
    notifyListeners();
  }

  void onPickupTap() {
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
    _forDelivery = !_forDelivery;
    context.read<ShopBody>().update(
          deliveryOptions: DeliveryOptions(
            delivery: _forDelivery,
            pickup: _forPickup,
          ),
        );
    notifyListeners();
  }

  void onDescriptionChanged(String value) {
    if (_descriptionErrorText?.isNotEmpty ?? false) {
      _descriptionErrorText = null;
    }
    _description = value;
    context.read<ShopBody>().update(description: value);
    notifyListeners();
  }

  void onSubmit() {
    if (_name.isEmpty) {
      _nameErrorText = 'Shop Name should not be empty';
    }
    if (_description.isEmpty) {
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

    AppRouter.profileNavigatorKey.currentState?.pushNamed(
      ShopSchedule.routeName,
      arguments: ShopScheduleProps(_shopPhoto),
    );
  }
}
