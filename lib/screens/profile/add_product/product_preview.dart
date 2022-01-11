import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

import '../../../models/lokal_images.dart';
import '../../../providers/auth.dart';
import '../../../providers/post_requests/operating_hours_body.dart';
import '../../../providers/post_requests/product_body.dart';
import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../services/local_image_service.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/overlays/screen_loader.dart';
import '../shop/user_shop.dart';
import 'components/add_product_gallery.dart';
import 'confirmation.dart';
import 'product_schedule.dart';

class ProductPreview extends StatefulWidget {
  final AddProductGallery? gallery;
  final ProductScheduleState? scheduleState;
  final String? productId;
  const ProductPreview({
    required this.gallery,
    required this.scheduleState,
    this.productId,
  });

  @override
  _ProductPreviewState createState() => _ProductPreviewState();
}

class _ProductPreviewState extends State<ProductPreview> with ScreenLoader {
  PhotoViewController? controller;
  int _current = 0;
  late List<File?> images;
  late List<String?> _urlImages;

  @override
  void initState() {
    images = widget.gallery!.photoBoxes.map((image) {
      if (image.file != null) return image.file;
    }).toList()
      ..removeWhere((image) => image == null);

    _urlImages = widget.gallery!.photoBoxes.map((image) => image.url).toList()
      ..removeWhere((image) => image == null || image.isEmpty);

    super.initState();
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: images.map((file) {
        final int index = images.indexOf(file);
        return Container(
          width: 9.0,
          height: 10.0,
          margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1.sp),
            color:
                _current == index ? Colors.black.withOpacity(0.5) : Colors.grey,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGallery() {
    return PhotoViewGallery.builder(
      itemCount: images.length + _urlImages.length,
      onPageChanged: (index) {
        if (mounted) {
          setState(() {
            _current = index;
          });
        }
      },
      builder: (context, index) {
        if (_urlImages.length > index) {
          final image = _urlImages[index];

          return PhotoViewGalleryPageOptions(
            basePosition: Alignment.center,
            imageProvider: NetworkImage(image!), //NetworkImage(url),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered,
            controller: controller,
            tightMode: true,
            errorBuilder: (ctx, _, __) => const SizedBox.shrink(),
          );
        } else {
          final _index = index - _urlImages.length;
          final image = images[_index];

          return PhotoViewGalleryPageOptions(
            basePosition: Alignment.center,
            imageProvider: FileImage(image!), //NetworkImage(url),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered,
            controller: controller,
            tightMode: true,
            errorBuilder: (ctx, _, __) => const SizedBox.shrink(),
          );
        }
      },
      scrollPhysics: const BouncingScrollPhysics(),
      backgroundDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.transparent,
      ),
      enableRotation: true,
      loadingBuilder: (context, event) => Center(
        child: SizedBox(
          width: 30.0,
          height: 30.0,
          child: CircularProgressIndicator(
            backgroundColor: Colors.orange,
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
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
            child: SizedBox(
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

  Future<void> _createProduct() async {
    final List<LokalImages> gallery = [];
    for (final image in images) {
      final mediaUrl =
          await Provider.of<LocalImageService>(context, listen: false)
              .uploadImage(file: image!, name: 'productPhoto');
      gallery.add(LokalImages(url: mediaUrl, order: gallery.length));
    }

    if (!mounted) return;
    final user = context.read<Auth>().user!;
    final shop =
        Provider.of<Shops>(context, listen: false).findByUser(user.id).first;
    final products = Provider.of<Products>(context, listen: false);
    final productBody = Provider.of<ProductBody>(context, listen: false);
    try {
      productBody.update(
        gallery: gallery.map((image) => image.toMap()).toList(),
        shopId: shop.id,
        availability: context.read<OperatingHoursBody>().data,
      );
      return await products.create(productBody.data);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> _updateProduct() async {
    final _productBody = context.read<ProductBody>();
    final _product = context.read<Products>().findById(widget.productId);
    final updateBody = ProductBody()..update(shopId: _product!.id);
    updateBody.data.remove('gallery');

    if (_productBody.name != _product.name) {
      updateBody.update(name: _productBody.name);
    }
    if (_productBody.description != _product.description) {
      updateBody.update(description: _productBody.description);
    }
    if (_productBody.productCategory != _product.productCategory) {
      updateBody.update(productCategory: _productBody.productCategory);
    }
    if (_productBody.basePrice != _product.basePrice) {
      updateBody.update(basePrice: _productBody.basePrice);
    }
    if (_productBody.quantity != _product.quantity) {
      updateBody.update(quantity: _productBody.quantity);
    }
    if (_productBody.canSubscribe != _product.canSubscribe) {
      updateBody.update(canSubscribe: _productBody.canSubscribe);
    }

    if (images.isNotEmpty) {
      final gallery = <LokalImages>[..._product.gallery!];

      for (final image in images) {
        final mediaUrl = await context
            .read<LocalImageService>()
            .uploadImage(file: image!, name: 'productPhoto');
        gallery.add(LokalImages(url: mediaUrl, order: gallery.length));
      }
      if (!listEquals(gallery, _product.gallery)) {
        updateBody.update(
          gallery: gallery.map((image) => image.toMap()).toList(),
        );
      }
    }

    final updateData = updateBody.data;
    updateData.remove('shop_id');
    updateData.remove('availability');

    ProductBody().data.forEach((key, value) {
      if (updateData[key] == value || updateData[key] == null) {
        updateData.remove(key);
      }
    });

    bool updateSchedule = false;
    if (!mounted) return false;

    if (widget.scheduleState == ProductScheduleState.shop) {
      final shop = context.read<Shops>().findById(_product.shopId)!;
      if (shop.operatingHours != _product.availability) {
        // we update the availability of the product
        // we already set this up at the product_schedule screen.
        updateSchedule = true;
      }
    } else {
      final body = context.read<OperatingHoursBody>().operatingHours;
      final availability = _product.availability!;
      if (!listEquals(
        body.unavailableDates!..sort(),
        availability.unavailableDates!..sort(),
      )) {
        // We update the availability of the product.
        updateSchedule = true;
      }
    }

    if (updateData.isEmpty && !updateSchedule) {
      // this would mean that there is nothing to update
      throw 'There is nothing to update';
    }

    bool updatedProductDetails = false;
    bool updatedProductSchedule = false;

    try {
      if (updateData.isNotEmpty) {
        updatedProductDetails = await context.read<Products>().update(
              id: _product.id,
              data: updateBody.data,
            );
      }

      if (updateSchedule) {
        if (!mounted) return false;
        updatedProductSchedule = await context.read<Products>().setAvailability(
              id: _product.id,
              data: context.read<OperatingHoursBody>().data,
            );
      }

      return (updateData.isNotEmpty && updatedProductDetails) ||
          (updateSchedule && updatedProductSchedule);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _onConfirm() async {
    if (widget.productId != null) {
      try {
        final success = await _updateProduct();
        if (success) {
          if (!mounted) return;
          Navigator.popUntil(
            context,
            ModalRoute.withName(UserShop.routeName),
          );
        } else {
          showToast('Failed to update product');
        }
      } catch (e) {
        showToast(e.toString());
      }
      return;
    }

    try {
      await _createProduct();
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => AddProductConfirmation(),
        ),
      );
    } catch (e) {
      showToast(e.toString());
    }
  }

  @override
  Widget screen(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Product Preview',
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
                  product.name!,
                  style: Theme.of(context).textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  product.description!,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    'Confirm',
                    kTealColor,
                    true,
                    () async => performFuture<void>(
                      () async => _onConfirm(),
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
