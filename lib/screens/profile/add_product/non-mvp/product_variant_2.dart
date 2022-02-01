import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/app_navigator.dart';
import '../../../../providers/post_requests/product_body.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/photo_box.dart';
import '../components/product_header.dart';
import 'add_a_variant.dart';
import 'product_add_on.dart';

class ProductVariant2 extends StatefulWidget {
  const ProductVariant2({
    Key? key,
    required this.images,
  }) : super(key: key);
  final List<PhotoBoxImageSource> images;
  @override
  _ProductVariant2State createState() => _ProductVariant2State();
}

class _ProductVariant2State extends State<ProductVariant2> {
  Widget buildBody() {
    final horizontalPadding = MediaQuery.of(context).size.width * 0.05;
    final topPadding = MediaQuery.of(context).size.height * 0.03;
    final image = widget.images.isNotEmpty
        ? widget.images.first
        : const PhotoBoxImageSource();

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
                  productHeaderImageSource: image,
                  productName: product.name ?? '',
                  productPrice: product.basePrice ?? 0.0,
                  productStock: product.quantity ?? 0,
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            const Text(
              'Variants',
              style: TextStyle(
                fontFamily: 'Goldplay',
                fontWeight: FontWeight.w600,
              ),
            ),
            Consumer<ProductBody>(
              builder: (context, product, child) {
                return ProductHeader(
                  productHeaderImageSource: image,
                  productName: product.name ?? '',
                  productPrice: product.basePrice ?? 0.0,
                  productStock: product.quantity ?? 0,
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            AppButton.filled(
              text: 'Add another variant',
              onPressed: () {
                Navigator.push(
                  context,
                  AppNavigator.appPageRoute(
                    builder: (_) => AddAVariant(images: widget.images),
                  ),
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
            ),
            AppButton.filled(
              text: 'Next',
              onPressed: () {
                Navigator.push(
                  context,
                  AppNavigator.appPageRoute(
                    builder: (_) => ProductAddOn(images: widget.images),
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
        titleText: 'Product Variant',
        onPressedLeading: () {
          Navigator.pop(context);
        },
      ),
      body: buildBody(),
    );
  }
}
