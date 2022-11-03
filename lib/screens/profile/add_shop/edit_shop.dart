import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../providers/shops.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/profile/shop/add_shop/edit_shop.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_checkbox.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/inputs/input_description_field.dart';
import '../../../widgets/inputs/input_name_field.dart';
import '../../../widgets/overlays/screen_loader.dart';
import '../../../widgets/photo_box.dart';

class EditShop extends StatelessWidget {
  static const routeName = '/profile/shop/edit';
  const EditShop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM<EditShopViewModel>(
      view: (_, __) => _EditShopView(),
      viewModel: EditShopViewModel(
        shop: context
            .read<Shops>()
            .findByUser(context.read<Auth>().user!.id)
            .first,
      ),
    );
  }
}

class _EditShopView extends HookView<EditShopViewModel>
    with HookScreenLoader<EditShopViewModel> {
  _EditShopView({Key? key, bool reactive = true})
      : super(key: key, reactive: reactive);

  @override
  Widget screen(BuildContext context, EditShopViewModel vm) {
    final themeData = Theme.of(context);
    const padding = 45.0;

    final isAnimating = useState<bool>(false);

    final shopNameController = useTextEditingController();
    final shopDescController = useTextEditingController();

    useEffect(
      () {
        shopNameController.text = vm.shopName;
        shopDescController.text = vm.shopDescription;

        void nameListener() => vm.onShopNameChanged(shopNameController.text);

        void descriptionListener() =>
            vm.onShopDescriptionChange(shopDescController.text);

        shopNameController.addListener(nameListener);
        shopDescController.addListener(descriptionListener);

        return () {
          shopNameController.removeListener(nameListener);
          shopDescController.removeListener(descriptionListener);
        };
      },
      [],
    );

    final nameNode = useFocusNode();
    final descriptionNode = useFocusNode();

    final kbActionsRef = useRef(
      KeyboardActionsConfig(
        keyboardBarColor: Colors.grey.shade200,
        actions: [
          KeyboardActionsItem(
            focusNode: nameNode,
            toolbarButtons: [
              (node) {
                return TextButton(
                  onPressed: () => node.unfocus(),
                  child: Text(
                    'Done',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                );
              },
            ],
          ),
          KeyboardActionsItem(
            focusNode: descriptionNode,
            toolbarButtons: [
              (node) {
                return TextButton(
                  onPressed: () => node.unfocus(),
                  child: Text(
                    'Done',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                );
              },
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: const CustomAppBar(titleText: 'Edit Shop'),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0XFFF1FAFF),
            height: 54,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shop Status',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                InkWell(
                  onTap: () {
                    isAnimating.value = true;
                    vm.toggleButton();
                  },
                  child: AnimatedContainer(
                    width: 88,
                    duration: const Duration(milliseconds: 1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36.5),
                      color: vm.isShopOpen ? kTealColor : kPinkColor,
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: vm.isShopOpen
                              ? const EdgeInsets.only(
                                  left: 88 * 0.10,
                                )
                              : const EdgeInsets.only(
                                  right: 88 * 0.10,
                                ),
                          child: Align(
                            alignment: vm.isShopOpen
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Text(
                              vm.isShopOpen ? 'Open' : 'Closed',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          onEnd: () => isAnimating.value = false,
                          duration: const Duration(milliseconds: 300),
                          height: 30,
                          left: vm.isShopOpen ? 88 * 0.6 : 0.0,
                          right: vm.isShopOpen ? 0.0 : 88 * 0.6,
                          child: Icon(
                            Icons.circle,
                            color: Colors.white,
                            size: 30 * 0.8,
                            key: UniqueKey(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: KeyboardActions(
              config: kbActionsRef.value,
              tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'Basic Information',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 33),
                  _ShopPhotoSection(
                    shopPhoto: vm.shopPhoto,
                    shopCoverPhoto: vm.shopCoverPhoto,
                    onShopPhotoPick: vm.onShopPhotoPick,
                    shopPhotoUrl: vm.shop.profilePhoto,
                    shopCoverPhotoUrl: vm.shop.coverPhoto,
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: vm.onCoverPhotoPick,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (vm.shopCoverPhoto != null ||
                            (vm.shop.coverPhoto?.isNotEmpty ?? false)) ...[
                          const Icon(
                            MdiIcons.squareEditOutline,
                            color: kTealColor,
                          ),
                          Text(
                            'Edit Cover Photo',
                            style:
                                Theme.of(context).textTheme.subtitle2?.copyWith(
                                      decoration: TextDecoration.underline,
                                      color: kTealColor,
                                    ),
                          ),
                        ] else
                          Text(
                            '+ Add a Cover Photo',
                            style:
                                Theme.of(context).textTheme.subtitle2?.copyWith(
                                      decoration: TextDecoration.underline,
                                      color: kTealColor,
                                    ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: padding),
                    child: InputNameField(
                      controller: shopNameController,
                      hintText: 'Shop Name',
                      errorText: vm.nameErrorText,
                      focusNode: nameNode,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: padding),
                    child: InputDescriptionField(
                      controller: shopDescController,
                      hintText: 'Shop Description',
                      errorText: vm.descriptionErrorText,
                      focusNode: descriptionNode,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: padding),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Delivery Options',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: padding),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: AppCheckBox(
                            value: vm.forPickup,
                            onTap: vm.onPickupTap,
                            title: const Text(
                              'Customer Pick-up',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: AppCheckBox(
                            value: vm.forDelivery,
                            onTap: vm.onDeliveryTap,
                            title: const Text(
                              'Delivery',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (vm.deliveryOptionErrorText != null)
                    Text(
                      vm.deliveryOptionErrorText!,
                      style: themeData.textTheme.caption!
                          .copyWith(color: themeData.errorColor),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: padding,
                      vertical: 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: AppButton.transparent(
                            text: 'Change Shop Schedule',
                            onPressed: vm.onChangeShopSchedule,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: AppButton.transparent(
                            text: 'Edit Payment Options',
                            onPressed: vm.onEditPaymentOptions,
                          ),
                        ),
                        const SizedBox(height: 24),
                        AppButton.filled(
                          text: 'Apply Changes',
                          onPressed: () async =>
                              performFuture<void>(vm.onApplyChanges),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopPhotoSection extends StatelessWidget {
  final File? shopCoverPhoto;
  final File? shopPhoto;
  final String? shopCoverPhotoUrl;
  final String? shopPhotoUrl;
  final void Function()? onShopPhotoPick;
  const _ShopPhotoSection({
    Key? key,
    this.shopCoverPhoto,
    this.shopPhoto,
    this.shopCoverPhotoUrl,
    this.shopPhotoUrl,
    this.onShopPhotoPick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Stack(
        children: [
          Center(
            child: PhotoBox(
              imageSource: PhotoBoxImageSource(
                file: shopCoverPhoto,
                url: shopCoverPhotoUrl,
              ),
              shape: BoxShape.rectangle,
              width: double.infinity,
              height: 130,
              displayBorder: false,
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: onShopPhotoPick,
              child: Stack(
                children: [
                  PhotoBox(
                    imageSource: PhotoBoxImageSource(
                      file: shopPhoto,
                      url: shopPhotoUrl,
                    ),
                    height: 130.0,
                    width: 130.0,
                    shape: BoxShape.circle,
                  ),
                  if (shopPhoto != null || (shopPhotoUrl?.isNotEmpty ?? false))
                    Container(
                      width: 130.0,
                      height: 130.0,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.30),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              MdiIcons.squareEditOutline,
                              color: Colors.white,
                            ),
                            Text(
                              'Edit Photo',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
