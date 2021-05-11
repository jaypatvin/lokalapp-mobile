import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../../models/operating_hours.dart';
import '../../providers/post_requests/operating_hours_body.dart';
import 'package:provider/provider.dart';

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

class CustomizeAvailability extends StatefulWidget {
  final RepeatChoices repeatChoice;
  final int repeatEvery;
  final List selectableDays;
  final DateTime startDate;
  final File shopPhoto;

  const CustomizeAvailability({
    @required this.repeatChoice,
    @required this.selectableDays,
    @required this.startDate,
    @required this.repeatEvery,
    this.shopPhoto,
  });
  @override
  _CustomizeAvailabilityState createState() => _CustomizeAvailabilityState();
}

class _CustomizeAvailabilityState extends State<CustomizeAvailability> {
  List<DateTime> initialDates;
  List<DateTime> markedDates;

  @override
  initState() {
    super.initState();
    var dayGenerator = RepeatedDaysGenerator.instance;
    switch (widget.repeatChoice) {
      case RepeatChoices.days:
        initialDates = dayGenerator.getRepeatedDays(
          startDate: widget.startDate,
          everyNDays: widget.repeatEvery,
        );
        break;
      case RepeatChoices.weeks:
        initialDates = dayGenerator.getRepeatedWeekDays(
          startDate: widget.startDate,
          everyNWeeks: widget.repeatEvery,
          selectedDays: widget.selectableDays,
        );
        var startDates = <String>[];
        for (int i = 0; i < widget.selectableDays.length; i++) {
          startDates.add(DateFormat("yyyy-MM-dd").format(initialDates[i]));
        }
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Provider.of<OperatingHoursBody>(context, listen: false)
              .update(startDates: [...startDates]);
        });
        break;
      case RepeatChoices.months:
        initialDates = dayGenerator.getRepeatedMonthDays(
          startDate: widget.startDate,
          everyNMonths: widget.repeatEvery,
        );
        break;
      default:
        // do nothing
        break;
    }
    markedDates = [...initialDates];
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
                          widget.repeatChoice == RepeatChoices.weeks
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
                            // TODO: update provider
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

  Future<bool> updateShopSchedule() async {
    markedDates.sort();
    initialDates.sort();
    var user = Provider.of<CurrentUser>(context, listen: false);
    var shops = Provider.of<Shops>(context, listen: false);
    var userShop = shops.findByUser(user.id).first;
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

    var data = operatingHours.data;
    return await shops.setOperatingHours(
      id: userShop.id,
      authToken: user.idToken,
      data: data,
    );
  }

  Future<bool> createShop() async {
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
      bool success = await shops.create(user.idToken, shopBody.data);
      if (success) {
        bool updated = await updateShopSchedule();
        if (!updated) return false;

        shops.fetch(user.idToken);
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
      appBar: customAppBar(
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
                var success = await createShop();

                if (success) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => AddShopConfirmation(),
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
