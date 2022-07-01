import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat, Intl;
import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../models/operating_hours.dart';
import '../../../providers/auth.dart';
import '../../../providers/post_requests/operating_hours_body.dart';
import '../../../providers/post_requests/product_body.dart';
import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../utils/constants/themes.dart';
import '../../../utils/repeated_days_generator/schedule_generator.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/calendar_picker/calendar_picker.dart';
import '../../../widgets/calendar_picker/src/default_styles.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/overlays/constrained_scrollview.dart';
import '../../../widgets/photo_box.dart';
import '../../../widgets/schedule_picker.dart';
import 'components/product_header.dart';
import 'product_preview.dart';

enum ProductScheduleState { shop, custom }

class ProductSchedule extends StatefulWidget {
  const ProductSchedule({
    Key? key,
    required this.images,
    this.productId,
  }) : super(key: key);

  // final AddProductGallery gallery;
  final List<PhotoBoxImageSource> images;
  final String? productId;

  @override
  _ProductScheduleState createState() => _ProductScheduleState();
}

class _ProductScheduleState extends State<ProductSchedule> {
  ProductScheduleState _productSchedule = ProductScheduleState.shop;
  Set<DateTime> _markedDatesMap = {};
  Set<DateTime> _selectableDates = {};
  Set<int> _markedWeekdays = {};
  Set<int> _selectableWeekdays = {1, 2, 3, 4, 5, 6, 7};

  @override
  void initState() {
    super.initState();
    final _generator = ScheduleGenerator();
    OperatingHours? _operatingHours;
    final user = context.read<Auth>().user!;
    final shops = context.read<Shops>().findByUser(user.id);
    _operatingHours = shops.first.operatingHours;

    final _schedule = _generator.generateSchedule(_operatingHours);
    _selectableDates = _schedule.selectableDates.toSet();
    _markedDatesMap = {..._selectableDates};

    // _selectableWeekdays = _schedule.selectableDays.toSet();
    if (_schedule.repeatType == RepeatChoices.week) {
      _selectableWeekdays = _schedule.selectableDays.toSet();
    }
    _markedWeekdays = {..._selectableWeekdays};

    if (widget.productId != null && widget.productId!.isNotEmpty) {
      final product = context.read<Products>().findById(widget.productId);
      if (product != null) {
        final _productSched = product.availability;
        final _productSelectableDates =
            _generator.getSelectableDates(_productSched);

        _markedDatesMap = {..._productSelectableDates};
        if (_selectableDates
            .toSet()
            .difference(_productSelectableDates.toSet())
            .isEmpty) {
          _productSchedule = ProductScheduleState.shop;
        } else {
          _markedWeekdays.clear();
          for (int i = 1; i <= 7; i++) {
            if (_productSelectableDates.any((date) => date.weekday == i)) {
              _markedWeekdays.add(i);
            }
          }
          _productSchedule = ProductScheduleState.custom;
        }
      }
    }
  }

  Widget _buildRadioTile() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: kTealColor),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            color: _productSchedule == ProductScheduleState.shop
                ? kTealColor
                : Colors.transparent,
          ),
          child: RadioListTile<ProductScheduleState>(
            dense: true,
            title: Text(
              'Follow Shop Schedule',
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    color: _productSchedule == ProductScheduleState.shop
                        ? Colors.white
                        : kTealColor,
                  ),
            ),
            value: ProductScheduleState.shop,
            groupValue: _productSchedule,
            onChanged: (value) {
              setState(() {
                _productSchedule = ProductScheduleState.shop;
              });
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: kTealColor),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            color: _productSchedule == ProductScheduleState.custom
                ? kTealColor
                : Colors.transparent,
          ),
          child: RadioListTile<ProductScheduleState>(
            dense: true,
            title: Text(
              'Set Custom Schedule',
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    color: _productSchedule == ProductScheduleState.custom
                        ? Colors.white
                        : kTealColor,
                  ),
            ),
            value: ProductScheduleState.custom,
            groupValue: _productSchedule,
            onChanged: (value) {
              setState(() {
                _productSchedule = ProductScheduleState.custom;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildBody() {
    final horizontalPadding = MediaQuery.of(context).size.width * 0.05;
    final topPadding = MediaQuery.of(context).size.height * 0.03;
    final image = widget.images.isNotEmpty
        ? widget.images.first
        : const PhotoBoxImageSource();

    return ConstrainedScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          topPadding,
          horizontalPadding,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<ProductBody>(
              builder: (context, product, child) {
                return ProductHeader(
                  productHeaderImageSource: image,
                  productName: product.name ?? '',
                  productPrice: product.basePrice ?? 0.0,
                  productStock: product.quantity ?? 0,
                );
              },
            ),
            const SizedBox(height: 24),
            _buildRadioTile(),
            const SizedBox(height: 23),
            Visibility(
              visible: _productSchedule == ProductScheduleState.custom,
              child: Text(
                'You can only select the dates that your shop is open.',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            SizedBox(
              height: _productSchedule == ProductScheduleState.custom ? 23 : 0,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: _productSchedule == ProductScheduleState.custom
                  ? CalendarPicker(
                      onDayPressed: (date) {
                        final now =
                            DateTime.now().subtract(const Duration(days: 1));
                        if (date.isBefore(now)) return;
                        setState(() {
                          if (_markedDatesMap.contains(date)) {
                            _markedDatesMap.remove(date);
                          } else {
                            _markedDatesMap.add(date);
                          }
                        });
                      },
                      markedDates:
                          _markedDatesMap.whereType<DateTime>().toList(),
                      selectableDates:
                          _selectableDates.whereType<DateTime>().toList(),
                      weekdayWidgetBuilder: (weekday) => _WeekdayWidgetBuilder(
                        weekday: weekday,
                        dateFormat: DateFormat.yMMM(Intl.defaultLocale),
                        isSelectable: _selectableWeekdays.contains(weekday),
                        isMarked: _markedWeekdays.contains(weekday),
                        onPressed: () {
                          if (!_selectableWeekdays.contains(weekday)) {
                            return;
                          }

                          setState(() {
                            if (_markedWeekdays.contains(weekday)) {
                              _markedWeekdays.remove(weekday);
                              _markedDatesMap.removeWhere(
                                (date) => date.weekday == weekday,
                              );
                            } else {
                              _markedWeekdays.add(weekday);

                              _markedDatesMap.addAll(
                                _selectableDates.where((date) {
                                  final now = DateTime.now();
                                  return date.weekday == weekday &&
                                      DateTime(date.year, date.month, date.day)
                                              .difference(
                                                DateTime(
                                                  now.year,
                                                  now.month,
                                                  now.day,
                                                ),
                                              )
                                              .inDays >
                                          0;
                                }),
                              );
                            }
                          });
                        },
                      ),
                    )
                  : null,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppButton.filled(
                text: 'Confirm',
                onPressed: () {
                  setupProductAvailability();
                  Navigator.push(
                    context,
                    AppNavigator.appPageRoute(
                      builder: (_) => ProductPreview(
                        images: widget.images,
                        scheduleState: _productSchedule,
                        productId: widget.productId,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setupProductAvailability() {
    final operatingHours = context.read<OperatingHoursBody>();
    final user = context.read<Auth>().user!;
    final shops = context.read<Shops>().findByUser(user.id);
    final shopSchedule = shops.first.operatingHours;
    final unavailableDates = _selectableDates
        .where((date) => !_markedDatesMap.contains(date))
        .toList();
    operatingHours.clear();
    operatingHours.update(
      startTime: shopSchedule.startTime,
      endTime: shopSchedule.endTime,
      repeatType: shopSchedule.repeatType,
      repeatUnit: shopSchedule.repeatUnit,
      startDates: [...shopSchedule.startDates],
      customDates: [...shopSchedule.customDates],
      unavailableDates: [
        ...{
          ...shopSchedule.unavailableDates,
          ...unavailableDates
              .map((date) => DateFormat('yyyy-MM-dd').format(date))
              .toList(),
        }
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        titleText: 'Product Schedule',
      ),
      body: buildBody(),
    );
  }
}

class _WeekdayWidgetBuilder extends StatelessWidget {
  const _WeekdayWidgetBuilder({
    Key? key,
    required this.weekday,
    required this.dateFormat,
    this.isMarked = false,
    this.isSelectable = true,
    this.onPressed,
  }) : super(key: key);

  final int weekday;
  final DateFormat dateFormat;

  final bool isMarked;
  final bool isSelectable;
  // final bool isSelected = false;

  final VoidCallback? onPressed;

  TextStyle getDefaultDayStyle() {
    if (!isSelectable) return defaultInactiveDaysTextStyle;
    return defaultDaysTextStyle;
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.transparent;
    Color buttonColor = Colors.transparent;

    if (isMarked) {
      if (!isSelectable) {
        borderColor = buttonColor = Colors.pink;
      } else {
        borderColor = buttonColor = Colors.orange;
      }
    } else if (isSelectable) {
      borderColor = Colors.grey.shade300;
    }

    const EdgeInsets margin = EdgeInsets.all(1.0);
    const EdgeInsets padding = EdgeInsets.all(3.0);
    final TextStyle _style = getDefaultDayStyle();

    final werapWeekday = weekday % 7;
    final msg = dateFormat.dateSymbols.STANDALONENARROWWEEKDAYS[werapWeekday];

    return Expanded(
      child: Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: buttonColor,
            shape: const CircleBorder(
              side: BorderSide(color: Colors.transparent),
            ),
          ),
          child: Center(
            child: Text(
              msg,
              semanticsLabel: msg,
              style: _style,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
