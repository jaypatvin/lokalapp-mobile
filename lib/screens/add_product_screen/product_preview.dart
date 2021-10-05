import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:screen_loader/screen_loader.dart';

import '../../models/lokal_images.dart';
import '../../providers/post_requests/operating_hours_body.dart';
import '../../providers/post_requests/product_body.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../services/local_image_service.dart';
import '../../utils/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import 'components/add_product_gallery.dart';
import 'confirmation.dart';
import 'product_schedule.dart';

class ProductPreview extends StatefulWidget {
  final AddProductGallery gallery;
  final ProductScheduleState scheduleState;
  ProductPreview({
    @required this.gallery,
    @required this.scheduleState,
  });

  @override
  _ProductPreviewState createState() => _ProductPreviewState();
}

class _ProductPreviewState extends State<ProductPreview> with ScreenLoader {
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

  Widget _buildDots() {
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
            border: Border.all(width: 1.sp, color: Colors.black),
            color:
                _current == index ? Colors.black.withOpacity(0.5) : Colors.grey,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGallery() {
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
          basePosition: Alignment.center,
          imageProvider: FileImage(image), //NetworkImage(url),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered,
          controller: controller,
          tightMode: true,
        );
      },
      scrollPhysics: BouncingScrollPhysics(),
      backgroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.transparent,
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

  Widget _buildImage(ProductBody product) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Stack(
                children: [
                  _buildGallery(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildDots(),
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

  Future<bool> _createProduct() async {
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
      return await products.create(productBody.data);
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _setAvailability() async {
    var products = Provider.of<Products>(context, listen: false);
    var product = products.items.last; // this should get the latest item added
    var hoursBody = Provider.of<OperatingHoursBody>(context, listen: false);

    try {
      return await products.setAvailability(
        id: product.id,
        data: hoursBody.data,
      );
    } catch (e) {
      // do something with the error
      return false;
    }
  }

  Future<void> _onConfirm() async {
    final shopCreated = await _createProduct();
    if (shopCreated) {
      if (widget.scheduleState == ProductScheduleState.custom) {
        final availabilitySet = await _setAvailability();
        if (!availabilitySet) {
          final snackBar = SnackBar(
            content: Text('Failed to set product availability'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => AddProductConfirmation(),
        ),
      );
    } else {
      final snackBar = SnackBar(content: Text('Failed to create shop'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget screen(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(
        titleText: "Product Preview",
        onPressedLeading: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ProductBody>(
          builder: (context, product, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.45,
                  child: _buildImage(product),
                ),
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    "Confirm",
                    kTealColor,
                    true,
                    () async => await performFuture<void>(
                      () async => await _onConfirm(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
