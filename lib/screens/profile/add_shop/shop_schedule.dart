import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../providers/post_requests/operating_hours_body.dart';
import '../../../providers/shops.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../utils/functions.utils.dart';
import '../../../view_models/profile/shop/add_shop/shop_schedule.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/overlays/constrained_scrollview.dart';
import '../../../widgets/schedule_picker.dart';

class ShopSchedule extends StatelessWidget {
  const ShopSchedule({
    Key? key,
    this.shopPhoto,
    this.forEditing = false,
    this.onShopEdit,
  }) : super(key: key);

  final File? shopPhoto;
  final bool forEditing;
  final Function()? onShopEdit;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _ShopScheduleView(),
      viewModel: ShopScheduleViewModel(
        shopPhoto: shopPhoto,
        forEditing: forEditing,
        onShopEdit: onShopEdit,
      ),
    );
  }
}

class _ShopScheduleView extends HookView<ShopScheduleViewModel> {
  final FocusNode _repeatUnitFocusNode = FocusNode();

  @override
  Widget render(
    BuildContext context,
    ShopScheduleViewModel vm,
  ) {
    final user = context.read<Auth>().user!;
    final shops = context.read<Shops>().findByUser(user.id);

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        titleText: 'Shop Schedule',
        titleStyle: const TextStyle(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        leadingColor: Colors.black,
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: ConstrainedScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.02,
          ),
          child: KeyboardActions(
            disableScroll: true,
            config: KeyboardActionsConfig(
              nextFocus: false,
              actions: [
                KeyboardActionsItem(
                  focusNode: _repeatUnitFocusNode,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SchedulePicker(
                  header: 'Days Available',
                  description: "Set your shop's availability",
                  repeatUnitFocusNode: _repeatUnitFocusNode,
                  operatingHours:
                      shops.isNotEmpty ? shops.first.operatingHours : null,
                  onStartDatesChanged: vm.onStartDatesChangedHandler,
                  onRepeatTypeChanged: (repeatType) => context
                      .read<OperatingHoursBody>()
                      .update(repeatType: repeatType),
                  onRepeatUnitChanged: (repeatUnit) => context
                      .read<OperatingHoursBody>()
                      .update(repeatUnit: repeatUnit),
                  onSelectableDaysChanged: vm.onSelectableDaysChanged,
                ),
                const SizedBox(height: 15),
                Text(
                  'Hours',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 10),
                _HoursPicker(
                  opening: vm.opening,
                  closing: vm.closing,
                  onSelectOpening: vm.onSelectOpening,
                  onSelectClosing: vm.onSelectClosing,
                ),
                const Spacer(),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.filled(
                    text: 'Confirm',
                    onPressed: vm.onConfirm,
                  ),
                ),
                       const SizedBox(height: 24),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HoursPicker extends StatelessWidget {
  final TimeOfDay opening;
  final TimeOfDay closing;
  final void Function() onSelectOpening;
  final void Function() onSelectClosing;

  const _HoursPicker({
    Key? key,
    required this.opening,
    required this.closing,
    required this.onSelectOpening,
    required this.onSelectClosing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            'From',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        Flexible(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: Colors.transparent,
              ),
              color: Colors.grey[200],
            ),
            child: TextButton(
              onPressed: onSelectOpening,
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      getTimeOfDayString(opening),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  const Icon(MdiIcons.chevronDown, color: kTealColor),
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Text(
            'To',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        Flexible(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: Colors.transparent,
              ),
              color: Colors.grey[200],
            ),
            child: TextButton(
              onPressed: onSelectClosing,
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      getTimeOfDayString(closing),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  const Icon(MdiIcons.chevronDown, color: kTealColor),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
