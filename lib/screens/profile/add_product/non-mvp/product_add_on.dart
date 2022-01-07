import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/post_requests/product_body.dart';
import '../../../../routers/app_router.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../components/add_product_gallery.dart';
import '../components/product_header.dart';
import 'new_add_on.dart';

class ProductAddOn extends StatefulWidget {
  final AddProductGallery gallery;
  const ProductAddOn({required this.gallery});
  @override
  _ProductAddOnState createState() => _ProductAddOnState();
}

class _ProductAddOnState extends State<ProductAddOn> {
  Widget buildBody() {
    final horizontalPadding = MediaQuery.of(context).size.width * 0.05;
    final topPadding = MediaQuery.of(context).size.height * 0.03;
    final image = widget.gallery.photoBoxes.first;

    return Container(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        topPadding,
        horizontalPadding,
        0,
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<ProductBody>(
              builder: (context, product, child) {
                return ProductHeader(
                  photoBox: image,
                  productName: product.name,
                  productPrice: product.basePrice,
                  productStock: product.quantity,
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            const Text(
              'Add-ons',
              style: TextStyle(
                fontFamily: 'Goldplay',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AppButton(
              'New Add-on',
              kTealColor,
              true,
              () {
                AppRouter.profileNavigatorKey.currentState?.push(
                  CupertinoPageRoute(
                    builder: (_) => NewAddOn(gallery: widget.gallery),
                  ),
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
            ),
            AppButton(
              'Skip',
              kTealColor,
              true,
              () {
                AppRouter.profileNavigatorKey.currentState?.push(
                  CupertinoPageRoute(
                    builder: (_) => NewAddOn(gallery: widget.gallery),
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
      appBar: CustomAppBar(
        titleText: 'Product Add-ons',
        onPressedLeading: () {
          Navigator.pop(context);
        },
      ),
      body: buildBody(),
    );
  }
}
