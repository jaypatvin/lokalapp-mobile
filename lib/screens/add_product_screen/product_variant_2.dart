import 'package:flutter/material.dart';
import 'package:lokalapp/providers/post_requests/product_body.dart';
import 'package:lokalapp/screens/add_product_screen/add_a_variant.dart';
import 'package:lokalapp/screens/add_product_screen/product_add_on.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/custom_app_bar.dart';
import 'package:lokalapp/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

import 'components/add_product_gallery.dart';
import 'components/product_header.dart';

class ProductVariant2 extends StatefulWidget {
  final AddProductGallery gallery;
  ProductVariant2({@required this.gallery});
  @override
  _ProductVariant2State createState() => _ProductVariant2State();
}

class _ProductVariant2State extends State<ProductVariant2> {
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
            Text(
              "Variants",
              style: TextStyle(
                  fontFamily: "Goldplay", fontWeight: FontWeight.w600),
            ),
            Consumer<ProductBody>(builder: (context, product, child) {
              return ProductHeader(
                photoBox: image,
                productName: product.name,
                productPrice: product.basePrice,
                productStock: product.quantity,
              );
            }),
            SizedBox(
              height: 20,
            ),
            RoundedButton(
              label: "Add another variant",
              height: 10,
              minWidth: double.infinity,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFamily: "GoldplayBold",
              fontColor: kTealColor,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddAVariant(gallery: widget.gallery)));
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
            ),
            RoundedButton(
              label: "Next",
              height: 10,
              minWidth: double.infinity,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: kTealColor,
              fontFamily: "GoldplayBold",
              fontColor: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductAddOn(gallery: widget.gallery)));
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
      appBar: CustomAppBar(
        titleText: "Product Variant",
        onPressedLeading: () {
          Navigator.pop(context);
        },
      ),
      body: buildBody(),
    );
  }
}
