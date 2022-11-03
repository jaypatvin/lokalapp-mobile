import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../models/operating_hours.dart';
import '../../../providers/auth.dart';
import '../../../providers/post_requests/operating_hours_body.dart';
import '../../../providers/post_requests/shop_body.dart';
import '../../../providers/shops.dart';
import '../../../routers/app_router.dart';
import '../../../routers/profile/props/payment_options.props.dart';
import '../../../services/local_image_service.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/repeated_days_generator/schedule_generator.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/calendar_picker/calendar_picker.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/overlays/screen_loader.dart';
import '../../../widgets/schedule_picker.dart';
import 'payment_options.dart';
import 'shop_confirmation.dart';

class CustomizeAvailability extends StatefulWidget {
  static const routeName = '/profile/addShop/availability';
  const CustomizeAvailability({
    required this.repeatChoice,
    required this.selectableDays,
    required this.startDate,
    required this.repeatEvery,
    required this.usedDatePicker,
    this.shopPhoto,
    this.forEditing = false,
    this.onShopEdit,
  });

  final RepeatChoices repeatChoice;
  final int? repeatEvery;
  final List<int> selectableDays;
  final DateTime startDate;
  final File? shopPhoto;
  final bool usedDatePicker;
  final bool forEditing;
  final Function? onShopEdit;

  @override
  _CustomizeAvailabilityState createState() => _CustomizeAvailabilityState();
}

class _CustomizeAvailabilityState extends State<CustomizeAvailability>
    with ScreenLoader {
  late List<DateTime?> initialDates;
  late List<DateTime?> markedDates;
  bool _customized = false;

  @override
  void initState() {
    super.initState();
    final generator = ScheduleGenerator();

    final operatingHours = context.read<OperatingHoursBody>().request;

    initialDates = generator.generateInitialDates(
      repeatChoice: widget.repeatChoice,
      startDate: widget.startDate,
      repeatEveryNUnit: widget.repeatEvery,
      selectableDays: widget.selectableDays,
      repeatType: operatingHours.repeatType,
    );
    markedDates = [...initialDates];

    for (final customDate in operatingHours.customDates) {
      markedDates.add(DateTime.parse(customDate.date));
    }
    for (final dateString in operatingHours.unavailableDates) {
      final unavailableDate = DateTime.parse(dateString);
      final index = markedDates.indexWhere(
        (date) => date?.isAtSameMomentAs(unavailableDate) ?? false,
      );
      if (index > -1) {
        markedDates.removeAt(index);
      }
    }
  }

  Future<List<DateTime?>?> _showCalendarPicker() async {
    final List<DateTime?> selectedDates = [...markedDates];
    return showDialog<List<DateTime?>?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _CalendarPicker(
          onDayPressed: (day) {
            setState(() {
              if (selectedDates.contains(day)) {
                selectedDates.remove(day);
              } else {
                selectedDates.add(day);
              }
            });
          },
          onCancel: () {
            Navigator.pop(context, markedDates);
          },
          onConfirm: () {
            setState(() {
              markedDates = selectedDates;
              _customized = true;
            });

            Navigator.pop(context, markedDates);
          },
          markedDates: selectedDates,
          startDate: widget.startDate.difference(DateTime.now()).inDays >= 0
              ? widget.startDate
              : DateTime.now(),
          selectableDays: const [1, 2, 3, 4, 5, 6, 0],
        );
      },
    );
  }

  void setUpShotSchedule() {
    markedDates.sort();
    initialDates.sort();
    final operatingHours =
        Provider.of<OperatingHoursBody>(context, listen: false);

    final customDates =
        markedDates.where((date) => !initialDates.contains(date)).toList();
    final unavailableDates =
        initialDates.where((date) => !markedDates.contains(date)).toList();

    operatingHours.update(
      customDates: customDates
          .map(
            (date) => CustomDates(
              startTime: operatingHours.request.startTime,
              endTime: operatingHours.request.endTime,
              date: DateFormat('yyyy-MM-dd').format(date!),
            ),
          )
          .toList(),
      unavailableDates: unavailableDates
          .map((date) => DateFormat('yyyy-MM-dd').format(date!))
          .toList(),
    );
  }

  Future<bool> updateShopSchedule() async {
    final user = context.read<Auth>().user!;
    final shops = context.read<Shops>();
    final userShop = shops.findByUser(user.id).first;
    final operatingHours = context.read<OperatingHoursBody>();
    return shops.setOperatingHours(
      id: userShop.id,
      request: operatingHours.request,
    );
  }

  Future<void> _createShop() async {
    final file = widget.shopPhoto;
    String mediaUrl = '';
    if (file != null) {
      mediaUrl = await context
          .read<LocalImageService>()
          .uploadImage(file: file, src: kShopImagesSrc);
    }
    if (!mounted) return;
    final user = context.read<Auth>().user!;
    final ShopBody shopBody = Provider.of<ShopBody>(context, listen: false);
    final Shops shops = Provider.of<Shops>(context, listen: false);

    shopBody.update(
      profilePhoto: mediaUrl,
      userId: user.id,
      operatingHours: context.read<OperatingHoursBody>().request,
    );

    try {
      await shops.create(shopBody.request);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> _onSubmit() async {
    try {
      await _createShop();
      if (!mounted) return;

      context.read<AppRouter>().navigateTo(
            AppRoute.profile,
            AddShopConfirmation.routeName,
          );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast('Failed to create shop. Try again.');
    }
  }

  Future<void> _onConfirm() async {
    setUpShotSchedule();

    if (widget.forEditing) {
      widget.onShopEdit?.call();
      return;
    }

    context.read<AppRouter>().navigateTo(
          AppRoute.profile,
          SetUpPaymentOptions.routeName,
          arguments: SetUpPaymentOptionsProps(onSubmit: _onSubmit),
        );
  }

  @override
  Widget screen(BuildContext context) {
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
        onPressedLeading: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 50),
            Text(
              'Customize Availability',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Text(
              'Customize which days your shop will be available',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: AppButton.transparent(
                text: 'Customize Availability',
                onPressed: _showCalendarPicker,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppButton.filled(
                text: _customized ? 'Confirm' : 'Next',
                onPressed: _onConfirm,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _CalendarPicker extends StatelessWidget {
  final void Function(DateTime) onDayPressed;
  final void Function() onConfirm;
  final void Function() onCancel;
  final List<DateTime?> markedDates;
  final DateTime startDate;
  final List<int> selectableDays;
  const _CalendarPicker({
    Key? key,
    required this.onDayPressed,
    required this.onCancel,
    required this.onConfirm,
    required this.markedDates,
    required this.startDate,
    required this.selectableDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 23),
              Text(
                'Set Availability Exceptions',
                style: Theme.of(context).textTheme.headline6,
              ),
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return CalendarPicker(
                    startDate: startDate,
                    onDayPressed: (day) => setState(() => onDayPressed(day)),
                    markedDates: markedDates.whereType<DateTime>().toList(),
                    selectableDays: selectableDays,
                  );
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: AppButton.transparent(
                        text: 'Cancel',
                        onPressed: onCancel,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppButton.filled(
                        text: 'Confirm',
                        onPressed: onConfirm,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
