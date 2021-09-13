import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';

import '../../models/operating_hours.dart';
import '../../providers/post_requests/operating_hours_body.dart';
import '../../providers/post_requests/shop_body.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../services/local_image_service.dart';
import '../../utils/calendar_picker/calendar_picker.dart';
import '../../utils/repeated_days_generator/repeated_days_generator.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/rounded_button.dart';
import 'shop_confirmation.dart';
import 'shop_schedule/repeat_choices.dart';

import "../../utils/functions.utils.dart";

class CustomizeAvailability extends StatefulWidget {
  final RepeatChoices repeatChoice;
  final int repeatEvery;
  final List selectableDays;
  final DateTime startDate;
  final File shopPhoto;
  final bool usedDatePicker;
  final bool forEditing;
  final Function onShopEdit;

  const CustomizeAvailability({
    @required this.repeatChoice,
    @required this.selectableDays,
    @required this.startDate,
    @required this.repeatEvery,
    @required this.usedDatePicker,
    this.shopPhoto,
    this.forEditing = false,
    this.onShopEdit,
  });
  @override
  _CustomizeAvailabilityState createState() => _CustomizeAvailabilityState();
}

class _CustomizeAvailabilityState extends State<CustomizeAvailability> {
  List<DateTime> initialDates;
  List<DateTime> markedDates;
  bool _shopCreated = false;

  @override
  initState() {
    super.initState();

    OperatingHours _operatingHours;
    var user = Provider.of<CurrentUser>(context, listen: false);
    var shops = Provider.of<Shops>(context, listen: false).findByUser(user.id);
    if (shops.isNotEmpty) _operatingHours = shops.first.operatingHours;

    var dayGenerator = RepeatedDaysGenerator.instance;
    switch (widget.repeatChoice) {
      case RepeatChoices.day:
        initialDates = dayGenerator.getRepeatedDays(
          startDate: widget.startDate,
          everyNDays: widget.repeatEvery,
          validate: _operatingHours == null,
        );
        break;
      case RepeatChoices.week:
        initialDates = dayGenerator.getRepeatedWeekDays(
          startDate: widget.startDate,
          everyNWeeks: widget.repeatEvery,
          selectedDays: widget.selectableDays,
          validate: _operatingHours == null,
        );
        var startDates = <String>[];
        for (int i = 0; i < widget.selectableDays.length; i++) {
          startDates.add(DateFormat("yyyy-MM-dd").format(initialDates[i]));
        }
        Provider.of<OperatingHoursBody>(context, listen: false)
            .update(startDates: [...startDates]);
        break;
      case RepeatChoices.month:
        if (widget.usedDatePicker) {
          initialDates = dayGenerator.getRepeatedMonthDaysByStartDate(
            startDate: widget.startDate,
            everyNMonths: widget.repeatEvery,
            validate: _operatingHours == null,
          );
        } else {
          var provider =
              Provider.of<OperatingHoursBody>(context, listen: false);
          var type = provider.operatingHours.repeatType.split("-");
          initialDates = dayGenerator.getRepeatedMonthDaysByNthDay(
            everyNMonths: widget.repeatEvery,
            ordinal: int.parse(type[0]),
            weekday: en_USSymbols.SHORTWEEKDAYS.indexOf(type[1].capitalize()),
            month: DateTime.now().month,
          );
        }

        break;
      default:
        // do nothing
        break;
    }
    markedDates = [...initialDates];

    bool validOperatingHours = _operatingHours != null &&
        _operatingHours.startTime.isNotEmpty &&
        _operatingHours.endTime.isNotEmpty &&
        _operatingHours.repeatUnit > 0 &&
        _operatingHours.repeatType.isNotEmpty &&
        _operatingHours.startDates.isNotEmpty;

    if (validOperatingHours) {
      var unavailableDates = <DateTime>[];
      _operatingHours.unavailableDates.forEach((element) {
        unavailableDates.add(DateFormat("yyyy-MM-dd").parse(element));
      });
      markedDates.removeWhere((element) => unavailableDates.contains(element));

      _operatingHours.customDates.forEach((element) {
        var date = DateFormat("yyyy-MM-dd").parse(element.date);
        if (!markedDates.contains(date)) {
          markedDates.add(date);
        }
      });
    }
  }

  Future<List<DateTime>> showCalendarPicker() async {
    List<DateTime> selectedDates = [...markedDates];
    return await showDialog<List<DateTime>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    "Start Date",
                    style: kTextStyle.copyWith(
                      fontSize: 24.0,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.56,
                    padding: EdgeInsets.all(5.0),
                    child: CalendarCarousel(
                      width: MediaQuery.of(context).size.width * 0.95,
                      startDate:
                          widget.startDate.difference(DateTime.now()).inDays >=
                                  0
                              ? widget.startDate
                              : DateTime.now(),
                      onDayPressed: (day) {
                        setState(() {
                          if (selectedDates.contains(day))
                            selectedDates.remove(day);
                          else
                            selectedDates.add(day);
                        });
                      },
                      markedDatesMap: selectedDates,
                      selectableDaysMap:
                          widget.repeatChoice == RepeatChoices.week
                              ? widget.selectableDays
                              : [1, 2, 3, 4, 5, 6, 0],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.05),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RoundedButton(
                          label: "Cancel",
                          color: Color(
                            0xFFF1FAFF,
                          ),
                          onPressed: () {
                            Navigator.pop(context, markedDates);
                          },
                        ),
                        RoundedButton(
                          label: "Confirm",
                          fontColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              markedDates = selectedDates;
                            });

                            Navigator.pop(context, markedDates);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
              CustomDates(date: DateFormat("yyyy-MM-dd").format(date)))
          .toList(),
      unavailableDates: unavailableDates
          .map((date) => DateFormat("yyyy-MM-dd").format(date))
          .toList(),
    );
  }

  Future<bool> updateShopSchedule() async {
    var user = Provider.of<CurrentUser>(context, listen: false);
    var shops = Provider.of<Shops>(context, listen: false);
    var userShop = shops.findByUser(user.id).first;
    var operatingHours =
        Provider.of<OperatingHoursBody>(context, listen: false);
    return await shops.setOperatingHours(
      id: userShop.id,
      data: operatingHours.data,
    );
  }

  Future<bool> createShop() async {
    if (_shopCreated) return true;
    var file = widget.shopPhoto;
    String mediaUrl = "";
    if (file != null) {
      mediaUrl = await Provider.of<LocalImageService>(context, listen: false)
          .uploadImage(file: file, name: 'shop_photo');
    }
    CurrentUser user = Provider.of<CurrentUser>(context, listen: false);
    ShopBody shopBody = Provider.of<ShopBody>(context, listen: false);
    Shops shops = Provider.of<Shops>(context, listen: false);

    shopBody.update(
      profilePhoto: mediaUrl,
      userId: user.id,
      communityId: user.communityId,
    );

    try {
      bool success = await shops.create(shopBody.data);
      if (success) {
        await shops.fetch();
        return true;
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
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
              style: kTextStyle.copyWith(fontSize: 24.0),
            ),
            Text(
              "Customize which days your shop will be available",
              style: kTextStyle.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 18.0,
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            RoundedButton(
              textAlign: TextAlign.start,
              minWidth: double.infinity,
              label: "Customize Availability",
              onPressed: showCalendarPicker,
              color: Color(0xFFF1FAFF),
            ),
            Spacer(),
            RoundedButton(
              label: "Confirm",
              height: 10,
              minWidth: double.infinity,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: "GoldplayBold",
              fontColor: Colors.white,
              onPressed: () async {
                setUpShotSchedule();
                if (widget.forEditing) {
                  if (widget.onShopEdit != null) widget.onShopEdit();
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                  return;
                }
                _shopCreated = await createShop();
                if (_shopCreated) {
                  bool updated = await updateShopSchedule();
                  if (updated) {
                    context.read<Shops>().fetch();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AddShopConfirmation(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text("Failed to upload shop schedule. Try again"),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to create shop. Try again"),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
