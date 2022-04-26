import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/media_utility.dart';
import '../../../view_models/profile/shop/add_shop.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_checkbox.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/inputs/input_description_field.dart';
import '../../../widgets/inputs/input_name_field.dart';
import '../../../widgets/overlays/constrained_scrollview.dart';
import '../../../widgets/photo_box.dart';

class AddShop extends StatelessWidget {
  const AddShop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _AddShopView(),
      viewModel: AddShopViewModel(
        mediaUtility: context.read<MediaUtility>(),
      ),
    );
  }
}

class _AddShopView extends HookView<AddShopViewModel> {
  @override
  Widget render(BuildContext context, AddShopViewModel viewModel) {
    final themeData = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final padding = height * 0.05;

    final _nameFocusNode = useFocusNode();
    final _descriptionFocusNode = useFocusNode();

    final _kbConfig = useMemoized(() {
      return KeyboardActionsConfig(
        keyboardBarColor: Colors.grey.shade200,
        actions: [
          KeyboardActionsItem(
            focusNode: _nameFocusNode,
            toolbarButtons: [
              (node) {
                return TextButton(
                  onPressed: () => node.unfocus(),
                  child: Text(
                    'Done',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                );
              },
            ],
          ),
          KeyboardActionsItem(
            focusNode: _descriptionFocusNode,
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
      );
    });

    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Add Shop',
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: ConstrainedScrollView(
        child: KeyboardActions(
          config: _kbConfig,
          disableScroll: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 40),
              Text(
                'Basic Information',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 33),
              GestureDetector(
                onTap: viewModel.onAddPhoto,
                child: PhotoBox(
                  imageSource: PhotoBoxImageSource(file: viewModel.shopPhoto),
                  shape: BoxShape.circle,
                  width: 130,
                  height: 130,
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: InputNameField(
                  hintText: 'Shop Name',
                  focusNode: _nameFocusNode,
                  onChanged: viewModel.onNameChanged,
                  errorText: viewModel.nameErrorText,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: InputDescriptionField(
                  hintText: 'Shop Description',
                  focusNode: _descriptionFocusNode,
                  onChanged: viewModel.onDescriptionChanged,
                  errorText: viewModel.descriptionErrorText,
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
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
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: AppCheckBox(
                        value: viewModel.forPickup,
                        onTap: viewModel.onPickupTap,
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
                        value: viewModel.forDelivery,
                        onTap: viewModel.onDeliveryTap,
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
              if (viewModel.deliveryOptionErrorText != null)
                Text(
                  viewModel.deliveryOptionErrorText!,
                  style: themeData.textTheme.caption!
                      .copyWith(color: themeData.errorColor),
                ),
              const Spacer(),
              const SizedBox(height: 20),
              AppButton.filled(
                text: 'Set Shop Schedule',
                onPressed: viewModel.onSubmit,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
