import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../../providers/post_requests/product_body.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/inputs/input_name_field.dart';
import '../components/add_product_gallery.dart';
import '../components/product_header.dart';
import 'product_add_ons_2.dart';

class NewAddOn extends StatefulWidget {
  final AddProductGallery gallery;
  NewAddOn({required this.gallery});
  @override
  _NewAddOnState createState() => _NewAddOnState();
}

class _NewAddOnState extends State<NewAddOn> {
  final TextStyle productTextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: "Goldplay",
    fontSize: 16.0,
  );
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
            Text(
              "Add-on Name",
              style: productTextStyle,
            ),
            InputNameField(
              onChanged: (value) {
                Provider.of<ProductBody>(context, listen: false)
                    .update(name: value);
              },
              hintText: "Marshmallow",
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              "Variant Price",
              style: productTextStyle,
            ),
            InputNameField(
              onChanged: (value) {
                Provider.of<ProductBody>(context, listen: false)
                    .update(basePrice: double.parse(value));
              },
              hintText: "PHP 575.00",
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(
              "Current Stock",
              style: productTextStyle,
            ),
            InputNameField(
              onChanged: (value) {
                Provider.of<ProductBody>(context, listen: false)
                    .update(quantity: int.parse(value));
              },
              hintText: "12",
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            AppButton(
              "Add add-on",
              kTealColor,
              true,
              () {
                pushNewScreen(
                  context,
                  screen: ProductAddOn2(gallery: widget.gallery),
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
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
      appBar: CustomAppBar(
        titleText: "New Add-on",
        onPressedLeading: () {
          Navigator.pop(context);
        },
      ),
      body: buildBody(),
    );
  }
}