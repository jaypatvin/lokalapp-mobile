import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/operating_hours.dart';
import '../../models/product.dart';
import '../../models/product_subscription_plan.dart';
import '../../providers/auth.dart';
import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/subscriptions.dart';
import '../../utils/calendar_picker/calendar_picker.dart';
import '../../utils/constants/themes.dart';
import '../../utils/repeated_days_generator/schedule_generator.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/schedule_picker.dart';
import '../../widgets/screen_loader.dart';
import '../activity/activity.dart';
import '../discover/product_detail.dart';
import 'subscription_payment_method.dart';

/// Subscription Schedule Screen
class SubscriptionSchedule extends StatefulWidget {
  /// The screen for the subscription schedule.
  /// Either the `productId` or the `subscriptionPlan` must not be null.
  /// The `productId` will be ignored when `subscriptionPlan` is given.
  ///
  /// If the `productId` is supplied, this will mean that the subscription
  /// has not yet been made and the user will setup its schedule. The order
  /// details will be fetched from the `ShoppingCart Provider`.
  ///
  /// However, if the `subscriptionPlan` is given, the subscription has already
  /// been placed. The app will check for conflicts with the product's schedule
  /// and will let the user modify the subscription's schedule.
  const SubscriptionSchedule({
    Key? key,
    this.productId,
    this.subscriptionPlan,
  }) : super(key: key);

  final String? productId;
  final ProductSubscriptionPlan? subscriptionPlan;

  @override
  _SubscriptionScheduleState createState() => _SubscriptionScheduleState();
}

class _SubscriptionScheduleState extends State<SubscriptionSchedule>
    with ScreenLoader {
  final _generator = ScheduleGenerator();
  final FocusNode _repeatUnitFocusNode = FocusNode();

  // --Order details variables - should only be changed/initialized in initState
  // --Needed for display. Since this screen can have 2 different sources, we
  // --need a common variable to set it with.
  int? _quantity;
  Product? _product;
  // This variable is only used when editing the subscription schedule.
  // Needed for the schedule generation.
  OperatingHours? _operatingHours;

  // --schedule variables
  // Selectable days from the week picker (Mon, Tue, Wed, etc.)
  List<int> _selectableDays = [];
  // used on week picker
  List<DateTime> _startDates = [];
  DateTime? _startDate;
  String? _repeatType;
  int? _repeatUnit;

  //#region editing schedule manually

  // This will hold the initial dates from the product schedule: the only days
  // selectable when manual set of the schedule is chosen.
  List<DateTime?> _productSelectableDates = [];
  // The chosen dates of the user. Used for the Calendar Picker.
  List<DateTime?> _markedDates = [];
  // The chosen dates of the user, however, will hold the values when the user
  // confirms or cancels the picking of dates.
  List<DateTime?> _selectedDates = [];
  // Will hold the `original_date` and `new_date` for the manual schedul set.
  Map<DateTime?, DateTime> _overridenDates = {};

  // Since the calendar picker will give the DateTime of the date pressed,
  // we will hold the value the user wants to change.
  DateTime? _originalDate;
  bool _displayWarning = true;

  //#endregion

  @override
  void initState() {
    super.initState();

    if (widget.subscriptionPlan == null && widget.productId == null) {
      throw "The parameter subscriptionPlan or productId must not be null.";
    }

    //#region Manually Resolve Conflicts
    if (widget.subscriptionPlan != null) {
      final subscriptionPlan = widget.subscriptionPlan!;
      final product =
          context.read<Products>().findById(subscriptionPlan.productId);

      // only needed for operating hours
      final shop = context.read<Shops>().findById(subscriptionPlan.shopId)!;

      this._quantity = subscriptionPlan.quantity;
      this._product = context.read<Products>().findById(
            subscriptionPlan.productId,
          );
      this._operatingHours = OperatingHours(
        repeatType: subscriptionPlan.plan.repeatType,
        repeatUnit: subscriptionPlan.plan.repeatUnit,
        startDates: subscriptionPlan.plan.startDates
            .map<String>((date) => DateFormat("yyyy-MM-dd").format(date))
            .toList(),
        unavailableDates: subscriptionPlan.plan.unavailableDates
            .map<String>((date) => DateFormat("yyyy-MM-dd").format(date))
            .toList(),
        customDates: [],
        startTime: shop.operatingHours!.startTime,
        endTime: shop.operatingHours!.endTime,
      );

      this._startDate = DateFormat("yyyy-MM-dd")
          .parse(this._operatingHours!.startDates!.first);

      // Product initialization. We get the available dates the of the product's
      // schedule. Will look into 45 days in the future.
      this._productSelectableDates = _generator
          .getSelectableDates(product!.availability!)
          .where(
            (date) =>
                date.difference(DateTime.now()).inDays <= 45 &&
                date.difference(DateTime.now()).inDays >= 0,
          )
          .toList()
        ..sort();

      // Subscription Schedule. Same as above where we will get the available
      // dates 45 days in the future.
      _markedDates = _generator
          .getSelectableDates(this._operatingHours!)
          .where(
            (date) =>
                date.difference(DateTime.now()).inDays <= 45 &&
                date.difference(DateTime.now()).inDays >= 0,
          )
          .toList()
        ..sort();

      subscriptionPlan.plan.overrideDates.forEach((overrideDate) {
        final index = _markedDates.indexWhere(
            (date) => date!.compareTo(overrideDate.originalDate!) == 0);
        if (index > -1) {
          _markedDates[index] = overrideDate.newDate;
        }
      });
      _selectedDates = [..._markedDates];

      this._displayWarning = !subscriptionPlan.plan.autoReschedule! &&
          _isConflict(_markedDates, _productSelectableDates);

      return;
    }
    //#endregion

    //#region New subscription creation
    if (widget.productId != null && widget.productId!.isNotEmpty) {
      final String? productId = widget.productId;

      final ProductOrderDetails? orderDetails =
          context.read<ShoppingCart>().getProductOrder(productId);

      if (orderDetails == null) {
        throw "Shopping cart does not contain the product order.";
      }

      this._quantity = orderDetails.quantity;
      this._product = context.read<Products>().findById(productId);
      this._operatingHours = _product!.availability;

      // no need to display the warning since we won't be checking for conflicts
      this._displayWarning = false;
    }
    //#endregion
  }

  //#region Schedule Creation

  // only used when weekday picker is used
  void _onSelectableDaysChanged(List<int> selectableDays) {
    this._selectableDays = selectableDays;
  }

  void _onStartDatesChanged(List<DateTime>? startDates, String? repeatType) {
    if (startDates!.isNotEmpty)
      this._startDate = startDates.first;
    else
      this._startDate = null;

    this._repeatType = repeatType;
    this._startDates = startDates;
  }

  // We only want to have subscriptions when the product is available.
  // When the product is available daily, we can set the subscription schedule
  // to days, weeks, and months. If the product is only available weekly,
  // we can only choose a schedule of weekly and monthly. Finally, when the
  // product is available monthly, we can also only set the sub sched to monthly.
  List<RepeatChoices> _getRepeatabilityChoices() {
    final repeatType = _product!.availability!.repeatType!;
    final repeatChoice = _generator.getRepeatChoicesFromString(repeatType);

    switch (repeatChoice) {
      case RepeatChoices.week:
        return [RepeatChoices.week, RepeatChoices.month];
      case RepeatChoices.month:
        return [RepeatChoices.month];
      default:
        return [RepeatChoices.day, RepeatChoices.week, RepeatChoices.month];
    }
  }

  Future<bool> _onCreateSubscriptionPlan() async {
    final repeatChoice = _generator.getRepeatChoicesFromString(_repeatType!);
    final dates = _generator
        .generateInitialDates(
          repeatChoice: repeatChoice,
          repeatEveryNUnit: _repeatUnit,
          startDate: _startDate,
          selectableDays: _selectableDays,
          repeatType: _repeatType,
        )
        .toSet()
        .where((date) => date.difference(_startDate!).inDays <= 45)
        .toList()
      ..sort();

    final availability =
        context.read<Products>().findById(_product!.id)!.availability!;
    final productSchedule = _generator
        .getSelectableDates(availability)
        .toSet()
        .where((date) => date.difference(_startDate!).inDays <= 45)
        .toList()
      ..sort();

    // We need to check if there are conflicts to determine if we will display
    // the conflict warning to the user.
    final difference =
        dates.toSet().difference(productSchedule.toSet()).toList();
    if (difference.isNotEmpty) {
      final setAutomatically = await this._displayNotification();

      // We then return what the user chose, to set manually or automatically.
      return setAutomatically != null && setAutomatically;
    }

    // If there are no conflicts, no need to setAutomatically.
    return false;
  }

  // The notification to display when there are conflicts.
  Future<bool?> _displayNotification() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return _ScheduleConflictsNotification(
          onAutomatic: () => Navigator.pop(ctx, true),
          onManual: () => Navigator.pop(ctx, false),
        );
      },
    );
  }

  //#endregion

  //#region Manual Resolve of Conflicts
  Future<bool> _onOverrideSchedule() async {
    final overridenDates = <OverrideDate>[];

    _overridenDates.forEach((key, value) {
      overridenDates.add(OverrideDate(originalDate: key, newDate: value));
    });

    return await context.read<SubscriptionProvider>().manualReschedulePlan(
      widget.subscriptionPlan!.id,
      {"override_dates": overridenDates.map((data) => data.toMap()).toList()},
    );
  }

  // Check for conflicts from two List<DateTime>
  bool _isConflict(List<DateTime?> a, List<DateTime?> b) {
    return a.toSet().difference(b.toSet()).isNotEmpty;
  }

  void _checkForConflicts() {
    setState(() {
      _displayWarning = _isConflict(_markedDates, _productSelectableDates);
    });
  }

  void _onDayPressedHandler(DateTime date) {
    // When the `_originalDate` is null, it means the user has not selected
    // a date to replace.
    if (_originalDate == null) return;
    _overridenDates[_originalDate] = date;

    _markedDates.remove(_originalDate);
    _markedDates.add(date);

    // We should only rebuild if _displayWarning changed.
    if (_displayWarning != _isConflict(_markedDates, _productSelectableDates)) {
      setState(() {
        _displayWarning = !_displayWarning;
      });
    }

    // Don't forget to reset the `_originalDate` indicating that there is no
    // date to be replaced (since we have already replaced it).
    _originalDate = null;
  }

  // The user chose a date to replace.
  void _onNonSelectableDayPressedHandler(DateTime date) {
    if (this._originalDate == date) {
      _originalDate = null;
    } else {
      _originalDate = date;
    }
  }

  // The user chose cancel on the CalendarPicker.
  // We reset the `_markDates` to it's original or on last `confirm`.
  void _onConflictCancel(BuildContext ctx) {
    _markedDates.toSet().difference(_selectedDates.toSet()).forEach((date) {
      _overridenDates.removeWhere((key, value) => value == date);
    });

    _markedDates = [..._selectedDates];
    _checkForConflicts();
    Navigator.pop(ctx, false);
  }

  Future<void> _displayCalendar() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (_ctx, setState) {
            bool _displayWarning = this._displayWarning;
            return _CalendarPicker(
              selectableDates: _productSelectableDates,
              onDayPressed: (date) {
                _onDayPressedHandler(date);
                if (_displayWarning != this._displayWarning) {
                  setState(() => _displayWarning = this._displayWarning);
                }
              },
              onNonSelectableDayPressed: _onNonSelectableDayPressedHandler,
              markedDates: _markedDates,
              displayWarning: _displayWarning,
              onCancel: () => _onConflictCancel(ctx),
              onConfirm: () {
                // The user chose to accept their changes.
                _selectedDates = [..._markedDates];
                Navigator.pop(ctx, true);
              },
            );
          },
        );
      },
    );
  }

  //#endregion

  Future<void> _onSubmitHandler() async {
    if (widget.subscriptionPlan != null) {
      final success = await _onOverrideSchedule();
      if (!success) {
        final snackBar = SnackBar(content: Text("Failed to update schedule"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      Navigator.popUntil(context, ModalRoute.withName(Activity.routeName));
      return;
    }

    if (_repeatUnit! <= 0) {
      final snackBar = SnackBar(
        content: Text("Please enter a valid repeat value."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final reschedule = await _onCreateSubscriptionPlan();

    // create subscription plan body for API endpoint
    final subscriptionPlanBody = SubscriptionPlanBody(
      productId: _product!.id,
      buyerId: context.read<Auth>().user!.id,
      shopId: _product!.shopId,
      quantity: _quantity,
      instruction:
          context.read<ShoppingCart>().getProductOrder(_product!.id)!.notes,
      plan: SubscriptionPlanBodySchedule(
        repeatType: _repeatType,
        repeatUnit: _repeatUnit,
        startDates: _startDates,
      ),
    );

    // Pass the subscription plan body since we also need the mode of payment.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SubscriptionPaymentMethod(
          subscriptionPlanBody: subscriptionPlanBody,
          reschedule: reschedule,
        ),
      ),
    );
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Subscription Schedule',
        titleStyle: const TextStyle(color: Colors.black),
        onPressedLeading: () => Navigator.of(context).pop(),
        leadingColor: Colors.black,
        backgroundColor: Colors.transparent,
      ),
      body: KeyboardActions(
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
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  );
                },
              ],
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ProductCard(
                product: this._product,
                quantity: this._quantity,
                onEditTap: widget.subscriptionPlan == null
                    ? () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductDetail(_product),
                          ),
                        )
                    : null,
              ),
              SizedBox(height: 10.0.h),
              SchedulePicker(
                header: "Schedule",
                description: "Which dates do you want this product "
                    "to be delivered?",
                repeatUnitFocusNode: _repeatUnitFocusNode,
                onRepeatTypeChanged: (choice) => _repeatType = choice,
                onStartDatesChanged: _onStartDatesChanged,
                onRepeatUnitChanged: (repeatUnit) => _repeatUnit = repeatUnit,
                onSelectableDaysChanged: _onSelectableDaysChanged,
                repeatabilityChoices: _getRepeatabilityChoices(),
                operatingHours: _operatingHours,
                editable: widget.subscriptionPlan == null,
                limitSelectableDates: widget.subscriptionPlan == null,
              ),
              SizedBox(height: 10.0.h),
              if (this._displayWarning)
                Row(
                  children: [
                    Icon(
                      MdiIcons.alertCircle,
                      color: kPinkColor,
                    ),
                    SizedBox(width: 10.0.w),
                    Expanded(
                      child: Text(
                        "This shop won't be able to deliver on the date/s "
                        "you set. Please manually re-schedule these orders "
                        "or else they won't be placed.",
                        maxLines: null,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )
                  ],
                ),
              if (this._displayWarning) SizedBox(height: 20.0.h),
              if (widget.subscriptionPlan != null)
                FlatButton(
                  minWidth: double.infinity,
                  height: 50.0.h,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: kTealColor),
                  ),
                  textColor: kTealColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "See Calendar",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: kTealColor, fontWeight: FontWeight.w600),
                      ),
                      if (this._displayWarning)
                        Icon(
                          MdiIcons.alertCircle,
                          color: kPinkColor,
                          size: 20.0.r,
                        )
                    ],
                  ),
                  onPressed: () async => await _displayCalendar(),
                ),
              SizedBox(height: 10.0.h),
              SizedBox(
                height: 50.0.h,
                width: double.infinity,
                child: AppButton(
                  widget.subscriptionPlan == null ? "Next" : "Apply",
                  kTealColor,
                  true,
                  () async => await performFuture<void>(
                    () async => await _onSubmitHandler(),
                  ),
                  textStyle: TextStyle(fontSize: 20.0.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// We can't use the transaction card since we are not using transactions
class _ProductCard extends StatelessWidget {
  const _ProductCard({
    Key? key,
    required this.product,
    required this.quantity,
    required this.onEditTap,
  }) : super(key: key);

  final Product? product;
  final int? quantity;
  final void Function()? onEditTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color(0xFFE0E0E0),
        ),
        borderRadius: BorderRadius.circular(20.0.r),
      ),
      elevation: 0.0,
      child: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (product!.gallery!.isNotEmpty)
                    SizedBox(
                      width: 80.0.h,
                      height: 80.0.h,
                      child: Image.network(
                        product!.gallery!.first.url,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, obj, stack) {
                          return Text("No Image");
                        },
                      ),
                    ),
                  SizedBox(width: 8.0.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product!.name!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: false,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                            SizedBox(width: 8.0.w),
                            Column(
                              children: [
                                Text(
                                  product!.basePrice.toString(),
                                  // textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(
                                  "x$quantity",
                                  // textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0.h),
                        if (this.onEditTap != null)
                          InkWell(
                            child: Text(
                              "Edit",
                              style: TextStyle(
                                fontSize: 16.0.sp,
                                fontFamily: "Goldplay",
                                fontWeight: FontWeight.w300,
                                decoration: TextDecoration.underline,
                                color: kTealColor,
                              ),
                            ),
                            onTap: onEditTap,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// The dialog to be displayed when conflicts are present.
class _ScheduleConflictsNotification extends StatelessWidget {
  final void Function()? onAutomatic;
  final void Function()? onManual;
  const _ScheduleConflictsNotification({
    Key? key,
    this.onAutomatic,
    this.onManual,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 10.0.w),
        child: Padding(
          padding: EdgeInsets.all(20.0.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                MdiIcons.alertCircle,
                color: Colors.red,
              ),
              SizedBox(height: 10.0.h),
              Text(
                "There will be days on the schedule that you set that this "
                "shop won't be able to deliver.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "You can either let us automatically re-schedule "
                          "your order to the next available date",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: kTealColor,
                          ),
                    ),
                    TextSpan(text: " or "),
                    TextSpan(
                      text: "you can manually re-schedule the unavailable "
                          "dates in the Activities screen.",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: kOrangeColor,
                          ),
                    ),
                  ],
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black,
                      ),
                ),
              ),
              SizedBox(height: 10.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: AppButton(
                      "Set Manually",
                      kOrangeColor,
                      true,
                      this.onManual,
                    ),
                  ),
                  SizedBox(width: 5.0.w),
                  Expanded(
                    child: AppButton(
                      "Set Automatically",
                      kTealColor,
                      true,
                      this.onAutomatic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// The calendar picker to be displayed to manually resolve the conflicts.
class _CalendarPicker extends StatelessWidget {
  final void Function(DateTime) onDayPressed;
  final void Function(DateTime) onNonSelectableDayPressed;
  final void Function() onConfirm;
  final void Function() onCancel;
  final List<DateTime?> markedDates;
  final List<DateTime?> selectableDates;
  final bool displayWarning;
  const _CalendarPicker({
    Key? key,
    required this.onDayPressed,
    required this.onCancel,
    required this.onConfirm,
    required this.markedDates,
    required this.selectableDates,
    required this.onNonSelectableDayPressed,
    required this.displayWarning,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 10.0.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0.r),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 15.0.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Subscription Calendar",
                style: Theme.of(context).textTheme.headline5,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.63,
                child: CalendarCarousel(
                  width: MediaQuery.of(context).size.width * 0.95,
                  onDayPressed: this.onDayPressed,
                  onNonSelectableDayPressed: this.onNonSelectableDayPressed,
                  markedDatesMap: this.markedDates,
                  selectableDates: this.selectableDates,
                ),
              ),
              if (this.displayWarning)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.alertCircle,
                        color: kPinkColor,
                      ),
                      SizedBox(width: 2.0.w),
                      Expanded(
                        child: Text(
                          "This shop will be closed on the date you selected. "
                          "Please pick a different date to have your orders delivered.",
                          maxLines: 3,
                        ),
                      ),
                    ],
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
