import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lokalapp/models/lokal_images.dart';
import 'package:lokalapp/providers/products.dart';
import 'package:lokalapp/providers/shops.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:lokalapp/screens/add_product_screen/confirmation.dart';
import 'package:lokalapp/services/local_image_service.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

import '../../providers/post_requests/product_body.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/rounded_button.dart';
import 'components/add_product_gallery.dart';

class ProductPreview extends StatefulWidget {
  final AddProductGallery gallery;
  ProductPreview({@required this.gallery});

  @override
  _ProductPreviewState createState() => _ProductPreviewState();
}

class _ProductPreviewState extends State<ProductPreview> {
  PhotoViewController controller;
  int _current = 0;
  List<File> images;

  @override
  initState() {
    images = widget.gallery.photoBoxes.map((image) {
      if (image.file != null) return image.file;
    }).toList()
      ..removeWhere((image) => image == null);
    super.initState();
  }

  buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: images.map((file) {
        int index = images.indexOf(file);
        return Container(
          width: 9.0,
          height: 10.0,
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: Colors.black),
            color:
                _current == index ? Color.fromRGBO(0, 0, 0, 0.9) : Colors.grey,
          ),
        );
      }).toList(),
    );
  }

  buildGallery() {
    return PhotoViewGallery.builder(
      itemCount: images.length,
      onPageChanged: (index) {
        if (this.mounted) {
          setState(() {
            _current = index;
          });
        }
      },
      builder: (context, index) {
        var image = images[index];
        if (image == null) return null;

        return PhotoViewGalleryPageOptions(
          imageProvider: FileImage(image), //NetworkImage(url),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
          controller: controller,
        );
      },
      scrollPhysics: BouncingScrollPhysics(),
      backgroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Theme.of(context).canvasColor,
      ),
      enableRotation: true,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 30.0,
          height: 30.0,
          child: CircularProgressIndicator(
            backgroundColor: Colors.orange,
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes,
          ),
        ),
      ),
    );
  }

  buildImage(ProductBody product) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Stack(
                children: [
                  buildGallery(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: buildDots(),
                  )
                ],
              ),
            ),
          ),
          //  SizedBox(height: 10,),
        ],
      ),
    );
  }

  Future<bool> createProduct() async {
    List<LokalImages> gallery = [];
    for (var image in images) {
      var mediaUrl =
          await Provider.of<LocalImageService>(context, listen: false)
              .uploadImage(file: image, name: 'productPhoto');
      gallery.add(LokalImages(url: mediaUrl, order: gallery.length));
    }

    var user = Provider.of<CurrentUser>(context, listen: false);
    var shop =
        Provider.of<Shops>(context, listen: false).findByUser(user.id).first;
    var products = Provider.of<Products>(context, listen: false);
    var productBody = Provider.of<ProductBody>(context, listen: false);
    try {
      productBody.update(
        gallery: gallery.map((image) => image.toMap()).toList(),
        shopId: shop.id,
      );
      return await products.create(user.idToken, productBody.data);
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: customAppBar(
          titleText: "Product Preview",
          onPressedLeading: () {
            Navigator.pop(context);
          }),
      body: Container(
        padding: EdgeInsets.all(width * 0.01),
        child: Consumer<ProductBody>(
          builder: (context, product, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildImage(product),
                Text(
                  product.name,
                  style: kTextStyle.copyWith(
                    fontSize: MediaQuery.of(context).size.width * 0.065,
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Text(
                  product.description,
                  style: kTextStyle,
                ),
                Spacer(),
                RoundedButton(
                  label: "Next",
                  height: 10,
                  minWidth: double.infinity,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "GoldplayBold",
                  fontColor: Colors.white,
                  onPressed: () async {
                    var success = await createProduct();
                    if (success) {
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              AddProductConfirmation(),
                        ),
                      );
                    }
                    // TODO: do something if unsuccessful
                  },
                ),
                SizedBox(
                  height: height * 0.02,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
