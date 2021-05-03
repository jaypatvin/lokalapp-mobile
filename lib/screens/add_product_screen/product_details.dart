import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/post_requests/product_body.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/rounded_button.dart';
import 'components/add_product_gallery.dart';
import 'components/product_header.dart';
import 'product_schedule.dart';

class ProductDetails extends StatefulWidget {
  final AddProductGallery gallery;
  ProductDetails({@required this.gallery});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool forDelivery = false;
  bool forPickup = false;

  Widget buildCategories() {
    var productBody = Provider.of<ProductBody>(context, listen: false);
    return Row(
      children: [
        Text(
          "Product Category",
          style: kTextStyle,
        ),
        Spacer(),
        Container(
          width: MediaQuery.of(context).size.width * 0.55,
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.grey.shade200)),
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              isExpanded: true,
              iconEnabledColor: kTealColor,
              iconDisabledColor: kTealColor,
              underline: SizedBox(),
              value: productBody
                  .productCategory, //user.postProduct.productCategory,
              hint: Text(
                "Select",
                style: TextStyle(
                    color: Colors.grey.shade400, fontFamily: "Goldplay"),
              ),
              items: <String>['A', 'B', 'C', 'D'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (value) => productBody.update(productCategory: value),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCurrentStock() {
    return Row(
      children: [
        Text(
          "Current Stock",
          style: kTextStyle,
        ),
        Spacer(),
        Container(
          width: MediaQuery.of(context).size.width * 0.55,
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.grey.shade200)),
          child: TextField(
            cursorColor: Colors.black,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
              hintText: "PHP",
            ),
            onChanged: (value) {
              Provider.of<ProductBody>(context, listen: false)
                  .update(quantity: int.tryParse(value) ?? 0);
            },
            style: kTextStyle,
          ),
        )
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
        physics: NeverScrollableScrollPhysics(),
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
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            buildCategories(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            buildCurrentStock(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(
              "Delivery Options",
              style: kTextStyle,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.48,
                  child: CheckboxListTile(
                    value: forPickup,
                    onChanged: (value) {
                      setState(() {
                        forPickup = value;
                      });
                    },
                    title: Text(
                      "Customer Pick-up",
                      style: kTextStyle.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.42,
                  child: CheckboxListTile(
                    value: forDelivery,
                    onChanged: (value) {
                      setState(() {
                        forDelivery = value;
                      });
                    },
                    title: Text(
                      "Delivery",
                      style: kTextStyle.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              ],
            ),
            SizedBox(
              // TODO: modify to accomodate bottom navbar
              height: MediaQuery.of(context).size.height * 0.25,
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
                // TODO: go to Product Schedule Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ProductSchedule(gallery: widget.gallery),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(
        titleText: "Product Details",
        onPressedLeading: () {
          Navigator.pop(context);
        },
      ),
      body: buildBody(),
    );
  }
}
