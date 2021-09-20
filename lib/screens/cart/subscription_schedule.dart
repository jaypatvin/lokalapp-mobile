import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../utils/repeated_days_generator/schedule_generator.dart';
import '../../utils/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/schedule_picker.dart';

/// Subscription Schedule Screen
class SubscriptionSchedule extends StatefulWidget {
  /// This needs the order to be able to successfully create a subscription
  SubscriptionSchedule({
    @required this.productId,
    @required this.order,
    Key key,
  }) : super(key: key);

  final String productId;
  final ProductOrderDetails order;

  @override
  _SubscriptionScheduleState createState() => _SubscriptionScheduleState();
}

class _SubscriptionScheduleState extends State<SubscriptionSchedule> {
  final _generator = ScheduleGenerator();
  List<int> _selectableDays = [];
  DateTime _startDate;

  String _repeatType;
  int _repeatUnit;

  void _onSelectableDaysChanged(List<int> selectableDays) {
    this._selectableDays = selectableDays;
  }

  void _onStartDateChanged(DateTime startDate, {String repeatType}) {
    this._startDate = startDate;
    this._repeatType = repeatType;
  }

  RepeatChoices _getRepeatChoice() {
    var repeatChoice = RepeatChoices.month;
    if (_repeatType.split("-").length <= 1) {
      RepeatChoices.values.forEach((choice) {
        if (choice.value.toLowerCase() == _repeatType) {
          repeatChoice = choice;
        }
      });
    }
    return repeatChoice;
  }

  Widget _buildProducts() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.order.quantity,
      itemBuilder: (BuildContext context, int index) {
        final Product product = Provider.of<Products>(
          context,
          listen: false,
        ).findById(widget.productId);
        return _ProductCard(
          product: product,
          quantity: widget.order.quantity,
          onEditTap: null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Subscription Schedule',
        titleStyle: const TextStyle(color: Colors.black),
        onPressedLeading: () => Navigator.of(context).pop(),
        leadingColor: Colors.black,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildProducts(),
              SizedBox(height: 10.0.h),
              SchedulePicker(
                header: "Schedule",
                description:
                    "Which dates do you want this product to be delivered?",
                onRepeatTypeChanged: (choice) => _repeatType = choice,
                onStartdatesChanged: null,
                onRepeatUnitChanged: (repeatUnit) => _repeatUnit = repeatUnit,
                onStartDateChanged: _onStartDateChanged,
                onSelectableDaysChanged: _onSelectableDaysChanged,
              ),
              SizedBox(height: 10.0.h),
              SizedBox(
                height: 50.0.h,
                width: double.infinity,
                child: AppButton(
                  "Next",
                  kTealColor,
                  true,
                  () {
                    final _dates = _generator.generateInitialDates(
                      repeatChoice: _getRepeatChoice(),
                      repeatEveryNUnit: _repeatUnit,
                      startDate: _startDate,
                      selectableDays: _selectableDays,
                      repeatType: _repeatType,
                    );
                    print(_dates);
                  },
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

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    Key key,
    @required this.product,
    @required this.quantity,
    @required this.onEditTap,
  }) : super(key: key);

  final Product product;
  final int quantity;
  final void Function() onEditTap;

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
                  if (product.gallery.isNotEmpty)
                    SizedBox(
                      width: 80.0.h,
                      height: 80.0.h,
                      child: Image.network(
                        product.gallery.first.url,
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
                                product.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: false,
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                  fontFamily: "Goldplay",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.0.w),
                            Text(
                              product.basePrice.toString(),
                              // textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 16.0.sp,
                                  fontFamily: "Goldplay",
                                  fontWeight: FontWeight.w700,
                                  color: kOrangeColor),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0.h),
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
