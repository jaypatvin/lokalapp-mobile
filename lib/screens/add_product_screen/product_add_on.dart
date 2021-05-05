import 'package:flutter/material.dart';
import 'package:lokalapp/providers/post_requests/product_body.dart';
import 'package:lokalapp/screens/add_product_screen/new_add_on.dart';
import 'package:lokalapp/screens/add_product_screen/product_add_ons_2.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/custom_app_bar.dart';
import 'package:lokalapp/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

import 'components/add_product_gallery.dart';
import 'components/product_header.dart';

class ProductAddOn extends StatefulWidget {
  final AddProductGallery gallery;
  ProductAddOn({@required this.gallery});
  @override
  _ProductAddOnState createState() => _ProductAddOnState();
}

class _ProductAddOnState extends State<ProductAddOn> {
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
            SizedBox(
              height: 20,
            ),
            RoundedButton(
              label: "New Add-on",
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
                            NewAddOn(gallery: widget.gallery)));
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
            ),
            RoundedButton(
              label: "Skip",
              height: 10,
              minWidth: double.infinity,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFamily: "GoldplayBold",
              fontColor: kTealColor,
              onPressed: () {},
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
        titleText: "Product Add-ons",
        onPressedLeading: () {
          Navigator.pop(context);
        },
      ),
      body: buildBody(),
    );
  }
}
