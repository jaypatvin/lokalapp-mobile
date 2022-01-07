import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final padding = height * 0.05;

    final buttonWidth = 90.0.w;
    final buttonHeight = 40.0.h;

    final _isAnimating = useState<bool>(false);

    final _shopNameController = useTextEditingController();
    final _shopDescController = useTextEditingController();

    useEffect(
      () {
        _shopNameController.text = vm.shopName;
        _shopDescController.text = vm.shopDescription;

        void _nameListener() => vm.onShopNameChanged(_shopNameController.text);

        void _descriptionListener() =>
            vm.onShopDescriptionChange(_shopDescController.text);

        _shopNameController.addListener(_nameListener);
        _shopDescController.addListener(_descriptionListener);

        return () {
          _shopNameController.removeListener(_nameListener);
          _shopDescController.removeListener(_descriptionListener);
        };
      },
      [],
    );

    final _nameNode = useFocusNode();
    final _descriptionNode = useFocusNode();

    final _kbActionsRef = useRef(
      KeyboardActionsConfig(
        keyboardBarColor: Colors.grey.shade200,
        actions: [
          KeyboardActionsItem(
            focusNode: _nameNode,
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
            focusNode: _descriptionNode,
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
      appBar: CustomAppBar(
        titleText: 'Edit Shop',
        onPressedLeading: () {
          Navigator.pop(context);
        },
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0.w,
              vertical: 10.0.h,
            ),
            color: const Color(0XFFF1FAFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shop Status',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                InkWell(
                  onTap: () {
                    _isAnimating.value = true;
                    vm.toggleButton();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 1),
                    height: buttonHeight,
                    width: buttonWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0.r),
                      color: vm.isShopOpen ? kTealColor : kPinkColor,
                    ),
                    child: Stack(
                      children: [
                        Visibility(
                          visible: !_isAnimating.value,
                          child: Padding(
                            padding: vm.isShopOpen
                                ? EdgeInsets.only(left: buttonWidth * 0.10)
                                : EdgeInsets.only(right: buttonWidth * 0.10),
                            child: Align(
                              alignment: vm.isShopOpen
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Text(
                                vm.isShopOpen ? 'Open' : 'Closed',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          onEnd: () => _isAnimating.value = false,
                          duration: const Duration(milliseconds: 300),
                          height: buttonHeight,
                          left: vm.isShopOpen ? buttonWidth * 0.6 : 0.0,
                          right: vm.isShopOpen ? 0.0 : buttonWidth * 0.6,
                          child: Icon(
                            Icons.circle,
                            color: Colors.white,
                            size: buttonHeight * 0.8,
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
              config: _kbActionsRef.value,
              tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Basic Information',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  _ShopPhotoSection(
                    shopPhoto: vm.shopPhoto,
                    shopCoverPhoto: vm.shopCoverPhoto,
                    onShopPhotoPick: vm.onShopPhotoPick,
                    shopPhotoUrl: vm.shop.profilePhoto,
                    shopCoverPhotoUrl: vm.shop.coverPhoto,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  InkWell(
                    onTap: vm.onCoverPhotoPick,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          MdiIcons.squareEditOutline,
                          size: 18.0.sp,
                          color: kTealColor,
                        ),
                        Text(
                          'Edit Cover Photo',
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    decoration: TextDecoration.underline,
                                    color: kTealColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: InputNameField(
                      controller: _shopNameController,
                      hintText: 'Shop Name',
                      errorText: vm.errorNameText,
                      focusNode: _nameNode,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: InputDescriptionField(
                      controller: _shopDescController,
                      hintText: 'Shop Description',
                      focusNode: _descriptionNode,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  SizedBox(
                    width: width * 0.8,
                    child: AppButton(
                      'Change Shop Schedule',
                      kTealColor,
                      false,
                      vm.onChangeShopSchedule,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.8,
                    child: AppButton(
                      'Edit Payment Options',
                      kTealColor,
                      false,
                      vm.onEditPaymentOptions,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  SizedBox(
                    width: width * 0.6,
                    child: AppButton(
                      'Apply Changes',
                      kTealColor,
                      true,
                      () async => performFuture<void>(vm.onApplyChanges),
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
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * 0.25,
      child: Stack(
        children: [
          Center(
            child: PhotoBox(
              file: shopCoverPhoto,
              shape: BoxShape.rectangle,
              width: double.infinity,
              height: height * 0.25,
              url: shopCoverPhotoUrl,
              displayBorder: false,
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: onShopPhotoPick,
              child: Stack(
                children: [
                  PhotoBox(
                    height: 140.0,
                    file: shopPhoto,
                    shape: BoxShape.circle,
                    url: shopPhotoUrl,
                  ),
                  Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.30),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            MdiIcons.squareEditOutline,
                            size: 18.0.sp,
                            color: Colors.white,
                          ),
                          Text(
                            'Edit Photo',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
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
