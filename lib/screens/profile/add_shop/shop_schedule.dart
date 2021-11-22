import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
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
import '../../../widgets/schedule_picker.dart';

class ShopSchedule extends StatelessWidget {
  static const routeName = '/profile/addShop/schedule';
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
        shopPhoto: this.shopPhoto,
        forEditing: this.forEditing,
        onShopEdit: this.onShopEdit,
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

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        titleText: "Shop Schedule",
        titleStyle: TextStyle(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        leadingColor: Colors.black,
        elevation: 0.0,
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.02,
        ),
        child: KeyboardActions(
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
                        "Done",
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
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SchedulePicker(
                header: "Days Available",
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
                "Hours",
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 10),
              _HoursPicker(
                opening: vm.opening,
                closing: vm.closing,
                onSelectOpening: vm.onSelectOpening,
                onSelectClosing: vm.onSelectClosing,
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  "Confirm",
                  kTealColor,
                  true,
                  vm.onConfirm,
                ),
              )
            ],
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
    SizedBox spacerBox = SizedBox(
      width: MediaQuery.of(context).size.width * 0.03,
    );
    return Row(
      children: [
        Text(
          "Every",
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.normal),
        ),
        spacerBox,
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: Colors.transparent,
              ),
              color: Colors.grey[200],
            ),
            child: TextButton(
              onPressed: this.onSelectOpening,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      getTimeOfDayString(this.opening),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_sharp,
                    color: kTealColor,
                    size: 16.0.sp,
                  ),
                ],
              ),
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
            ),
          ),
        ),
        spacerBox,
        Text(
          "To",
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.normal),
        ),
        spacerBox,
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: Colors.transparent,
              ),
              color: Colors.grey[200],
            ),
            child: TextButton(
              onPressed: this.onSelectClosing,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      getTimeOfDayString(this.closing),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_sharp,
                    color: kTealColor,
                    size: 16.0.sp,
                  ),
                ],
              ),
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
