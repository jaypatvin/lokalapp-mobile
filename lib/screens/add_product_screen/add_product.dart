import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../providers/post_requests/product_body.dart';
import '../../utils/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/input_description.dart';
import '../../widgets/input_name.dart';
import 'components/add_product_gallery.dart';
import 'product_details.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final AddProductGallery _gallery = AddProductGallery();

  Widget _buildProductPrice() {
    return Row(
      children: [
        Text(
          "Product Price",
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
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
                hintStyle: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: Colors.grey,
                    ),
                hintText: "PHP",
              ),
              onChanged: (value) {
                context
                    .read<ProductBody>()
                    .update(basePrice: double.tryParse(value) ?? 0);
              },
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        )
      ],
    );
  }

  Widget buildBody() {
    var horizontalPadding = MediaQuery.of(context).size.width * 0.05;
    var topPadding = MediaQuery.of(context).size.height * 0.02;
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
            Text(
              "Product Photos",
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _gallery,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              "Product Name",
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            InputName(
              onChanged: (value) {
                Provider.of<ProductBody>(context, listen: false)
                    .update(name: value);
              },
              hintText: "Item Name",
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              "Description",
              style: Theme.of(context).textTheme.headline6,
            ),
            InputDescription(
              onChanged: (value) {
                Provider.of<ProductBody>(context, listen: false)
                    .update(description: value);
              },
              hintText: "Product Description",
            ),
            SizedBox(
              height: 20,
            ),
            _buildProductPrice(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            SizedBox(
              width: double.infinity,
              child: AppButton("Next", kTealColor, true, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ProductDetails(gallery: _gallery),
                  ),
                );
              }),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    Provider.of<ProductBody>(context, listen: false).clear();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          titleText: "Add a New Product",
          onPressedLeading: () {
            Navigator.pop(context);
          },
        ),
        resizeToAvoidBottomInset: false,
        body: buildBody());
  }
}
