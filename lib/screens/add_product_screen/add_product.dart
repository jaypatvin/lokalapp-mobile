import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/user_product.dart';
import '../../services/database.dart';
import '../../states/current_user.dart';
import '../../utils/themes.dart';
import '../../widgets/rounded_button.dart';
import '../add_shop_screens/appbar_shop.dart';
import '../add_shop_screens/shopDescription.dart';
import '../edit_shop_screen/set_custom_operating_hours.dart';
import '../profile_screens/profile_shop.dart';
import 'components/add_product_gallery.dart';
import 'item_name.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

//TODO: ADD STATUS
class _AddProductState extends State<AddProduct> {
  String itemName;
  // double _opacityValue = 0.0;
  bool _isVisible = false;
  String itemDescription;
  bool _setPickUpHours = false;
  bool _setDeliveryHours = false;
  String productPhotoId = Uuid().v4();
  final picker = ImagePicker();
  File file;
  File secondFile;
  TextEditingController _priceController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  TransformationController controller = TransformationController();
  int quantity = 1;
  bool isFile = false;
  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$productPhotoId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 90));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask =
        storageRef.child("productId_$productPhotoId.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  handleGallery() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        file = File(pickedImage.path);
      });
      // Navigator.pop(context);
    }
  }

//  handleGallery2() async {
//     final pickedImage = await picker.getImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         secondFile = File(pickedImage.path);
//       });
//       // Navigator.pop(context);
//     }
//   }

  handleCamera() async {
    // Navigator.pop(context);
    final pickedImage = await picker.getImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    if (pickedImage != null) {
      setState(() {
        file = File(pickedImage.path);
      });
      //  Navigator.pop(context);
    }
  }

  //   handleCamera2() async {
  //   // Navigator.pop(context);
  //   final pickedImage = await picker.getImage(
  //       source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
  //   if (pickedImage != null) {
  //     setState(() {
  //       secondFile = File(pickedImage.path);
  //     });
  //     //  Navigator.pop(context);
  //   }
  // }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Upload Picture"),
            children: [
              SimpleDialogOption(
                child: Text("Camera"),
                onPressed: () {
                  handleCamera();
                },
              ),
              SimpleDialogOption(
                child: Text("Gallery"),
                onPressed: () {
                  handleGallery();
                },
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Widget photoBox() {
    return GestureDetector(
      onTap: () {
        selectImage(context);
      },
      child: Container(
        width: 72.0,
        height: 75.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(width: 1, color: kTealColor),
        ),
        child: IconButton(
          onPressed: () {
            selectImage(context);
          },
          icon: Icon(
            Icons.add,
            color: kTealColor,
            size: 15,
          ),
        ),
      ),
    );
  }

  Widget photoBoxWithPic() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 72.0,
        height: 75.0,
        decoration: BoxDecoration(
          image: DecorationImage(fit: BoxFit.cover, image: FileImage(file)),
          shape: BoxShape.rectangle,
          border: Border.all(width: 1, color: kTealColor),
        ),
        child: IconButton(
          onPressed: () {
            showPhotoBox();
          },
          icon: file == null
              ? Icon(
                  Icons.add,
                  color: kTealColor,
                  size: 15,
                )
              : Icon(null),
        ),
      ),
    );
  }



  Widget buildAppBar() {
    return PreferredSize(
        preferredSize: Size(double.infinity, 83),
        child: Center(
            child: AppbarShop(
          shopName: "Add A Product",
        )));
  }

  Widget buildDropDown() {
    var user = Provider.of<CurrentUser>(context, listen: false);
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
          value: user.postProduct.productCategory,
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
          onChanged: (value) {
            setState(() {
              user.postProduct.productCategory = value;
            });
          },
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

  Widget buildPhotoBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 15,
        ),
        file == null ? photoBox() : photoBoxWithPic()
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
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ProfileShop()),
              (route) => false);
        }
      },
    );
  }

  void showPhotoBox() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  //TODO: put this somewhere
  Future<bool> createProduct() async {
    // var user = Provider.of<CurrentUser>(context, listen: false);
    // List media = [];
    String mediaUrl = "";
    String mediaUrl2 = "";
    if (file != null) {
      await compressImage();
      mediaUrl = await uploadImage(file);
      // mediaUrl2 = await uploadImage(file);

    }
    CurrentUser user = Provider.of<CurrentUser>(context, listen: false);
    //TODO: check for price and quantity parse problems
    try {
      user.postProduct.name = itemName;
      user.postProduct.description = itemDescription;
      user.postProduct.gallery = [ProductGallery(url: mediaUrl, order: 0)];
      user.postProduct.basePrice = double.tryParse(_priceController.text);
      user.postProduct.quantity = int.tryParse(_stockController.text);
      return await user.createProduct();
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
                AddProductGallery(),
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
