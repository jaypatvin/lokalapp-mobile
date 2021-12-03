import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';

import '../../../models/operating_hours.dart';
import '../../../providers/auth.dart';
import '../../../providers/post_requests/operating_hours_body.dart';
import '../../../providers/post_requests/shop_body.dart';
import '../../../providers/shops.dart';
import '../../../routers/app_router.dart';
import '../../../services/local_image_service.dart';
import '../../../utils/calendar_picker/calendar_picker.dart';
import '../../../utils/constants/themes.dart';
import '../../../utils/repeated_days_generator/schedule_generator.dart';
import '../../../widgets/app_button.dart';
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
  // bool _shopCreated = false;
  bool _customized = false;

  @override
  initState() {
    super.initState();
    final _generator = ScheduleGenerator();

    final operatingHours = context.read<OperatingHoursBody>().operatingHours;

    initialDates = _generator.generateInitialDates(
      repeatChoice: widget.repeatChoice,
      startDate: widget.startDate,
      repeatEveryNUnit: widget.repeatEvery,
      selectableDays: widget.selectableDays,
      repeatType: operatingHours.repeatType,
    );
    markedDates = [...initialDates];

    operatingHours.customDates?.forEach((customDate) {
      markedDates.add(DateTime.parse(customDate.date!));
    });
    operatingHours.unavailableDates?.forEach((dateString) {
      final _date = DateTime.parse(dateString);
      final index = markedDates
          .indexWhere((date) => date?.isAtSameMomentAs(_date) ?? false);
      if (index > -1) {
        markedDates.removeAt(index);
      }
    });
  }

  Future<List<DateTime?>?> _showCalendarPicker() async {
    List<DateTime?> selectedDates = [...markedDates];
    return await showDialog<List<DateTime?>?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _CalendarPicker(
          onDayPressed: (day) {
            setState(() {
              if (selectedDates.contains(day))
                selectedDates.remove(day);
              else
                selectedDates.add(day);
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
    var operatingHours =
        Provider.of<OperatingHoursBody>(context, listen: false);

    var customDates =
        markedDates.where((date) => !initialDates.contains(date)).toList();
    var unavailableDates =
        initialDates.where((date) => !markedDates.contains(date)).toList();

    operatingHours.update(
      customDates: customDates
          .map((date) =>
              CustomDates(date: DateFormat("yyyy-MM-dd").format(date!)))
          .toList(),
      unavailableDates: unavailableDates
          .map((date) => DateFormat("yyyy-MM-dd").format(date!))
          .toList(),
    );
  }

  Future<bool> updateShopSchedule() async {
    final user = context.read<Auth>().user!;
    var shops = context.read<Shops>();
    var userShop = shops.findByUser(user.id).first;
    var operatingHours = context.read<OperatingHoursBody>();
    return await shops.setOperatingHours(
      id: userShop.id!,
      data: operatingHours.data,
    );
  }

  Future<void> _createShop() async {
    var file = widget.shopPhoto;
    String mediaUrl = "";
    if (file != null) {
      mediaUrl = await Provider.of<LocalImageService>(context, listen: false)
          .uploadImage(file: file, name: 'shop_photo');
    }
    final user = context.read<Auth>().user!;
    ShopBody shopBody = Provider.of<ShopBody>(context, listen: false);
    Shops shops = Provider.of<Shops>(context, listen: false);

    shopBody.update(
      profilePhoto: mediaUrl,
      userId: user.id,
      communityId: user.communityId,
      operatingHours: context.read<OperatingHoursBody>(),
    );

    try {
      await shops.create(shopBody.toMap());
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw e;
    }
  }

  Future<void> _onSubmit() async {
    try {
      await _createShop();
      context.read<AppRouter>()
        ..navigateTo(
          AppRoute.profile,
          AddShopConfirmation.routeName,
        );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to create shop. Try again"),
        ),
      );
    }
  }

  Future<void> _onConfirm() async {
    setUpShotSchedule();

    if (widget.forEditing) {
      if (widget.onShopEdit != null) widget.onShopEdit!();
      return;
    }

    context.read<AppRouter>()
      ..navigateTo(
        AppRoute.profile,
        SetUpPaymentOptions.routeName,
        arguments: {'onSubmit': _onSubmit},
      );
  }

  @override
  Widget screen(BuildContext context) {
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
          onPressedLeading: () {
            Navigator.pop(context);
          }),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Customize Availability",
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              "Customize which days your shop will be available",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: height * 0.05,
            ),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                "Customize Availability",
                kTealColor,
                false,
                _showCalendarPicker,
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                _customized ? "Confirm" : "Next",
                kTealColor,
                true,
                _onConfirm,
              ),
            )
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
        insetPadding: EdgeInsets.zero,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Text(
                "Set Availability Exceptions",
                style: Theme.of(context).textTheme.headline5,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.63,
                padding: EdgeInsets.all(5.0),
                child: CalendarCarousel(
                  width: MediaQuery.of(context).size.width * 0.95,
                  startDate: this.startDate,
                  onDayPressed: this.onDayPressed,
                  markedDatesMap: this.markedDates,
                  selectableDaysMap: this.selectableDays,
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  margin: EdgeInsets.symmetric(vertical: 5.0.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: AppButton(
                          "Cancel",
                          kTealColor,
                          false,
                          onCancel,
                        ),
                      ),
                      SizedBox(width: 5.0.w),
                      Expanded(
                        child: AppButton(
                          "Confirm",
                          kTealColor,
                          true,
                          onConfirm,
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
    );
  }
}
