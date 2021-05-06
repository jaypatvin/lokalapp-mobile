import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../providers/post_requests/product_body.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/input_description.dart';
import '../../widgets/input_name.dart';
import '../../widgets/rounded_button.dart';
import 'components/add_product_gallery.dart';
import 'product_details.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextStyle productTextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: "Goldplay",
    fontSize: 16.0,
  );
  final AddProductGallery _gallery = AddProductGallery();

  Widget buildProductPrice() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Product Price",
          style: productTextStyle,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
        ),
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
                    vertical: MediaQuery.of(context).size.height * 0.01),
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
                hintText: "PHP",
              ),
              onChanged: (value) {
                Provider.of<ProductBody>(context, listen: false)
                    .update(basePrice: double.tryParse(value) ?? 0);
              },
              style: productTextStyle.copyWith(
                fontSize: 20.0,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildSubmitButton() {
    return RoundedButton(
      label: "Next",
      height: 10,
      minWidth: double.infinity,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      fontFamily: "Goldplay",
      fontColor: Colors.white,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                ProductDetails(gallery: _gallery),
          ),
        );
      },
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
        //physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product Photos",
              style: productTextStyle,
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
              style: productTextStyle,
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
              style: productTextStyle,
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
            buildProductPrice(),
            // Spacer(),
            SizedBox(
              height: 50,
            ),
            buildSubmitButton(),
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
        appBar: customAppBar(
          titleText: "Add a New Product",
          onPressedLeading: () {
            Navigator.pop(context);
          },
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(child: buildBody()));
  }
}
