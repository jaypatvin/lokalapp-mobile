import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/post_requests/product_body.dart';
import '../../utils/calendar_picker/calendar_picker.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/rounded_button.dart';
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
  List<DateTime> _markedDateMap = [];

  // TODO: implement this logic to a common shop-product schedule
  List<int> _selectableDaysMap = [];

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
                    if (_markedDateMap.contains(date)) {
                      _markedDateMap.remove(date);
                    } else {
                      _markedDateMap.add(date);
                    }
                  });
                },
                markedDatesMap: _markedDateMap,
                height: MediaQuery.of(context).size.height * 0.55,
                selectableDaysMap: _selectableDaysMap,
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
                    builder: (BuildContext context) =>
                        ProductPreview(gallery: widget.gallery),
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

  @override
  initState() {
    // TODO: remove programmatically generated selectable dates

    _selectableDaysMap.addAll([1, 2, 3, 4, 5, 6]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(
        titleText: "Product Schedule",
        onPressedLeading: () {
          Navigator.pop(context);
        },
      ),
      body: buildBody(),
    );
  }
}
