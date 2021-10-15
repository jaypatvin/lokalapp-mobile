import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/operating_hours.dart';
import '../../providers/post_requests/operating_hours_body.dart';
import '../../providers/post_requests/product_body.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../utils/calendar_picker/calendar_picker.dart';
import '../../utils/repeated_days_generator/schedule_generator.dart';
import '../../utils/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import 'components/add_product_gallery.dart';
import 'components/product_header.dart';
import 'product_preview.dart';

class ProductSchedule extends StatefulWidget {
  final AddProductGallery? gallery;
  final String? productId;
  ProductSchedule({required this.gallery, this.productId});
  @override
  _ProductScheduleState createState() => _ProductScheduleState();
}

enum ProductScheduleState { shop, custom }

class _ProductScheduleState extends State<ProductSchedule> {
  ProductScheduleState? _productSchedule;
  List<DateTime?> _markedDatesMap = [];
  List<DateTime?> _selectableDates = [];

  Widget _buildRadioTile() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: kTealColor),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            color: _productSchedule == ProductScheduleState.shop
                ? kTealColor
                : Colors.transparent,
          ),
          child: RadioListTile<ProductScheduleState>(
            dense: true,
            title: Text(
              "Follow Shop Schedule",
              style: Theme.of(context).textTheme.headline6!.copyWith(
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
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0.r),
              bottomRight: Radius.circular(30.0.r),
            ),
            color: _productSchedule == ProductScheduleState.custom
                ? kTealColor
                : Colors.transparent,
          ),
          child: RadioListTile<ProductScheduleState>(
            dense: true,
            title: Text(
              "Set Custom Schedule",
              style: Theme.of(context).textTheme.headline6!.copyWith(
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
    var horizontalPadding = MediaQuery.of(context).size.width * 0.05;
    var topPadding = MediaQuery.of(context).size.height * 0.03;
    var image = widget.gallery!.photoBoxes.first;

    return Container(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        topPadding,
        horizontalPadding,
        0,
      ),
      child: SingleChildScrollView(
        //physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<ProductBody>(builder: (context, product, child) {
              return ProductHeader(
                photoBox: image,
                productName: product.name,
                productPrice: product.basePrice,
                productStock: product.quantity,
              );
            }),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _buildRadioTile(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Visibility(
              visible: _productSchedule == ProductScheduleState.custom,
              child: Text(
                "You can only select the dates that your shop is open.",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            SizedBox(
              height: _productSchedule == ProductScheduleState.custom
                  ? MediaQuery.of(context).size.height * 0.02
                  : 0,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _productSchedule == ProductScheduleState.custom
                  ? MediaQuery.of(context).size.height * 0.65
                  : 0,
              child: CalendarCarousel(
                onDayPressed: (date) {
                  var now = DateTime.now().subtract(Duration(days: 1));
                  if (date.isBefore(now)) return;
                  this.setState(() {
                    if (_markedDatesMap.contains(date)) {
                      _markedDatesMap.remove(date);
                    } else {
                      _markedDatesMap.add(date);
                    }
                  });
                },
                markedDatesMap: _markedDatesMap,
                height: MediaQuery.of(context).size.height * 0.55,
                selectableDates: _selectableDates,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                "Confirm",
                kTealColor,
                true,
                () {
                  setupProductAvailability();
                  pushNewScreen(
                    context,
                    screen: ProductPreview(
                      gallery: widget.gallery,
                      scheduleState: _productSchedule,
                      productId: widget.productId,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            )
          ],
        ),
      ),
    );
  }

  void setupProductAvailability() {
    final operatingHours = context.read<OperatingHoursBody>();
    final user = context.read<CurrentUser>();
    final shops = context.read<Shops>().findByUser(user.id);
    final shopSchedule = shops.first.operatingHours!;
    final unavailableDates = _selectableDates
        .where((date) => !_markedDatesMap.contains(date))
        .toList();
    operatingHours.clear();
    operatingHours.update(
        startTime: shopSchedule.startTime,
        endTime: shopSchedule.endTime,
        repeatType: shopSchedule.repeatType,
        repeatUnit: shopSchedule.repeatUnit,
        startDates: shopSchedule.startDates,
        customDates: [
          ...shopSchedule.customDates!
        ],
        unavailableDates: [
          ...{
            ...shopSchedule.unavailableDates!,
            ...unavailableDates
                .map((date) => DateFormat("yyyy-MM-dd").format(date!))
                .toList(),
          }
        ]);
  }

  @override
  initState() {
    super.initState();
    final _generator = ScheduleGenerator();
    OperatingHours? _operatingHours;
    final user = context.read<CurrentUser>();
    final shops = context.read<Shops>().findByUser(user.id);
    if (shops.isNotEmpty) _operatingHours = shops.first.operatingHours;

    final _selectableDates = _generator.getSelectableDates(_operatingHours!);

    this._selectableDates = _selectableDates;
    this._markedDatesMap = [..._selectableDates];

    if (widget.productId != null && widget.productId!.isNotEmpty) {
      final product = context.read<Products>().findById(widget.productId);
      if (product != null) {
        final _productSched = product.availability!;
        final _productSelectableDates =
            _generator.getSelectableDates(_productSched);

        this._markedDatesMap = [..._productSelectableDates];
        if (_selectableDates
            .toSet()
            .difference(_productSelectableDates.toSet())
            .isEmpty) {
          this._productSchedule = ProductScheduleState.shop;
        } else {
          this._productSchedule = ProductScheduleState.custom;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        titleText: "Product Schedule",
        onPressedLeading: () {
          Navigator.pop(context);
        },
      ),
      body: buildBody(),
    );
  }
}
