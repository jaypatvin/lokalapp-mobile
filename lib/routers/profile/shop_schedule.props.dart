import 'dart:io';

class ShopScheduleProps {
  const ShopScheduleProps(
    this.shopPhoto, {
    this.forEditing = false,
    this.onShopEdit,
  });

  final File? shopPhoto;
  final bool forEditing;
  final Function()? onShopEdit;
}
