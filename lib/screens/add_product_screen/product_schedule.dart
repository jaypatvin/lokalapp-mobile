import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:lokalapp/providers/post_requests/operating_hours_body.dart';
import '../../utils/repeated_days_generator/repeated_days_generator.dart';
import 'package:provider/provider.dart';

import '../../models/operating_hours.dart';
import '../../providers/post_requests/product_body.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../utils/calendar_picker/calendar_picker.dart';
import '../../utils/functions.utils.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/rounded_button.dart';
import '../add_shop_screens/shop_schedule/repeat_choices.dart';
import 'components/add_product_gallery.dart';
import 'components/product_header.dart';
import 'product_preview.dart';

class ProductSchedule extends StatefulWidget {
  final AddProductGallery gallery;
  ProductSchedule({@required this.gallery});
  @override
  _ProductScheduleState createState() => _ProductScheduleState();
}

enum ProductScheduleState { shop, custom }

class _ProductScheduleState extends State<ProductSchedule> {
  ProductScheduleState _productSchedule;
  List<DateTime> _markedDatesMap = [];

  List<DateTime> _selectableDates = [];

  Widget buildRadioTile() {
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
              title: Text(
                "Follow Shop Schedule",
                style: kTextStyle.copyWith(
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
              }),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: kTealColor),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            color: _productSchedule == ProductScheduleState.custom
                ? kTealColor
                : Colors.transparent,
          ),
          child: RadioListTile<ProductScheduleState>(
              title: Text(
                "Set Custom Schedule",
                style: kTextStyle.copyWith(
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
              }),
        ),
      ],
    );
  }

  Widget buildBody() {
    var horizontalPadding = MediaQuery.of(context).size.width * 0.05;
    var topPadding = MediaQuery.of(context).size.height * 0.03;
    var image = widget.gallery.photoBoxes.first;

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
            buildRadioTile(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Visibility(
              visible: _productSchedule == ProductScheduleState.custom,
              child: Text(
                "You can only select the dates that your shop is open.",
                style: kTextStyle,
              ),
            ),
            SizedBox(
              height: _productSchedule == ProductScheduleState.custom
                  ? MediaQuery.of(context).size.height * 0.02
                  : 0,
            ),
            Visibility(
              visible: _productSchedule == ProductScheduleState.custom,
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
            RoundedButton(
              label: "Next",
              height: 10,
              minWidth: double.infinity,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: "GoldplayBold",
              fontColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProductPreview(
                      gallery: widget.gallery,
                      scheduleState: _productSchedule,
                    ),
                  ),
                );
              },
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
    var operatingHours =
        Provider.of<OperatingHoursBody>(context, listen: false);
    var user = Provider.of<CurrentUser>(context, listen: false);
    var shops = Provider.of<Shops>(context, listen: false).findByUser(user.id);
    var shopSchedule = shops.first.operatingHours;
    var customDates = _markedDatesMap
        .where((date) => !_selectableDates.contains(date))
        .toList();
    var unavailableDates = _selectableDates
        .where((date) => !_markedDatesMap.contains(date))
        .toList();
    operatingHours.clear();
    operatingHours.update(
      startTime: shopSchedule.startTime,
      endTime: shopSchedule.endTime,
      repeatType: shopSchedule.repeatType,
      repeatUnit: shopSchedule.repeatUnit,
      startDates: shopSchedule.startDates,
      customDates: customDates
          .map((date) =>
              CustomDates(date: DateFormat("yyyy-MM-dd").format(date)))
          .toList(),
      unavailableDates: unavailableDates
          .map((date) => DateFormat("yyyy-MM-dd").format(date))
          .toList(),
    );
  }

  @override
  initState() {
    // TODO: remove programmatically generated selectable dates
    super.initState();

    OperatingHours _operatingHours;
    var user = Provider.of<CurrentUser>(context, listen: false);
    var shops = Provider.of<Shops>(context, listen: false).findByUser(user.id);
    if (shops.isNotEmpty) _operatingHours = shops.first.operatingHours;
    bool validOperatingHours = isValidOperatingHours(_operatingHours);

    if (validOperatingHours) {
      RepeatChoices repeatChoice;
      bool isNDays;
      var repeatType = _operatingHours.repeatType;
      if (repeatType.split("-").length > 1) {
        isNDays = true;
        repeatChoice = RepeatChoices.month;
      }
      RepeatChoices.values.forEach((element) {
        if (element.value.toLowerCase() == _operatingHours.repeatType) {
          repeatChoice = element;
        }
      });

      var repeatUnit = _operatingHours.repeatUnit;
      var startDate = DateFormat("yyyy-MM-dd").parse(
        _operatingHours.startDates.first,
      );
      var dayGenerator = RepeatedDaysGenerator.instance;
      switch (repeatChoice) {
        case RepeatChoices.day:
          _selectableDates = dayGenerator.getRepeatedDays(
            startDate: startDate,
            everyNDays: repeatUnit,
            validate: _operatingHours == null,
          );
          break;
        case RepeatChoices.week:
          var selectableDays = <int>[];
          _operatingHours.startDates.forEach((element) {
            var date = DateFormat("yyyy-MM-dd").parse(element);
            var weekday = date.weekday;
            if (weekday == 7) weekday = 0;
            selectableDays.add(weekday);
          });
          _selectableDates = dayGenerator.getRepeatedWeekDays(
            startDate: startDate,
            everyNWeeks: repeatUnit,
            selectedDays: selectableDays,
            validate: _operatingHours == null,
          );
          var startDates = <String>[];
          for (int i = 0; i < selectableDays.length; i++) {
            startDates
                .add(DateFormat("yyyy-MM-dd").format(_selectableDates[i]));
          }
          break;
        case RepeatChoices.month:
          if (isNDays) {
            var type = _operatingHours.repeatType.split("-");
            _selectableDates = dayGenerator.getRepeatedMonthDaysByNthDay(
              everyNMonths: _operatingHours.repeatUnit,
              ordinal: int.parse(type[0]),
              weekday: en_USSymbols.SHORTWEEKDAYS.indexOf(type[1].capitalize()),
              month: DateTime.now().month,
            );
          } else {
            _selectableDates = dayGenerator.getRepeatedMonthDaysByStartDate(
              startDate: startDate,
              everyNMonths: repeatUnit,
              validate: _operatingHours == null,
            );
          }

          break;
        default:
          // do nothing
          break;
      }

      var unavailableDates = <DateTime>[];
      _operatingHours.unavailableDates.forEach((element) {
        unavailableDates.add(DateFormat("yyyy-MM-dd").parse(element));
      });
      _selectableDates
          .removeWhere((element) => unavailableDates.contains(element));

      _operatingHours.customDates.forEach((element) {
        var date = DateFormat("yyyy-MM-dd").parse(element.date);
        if (!_selectableDates.contains(date)) {
          _selectableDates.add(date);
        }
      });
      _markedDatesMap.addAll(_selectableDates);
    } else {
      // nothing to do here so far
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
