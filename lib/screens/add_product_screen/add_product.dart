import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/lokal_images.dart';
import '../../providers/post_requests/product_body.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../services/local_image_service.dart';
import '../../utils/themes.dart';
import '../../widgets/rounded_button.dart';
import '../add_shop_screens/appbar_shop.dart';
import '../add_shop_screens/shopDescription.dart';
import '../edit_shop_screen/set_custom_operating_hours.dart';
import 'components/add_product_gallery.dart';
import 'item_name.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String itemName;
  String itemDescription;
  bool _setPickUpHours = false;
  bool _setDeliveryHours = false;
  TextEditingController _priceController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  AddProductGallery _gallery = AddProductGallery();

  Widget buildAppBar() {
    return PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: Center(
            child: AppbarShop(
          shopName: "Add A Product",
        )));
  }

  Widget buildDropDown() {
    //var user = Provider.of<CurrentUser>(context, listen: false);
    var productBody = Provider.of<ProductBody>(context, listen: false);
    return Container(
      width: 160.0,
      height: 35.0,
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.grey.shade200)),
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<String>(
          isExpanded: true,
          iconEnabledColor: kTealColor,
          iconDisabledColor: kTealColor,
          underline: SizedBox(),
          value:
              productBody.productCategory, //user.postProduct.productCategory,
          hint: Text(
            "Select",
            style:
                TextStyle(color: Colors.grey.shade400, fontFamily: "Goldplay"),
          ),
          items: <String>['A', 'B', 'C', 'D'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (value) => productBody.update(productCategory: value),
        ),
      ),
    );
  }

  Row buildProductPrice() {
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        Text("Product Price",
            style:
                TextStyle(fontWeight: FontWeight.w700, fontFamily: "Goldplay")),
        SizedBox(
          width: 70,
        ),
        Row(
          children: [
            Container(
              width: 160.0,
              height: 35.0,
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
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 15, top: 9, right: 15),
                    hintStyle:
                        TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    hintText: "PHP"),
                controller: _priceController,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget buildInventoryStock() {
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        Text("Inventory Stock",
            style:
                TextStyle(fontWeight: FontWeight.w700, fontFamily: "Goldplay")),
        SizedBox(
          width: 58,
        ),
        Row(
          children: [
            Container(
              width: 160.0,
              height: 35.0,
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
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 15, top: 9, right: 15),
                    alignLabelWithHint: true,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    hintText: "Amount"),
                controller: _stockController,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget buildSubmitButton() {
    return RoundedButton(
      label: "SUBMIT",
      height: 10,
      // height:MediaQuery.of(context).size.height * 0.2,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      fontFamily: "GoldplayBold",
      onPressed: () async {
        var productCreated = await createProduct();
        if (productCreated) {
          var user = Provider.of<CurrentUser>(context, listen: false);
          Provider.of<Products>(context, listen: false).fetch(user.idToken);
          Navigator.pop(context);
        }
      },
    );
  }

  Future<bool> createProduct() async {
    List<LokalImages> gallery = [];
    for (var photoBox in _gallery.photoBoxes) {
      if (photoBox.file == null) {
        continue;
      }
      var mediaUrl =
          await Provider.of<LocalImageService>(context, listen: false)
              .uploadImage(file: photoBox.file, name: 'productPhoto');
      gallery.add(LokalImages(url: mediaUrl, order: gallery.length));
    }
    CurrentUser user = Provider.of<CurrentUser>(context, listen: false);
    var shop =
        Provider.of<Shops>(context, listen: false).findByUser(user.id).first;
    var products = Provider.of<Products>(context, listen: false);
    var productBody = Provider.of<ProductBody>(context, listen: false);
    //TODO: check for price and quantity parse problems
    try {
      productBody.update(
        name: itemName,
        description: itemDescription,
        gallery: gallery.map((image) => image.toMap()).toList(),
        basePrice: double.tryParse(_priceController.text),
        quantity: int.tryParse(_stockController.text),
        shopId: shop.id,
      );
      return await products.create(user.idToken, productBody.data);
    } on Exception catch (_) {
      print(_);
      return false;
    }
  }

  Row buildItemName() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ItemName(
          onChanged: (value) {
            setState(() {
              itemName = value;
            });
          },
        ),
      ],
    );
  }

  Row buildItemDescription() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShopDescription(
          hintText: "Item Description",
          onChanged: (value) {
            setState(() {
              itemDescription = value;
            });
          },
        )
      ],
    );
  }

  Row buildDeliveryOptionsText() {
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        Text("Delivery Options",
            style:
                TextStyle(fontWeight: FontWeight.w700, fontFamily: "Goldplay")),
      ],
    );
  }

  Row buildCustomerPickUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: SetCustomoperatingHours(
            label: "Customer Pick-up",
            value: _setPickUpHours,
            onChanged: (value) {
              setState(() {
                _setPickUpHours = value;
              });
            },
          ),
        )
      ],
    );
  }

  Row buildDelivery() {
    return Row(
      children: [
        Expanded(
          child: SetCustomoperatingHours(
            label: "Delivery",
            value: _setDeliveryHours,
            onChanged: (value) {
              setState(() {
                _setDeliveryHours = value;
              });
            },
          ),
        )
      ],
    );
  }

  Widget buildProductPhotoText() {
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        Text("Product Photos",
            style:
                TextStyle(fontWeight: FontWeight.w700, fontFamily: "Goldplay")),
      ],
    );
  }

  Widget buildBody() {
    return CustomScrollView(slivers: [
      SliverList(
        delegate: SliverChildListDelegate(
          [
            Column(
              children: [
                SizedBox(
                  height: 32,
                ),
                buildItemName(),
                buildItemDescription(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Product Category",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontFamily: "Goldplay"),
                    ),
                    SizedBox(
                      width: 43,
                    ),
                    buildDropDown()
                  ],
                ),
                SizedBox(
                  height: 23,
                ),
                buildProductPrice(),
                SizedBox(
                  height: 23,
                ),
                buildInventoryStock(),
                SizedBox(
                  height: 28,
                ),
                buildDeliveryOptionsText(),
                buildCustomerPickUp(),
                buildDelivery(),
                SizedBox(
                  height: 27,
                ),
                buildProductPhotoText(),
                SizedBox(
                  height: 15,
                ),
                _gallery,
                SizedBox(
                  height: 50,
                ),
                buildSubmitButton(),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(),
        body: buildBody());
  }
}
