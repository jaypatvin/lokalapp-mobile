import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/operating_hours.dart';
import '../../../models/product.dart';
import '../../../models/product_subscription_plan.dart';
import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../state/view_model.dart';
import '../../../utils/repeated_days_generator/schedule_generator.dart';
import '../../../widgets/schedule_picker.dart';

class SellerSubscriptionScheduleViewModel extends ViewModel {
  SellerSubscriptionScheduleViewModel({required this.subscriptionPlan});
  final ProductSubscriptionPlan subscriptionPlan;

  late final int quantity;
  late final Product product;
  late final OperatingHours operatingHours;
  late final List<RepeatChoices> repeatabilityChoices;
  late final ScheduleGenerator _generator;

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

  bool _displayWarning = true;
  bool get displayWarning => _displayWarning;

  bool _loaded = false;
  bool get loaded => _loaded;

  @override
  Future<void> init() async {
    _generator = ScheduleGenerator();
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
    _productSelectableDates =
        _generator.getSelectableDates(product.availability);

    // Subscription Schedule. Same as above where we will get the available
    // dates 45 days in the future.
    _markedDates = _generator.getSelectableDates(operatingHours);

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

  // Check for conflicts from two List<DateTime>
  bool _isConflict(List<DateTime?> a, List<DateTime?> b) {
    return a.toSet().difference(b.toSet()).isNotEmpty;
  }
}
