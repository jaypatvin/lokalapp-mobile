import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/post_requests/product_body.dart';
import '../../../../routers/app_router.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../components/add_product_gallery.dart';
import '../components/product_header.dart';
import '../product_schedule.dart';

class ProductAddOn2 extends StatefulWidget {
  final AddProductGallery gallery;
  ProductAddOn2({required this.gallery});
  @override
  _ProductAddOn2State createState() => _ProductAddOn2State();
}

class _ProductAddOn2State extends State<ProductAddOn2> {
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
              "Add-ons",
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
              "New Add-on",
              kTealColor,
              true,
              () {},
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
            ),
            AppButton(
              "New Add-on",
              kTealColor,
              true,
              () {
                AppRouter.pushNewScreen(
                  context,
                  screen: ProductSchedule(gallery: widget.gallery),
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
        titleText: "Product Add-ons",
        onPressedLeading: () {
          Navigator.pop(context);
        },
      ),
      body: buildBody(),
    );
  }
}
