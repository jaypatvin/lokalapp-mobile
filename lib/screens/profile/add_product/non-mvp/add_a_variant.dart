import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/app_navigator.dart';
import '../../../../providers/post_requests/product_body.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/inputs/input_name_field.dart';
import '../../../../widgets/photo_box.dart';
import '../components/product_header.dart';
import 'product_variant_2.dart';

class AddAVariant extends StatefulWidget {
  const AddAVariant({
    super.key,
    required this.images,
  });
  final List<PhotoBoxImageSource> images;

  @override
  _AddAVariantState createState() => _AddAVariantState();
}

class _AddAVariantState extends State<AddAVariant> {
  final TextStyle productTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: 'Goldplay',
    fontSize: 16.0,
  );
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
              'Add a Photo',
              style: TextStyle(
                fontFamily: 'Goldplay',
                fontWeight: FontWeight.w600,
              ),
            ),
            // TODO: variant images
            //_gallery,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(
              'Variant Name',
              style: productTextStyle,
            ),
            InputNameField(
              onChanged: (value) {
                Provider.of<ProductBody>(context, listen: false)
                    .update(name: value);
              },
              hintText: 'Coffee Crumble',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              'Variant Price',
              style: productTextStyle,
            ),
            InputNameField(
              onChanged: (value) {
                Provider.of<ProductBody>(context, listen: false)
                    .update(basePrice: double.parse(value));
              },
              hintText: 'PHP 575.00',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(
              'Current Stock',
              style: productTextStyle,
            ),
            InputNameField(
              onChanged: (value) {
                Provider.of<ProductBody>(context, listen: false)
                    .update(quantity: int.parse(value));
              },
              hintText: '12',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            AppButton.filled(
              text: 'Add a Variant',
              onPressed: () {
                Navigator.push(
                  context,
                  AppNavigator.appPageRoute(
                    builder: (_) => ProductVariant2(images: widget.images),
                  ),
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
        titleText: 'Add Variant',
        onPressedLeading: () {
          Navigator.pop(context);
        },
      ),
      body: buildBody(),
    );
  }
}
