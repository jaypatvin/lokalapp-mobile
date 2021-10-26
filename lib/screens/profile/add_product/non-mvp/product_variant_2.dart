import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../../providers/post_requests/product_body.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../components/add_product_gallery.dart';
import '../components/product_header.dart';
import 'add_a_variant.dart';
import 'product_add_on.dart';

class ProductVariant2 extends StatefulWidget {
  final AddProductGallery gallery;
  ProductVariant2({required this.gallery});
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
            AppButton(
              "Add another variant",
              kTealColor,
              true,
              () {
                pushNewScreen(
                  context,
                  screen: AddAVariant(gallery: widget.gallery),
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
            ),
            AppButton(
              "Next",
              kTealColor,
              true,
              () {
                pushNewScreen(
                  context,
                  screen: ProductAddOn(gallery: widget.gallery),
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
