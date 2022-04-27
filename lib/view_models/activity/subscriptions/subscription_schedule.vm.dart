import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../models/failure_exception.dart';
import '../../../models/operating_hours.dart';
import '../../../models/order.dart';
import '../../../models/post_requests/product_subscription_plan/override_dates.request.dart';
import '../../../models/post_requests/product_subscription_plan/product_subscription_plan.request.dart';
import '../../../models/post_requests/product_subscription_plan/product_subscription_schedule.request.dart';
import '../../../models/product.dart';
import '../../../models/product_subscription_plan.dart';
import '../../../providers/auth.dart';
import '../../../providers/cart.dart';
import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../routers/app_router.dart';
import '../../../screens/activity/activity.dart';
import '../../../screens/activity/subscriptions/subscription_payment_method.dart';
import '../../../services/api/api.dart';
import '../../../services/api/subscription_plan_api_service.dart';
import '../../../state/view_model.dart';
import '../../../utils/repeated_days_generator/schedule_generator.dart';
import '../../../widgets/schedule_picker.dart';

class NewSubscriptionScheduleViewModel extends ViewModel {
  NewSubscriptionScheduleViewModel({
    required this.productId,
    this.displayNotification,
  }) : assert(productId.isNotEmpty, 'productId should not be empty');
  final String productId;
  final Future<bool?> Function(BuildContext)? displayNotification;

  late final int quantity;
  late final Product product;
  late final OperatingHours operatingHours;
  late final List<RepeatChoices> repeatabilityChoices;

  late final ScheduleGenerator _generator;

  String _repeatType = RepeatChoices.day.value;
  int _repeatUnit = 1;
  List<DateTime> _startDates = [];
  DateTime? _startDate;
  List<int> _selectableDays = [];

  @override
  void init() {
    final orderDetails =
        context.read<ShoppingCart>().getProductOrder(productId);

    // if (orderDetails == null) {
    //   throw 'Shopping cart does not contain the product order.';
    // }

    final _product = context.read<Products>().findById(productId);
    if (_product == null) {
      throw FailureException('No product with the ID $productId is found!');
    }

    _generator = ScheduleGenerator();
    quantity = orderDetails?.quantity ?? 1;
    product = _product;
    operatingHours = product.availability;
    repeatabilityChoices = _getRepeatabilityChoices();
  }

  void onRepeatTypeChanged(String? choice) {
    _repeatType = choice ?? _repeatType;
    notifyListeners();
  }

  void onRepeatUnitChanged(int? repeatUnit) {
    _repeatUnit = repeatUnit ?? _repeatUnit;
    notifyListeners();
  }

  void onSelectableDaysChanged(List<int> selectableDays) {
    _selectableDays = selectableDays;
    notifyListeners();
  }

  void onStartDatesChanged(List<DateTime>? startDates, String? repeatType) {
    if (startDates!.isNotEmpty) {
      _startDate = startDates.first;
    } else {
      _startDate = null;
    }

    _repeatType = repeatType ?? _repeatType;
    _startDates = startDates;

    notifyListeners();
  }

  // We only want to have subscriptions when the product is available.
  // When the product is available daily, we can set the subscription schedule
  // to days, weeks, and months. If the product is only available weekly,
  // we can only choose a schedule of weekly and monthly. Finally, when the
  // product is available monthly, we can also only set the sub sched to monthly.
  List<RepeatChoices> _getRepeatabilityChoices() {
    final repeatType = operatingHours.repeatType;
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

  Future<void> onSubmitHandler() async {
    if (_repeatUnit <= 0) {
      showToast('Please enter a valid repeat value.');
      return;
    }

    final reschedule = await _onCreateSubscriptionPlan();

    final request = ProductSubscriptionPlanRequest(
      productId: product.id,
      buyerId: context.read<Auth>().user?.id,
      shopId: product.shopId,
      quantity: quantity,
      paymentMethod: PaymentMethod.cod,
      instruction:
          context.read<ShoppingCart>().getProductOrder(product.id)?.notes,
      plan: ProductSubscriptionScheduleRequest(
        repeatType: _repeatType,
        repeatUnit: _repeatUnit,
        startDates: _startDates,
      ),
    );

    if (reschedule != null) {
      AppRouter.discoverNavigatorKey.currentState?.push(
        AppNavigator.appPageRoute(
          builder: (_) => SubscriptionPaymentMethod(
            request: request,
            reschedule: reschedule,
          ),
        ),
      );
    }
  }

  Future<bool?> _onCreateSubscriptionPlan() async {
    final repeatChoice = _generator.getRepeatChoicesFromString(_repeatType);
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

    final productSchedule = _generator
        .getSelectableDates(operatingHours)
        .toSet()
        .where((date) => date.difference(_startDate!).inDays <= 45)
        .toList()
      ..sort();

    // We need to check if there are conflicts to determine if we will display
    // the conflict warning to the user.
    final difference =
        dates.toSet().difference(productSchedule.toSet()).toList();
    if (difference.isNotEmpty) {
      // We then return what the user chose, to set manually or automatically.
      return await displayNotification?.call(context);
    }

    // If there are no conflicts, no need to setAutomatically.
    return false;
  }
}

class ViewSubscriptionScheduleViewModel extends ViewModel {
  ViewSubscriptionScheduleViewModel({required this.subscriptionPlan});
  final ProductSubscriptionPlan subscriptionPlan;

  late final int quantity;
  late final Product product;
  late final OperatingHours operatingHours;
  late final List<RepeatChoices> repeatabilityChoices;

  late final ScheduleGenerator _generator;
  late final SubscriptionPlanAPIService _apiService;

  // This will hold the initial dates from the product schedule: the only days
  // selectable when manual set of the schedule is chosen.
  List<DateTime?> _productSelectableDates = [];
  List<DateTime?> get productSelectableDates => _productSelectableDates;

  // The chosen dates of the user. Used for the Calendar Picker.
  List<DateTime?> _markedDates = [];
  List<DateTime?> get markedDates => _markedDates;

  // The chosen dates of the user, however, will hold the values when the user
  // confirms or cancels the picking of dates.
  List<DateTime?> _selectedDates = [];
  List<DateTime?> get selectedDates => _selectedDates;
  set selectedDates(List<DateTime?> value) {
    _selectedDates = value;
    notifyListeners();
  }

  /// Will hold the `original_date` and `new_date` for the manual schedule setter.
  Map<DateTime?, DateTime> get overridenDates => _overridenDates;
  final Map<DateTime, DateTime> _overridenDates = {};

  // Since the calendar picker will give the DateTime of the date pressed,
  // we will hold the value the user wants to change.
  DateTime? _originalDate;

  bool _displayWarning = true;
  bool get displayWarning => _displayWarning;

  bool _loaded = false;
  bool get loaded => _loaded;

  @override
  Future<void> init() async {
    _generator = ScheduleGenerator();
    _apiService = SubscriptionPlanAPIService(context.read<API>());

    final shop = context.read<Shops>().findById(subscriptionPlan.shopId)!;

    quantity = subscriptionPlan.quantity;
    product = context.read<Products>().findById(
          subscriptionPlan.productId,
        )!;
    operatingHours = OperatingHours(
      repeatType: subscriptionPlan.plan.repeatType,
      repeatUnit: subscriptionPlan.plan.repeatUnit,
      startDates: subscriptionPlan.plan.startDates
          .map<String>((date) => DateFormat('yyyy-MM-dd').format(date))
          .toList(),
      customDates: [],
      startTime: shop.operatingHours.startTime,
      endTime: shop.operatingHours.endTime,
    );

    // Product initialization. We get the available dates the of the product's
    // schedule. Will look into 45 days in the future.
    _productSelectableDates = _generator
        .getSelectableDates(product.availability)
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
        .getSelectableDates(operatingHours)
        .where(
          (date) =>
              date.difference(DateTime.now()).inDays <= 45 &&
              date.difference(DateTime.now()).inDays >= 0,
        )
        .toList()
      ..sort();

    for (final overrideDate in subscriptionPlan.plan.overrideDates) {
      final index = _markedDates.indexWhere(
        (date) => date!.compareTo(overrideDate.originalDate) == 0,
      );
      if (index > -1) {
        _markedDates[index] = overrideDate.newDate;
      }
    }
    _selectedDates = [..._markedDates];

    _displayWarning = !subscriptionPlan.plan.autoReschedule &&
        _isConflict(_markedDates, _productSelectableDates);

    repeatabilityChoices = _getRepeatabilityChoices();

    _loaded = true;
    // notifyListeners();
  }

  // We only want to have subscriptions when the product is available.
  // When the product is available daily, we can set the subscription schedule
  // to days, weeks, and months. If the product is only available weekly,
  // we can only choose a schedule of weekly and monthly. Finally, when the
  // product is available monthly, we can also only set the sub sched to monthly.
  List<RepeatChoices> _getRepeatabilityChoices() {
    final repeatType = operatingHours.repeatType;
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

  Future<void> onSubmitHandler() async {
    final success = await _onOverrideSchedule();
    if (!success) {
      showToast('Failed to update schedule.');
      return;
    }

    AppRouter.activityNavigatorKey.currentState
        ?.popUntil(ModalRoute.withName(Activity.routeName));
  }

  Future<bool> _onOverrideSchedule() async {
    final overridenDates = <OverrideDate>[];

    _overridenDates.forEach((key, value) {
      overridenDates.add(OverrideDate(originalDate: key, newDate: value));
    });

    try {
      return await _apiService.manualReschedulePlan(
        planId: subscriptionPlan.id,
        request: OverrideDatesRequest(overridenDates),
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return false;
    }
  }

  // Check for conflicts from two List<DateTime>
  bool _isConflict(List<DateTime?> a, List<DateTime?> b) {
    return a.toSet().difference(b.toSet()).isNotEmpty;
  }

  void _checkForConflicts() {
    _displayWarning = _isConflict(_markedDates, _productSelectableDates);
    notifyListeners();
  }

  void onDayPressedHandler(DateTime date) {
    // When the `_originalDate` is null, it means the user has not selected
    // a date to replace.
    if (_originalDate == null) return;
    _overridenDates[_originalDate!] = date;

    _markedDates.remove(_originalDate);
    _markedDates.add(date);

    // We should only rebuild if _displayWarning changed.
    if (_displayWarning != _isConflict(_markedDates, _productSelectableDates)) {
      _displayWarning = !_displayWarning;
    }

    // Don't forget to reset the `_originalDate` indicating that there is no
    // date to be replaced (since we have already replaced it).
    _originalDate = null;

    notifyListeners();
  }

  // The user chose a date to replace.
  void onNonSelectableDayPressedHandler(DateTime date) {
    if (_originalDate == date) {
      _originalDate = null;
    } else {
      _originalDate = date;
    }
  }

  // The user chose cancel on the CalendarPicker.
  // We reset the `_markDates` to it's original or on last `confirm`.
  void onConflictCancel(BuildContext ctx) {
    _markedDates.toSet().difference(_selectedDates.toSet()).forEach((date) {
      _overridenDates.removeWhere((key, value) => value == date);
    });

    _markedDates = [..._selectedDates];
    _checkForConflicts();
    Navigator.pop(ctx, false);
  }
}
