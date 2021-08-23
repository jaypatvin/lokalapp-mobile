import 'package:flutter/material.dart';
import 'package:lokalapp/providers/post_requests/product_body.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/custom_app_bar.dart';
import 'package:lokalapp/widgets/input_name.dart';
import 'package:lokalapp/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

import 'components/add_product_gallery.dart';
import 'components/product_header.dart';
import 'product_variant_2.dart';

class AddAVariant extends StatefulWidget {
  final AddProductGallery gallery;
  AddAVariant({@required this.gallery});

  @override
  _AddAVariantState createState() => _AddAVariantState();
}

class _AddAVariantState extends State<AddAVariant> {
  final TextStyle productTextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: "Goldplay",
    fontSize: 16.0,
  );
  Widget buildBody() {
    var horizontalPadding = MediaQuery.of(context).size.width * 0.05;
    var topPadding = MediaQuery.of(context).size.height * 0.03;
    var image = widget.gallery.photoBoxes.first;
    final AddProductGallery _gallery = AddProductGallery();
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
              "Add a Photo",
              style: TextStyle(
                  fontFamily: "Goldplay", fontWeight: FontWeight.w600),
            ),
            _gallery,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(
              "Variant Name",
              style: productTextStyle,
            ),
            InputName(
              onChanged: (value) {
                Provider.of<ProductBody>(context, listen: false)
                    .update(name: value);
              },
              hintText: "Coffee Crumble",
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              "Variant Price",
              style: productTextStyle,
            ),
            InputName(
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
            InputName(
              onChanged: (value) {
                Provider.of<ProductBody>(context, listen: false)
                    .update(quantity: int.parse(value));
              },
              hintText: "12",
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            RoundedButton(
              label: "Add a Variant",
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
                        builder: (context) =>
                            ProductVariant2(gallery: widget.gallery)));
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
        titleText: "Add Variant",
        onPressedLeading: () {
          Navigator.pop(context);
        },
      ),
      body: buildBody(),
    );
  }
}
