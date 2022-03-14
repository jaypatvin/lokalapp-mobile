import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../models/failure_exception.dart';
import '../../../models/lokal_images.dart';
import '../../../providers/auth.dart';
import '../../../providers/post_requests/operating_hours_body.dart';
import '../../../providers/post_requests/product_body.dart';
import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../routers/app_router.dart';
import '../../../services/local_image_service.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/overlays/constrained_scrollview.dart';
import '../../../widgets/overlays/screen_loader.dart';
import '../../../widgets/photo_box.dart';
import '../shop/user_shop.dart';
import 'confirmation.dart';
import 'product_schedule.dart';

class ProductPreview extends StatefulWidget {
  const ProductPreview({
    Key? key,
    required this.images,
    required this.scheduleState,
    this.productId,
  }) : super(key: key);
  final List<PhotoBoxImageSource> images;
  final ProductScheduleState? scheduleState;
  final String? productId;

  @override
  _ProductPreviewState createState() => _ProductPreviewState();
}

class _ProductPreviewState extends State<ProductPreview> with ScreenLoader {
  PhotoViewController? controller;
  int _current = 0;
  final List<File> _fileImages = [];
  final List<String> _urlImages = [];

  bool _isLoading = false;

  @override
  void initState() {
    for (final image in widget.images) {
      if (image.isFile) {
        _fileImages.add(image.file!);
      } else if (image.isUrl) {
        _urlImages.add(image.url!);
      }
    }

    super.initState();
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _fileImages.map((file) {
        final int index = _fileImages.indexOf(file);
        return Container(
          width: 9.0,
          height: 10.0,
          margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1.sp, color: kOrangeColor),
            color: _current == index ? kOrangeColor : Colors.transparent,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGallery() {
    return PhotoViewGallery.builder(
      itemCount: _fileImages.length + _urlImages.length,
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
            imageProvider: CachedNetworkImageProvider(image),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered,
            controller: controller,
            tightMode: true,
            errorBuilder: (ctx, _, __) => const SizedBox.shrink(),
          );
        } else {
          final _index = index - _urlImages.length;
          final image = _fileImages[_index];

          return PhotoViewGalleryPageOptions(
            basePosition: Alignment.center,
            imageProvider: FileImage(image),
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
    for (final image in _fileImages) {
      final mediaUrl = await context.read<LocalImageService>().uploadImage(
            file: image,
            src: kProductImagesSrc,
          );
      gallery.add(LokalImages(url: mediaUrl, order: gallery.length));
    }

    if (!mounted) return;
    final user = context.read<Auth>().user!;
    final shop = context.read<Shops>().findByUser(user.id).first;
    final products = context.read<Products>();
    final productBody = context.read<ProductBody>();
    try {
      productBody.update(
        gallery: gallery.map((image) => image.toJson()).toList(),
        shopId: shop.id,
        availability: context.read<OperatingHoursBody>().request.toJson(),
      );
      return await products.create(productBody.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> _updateProduct() async {
    final _productBody = context.read<ProductBody>();
    final _product = context.read<Products>().findById(widget.productId)!;
    final updateBody = ProductBody();
    updateBody.update(shopId: _product.shopId);
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

    updateBody.update(canSubscribe: _productBody.canSubscribe);

    if (_fileImages.isNotEmpty) {
      final gallery = <LokalImages>[..._product.gallery!];

      for (final image in _fileImages) {
        final mediaUrl = await context
            .read<LocalImageService>()
            .uploadImage(file: image, src: kProductImagesSrc);
        gallery.add(LokalImages(url: mediaUrl, order: gallery.length));
      }
      if (!listEquals(gallery, _product.gallery)) {
        updateBody.update(
          gallery: gallery.map((image) => image.toJson()).toList(),
        );
      }
    }

    final updateData = updateBody.data;
    updateData.remove('availability');

    for (final entry in ProductBody().data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (key == 'can_subscribe') {
        if (_product.canSubscribe == updateData[key]) updateData.remove(key);

        continue;
      }
      if (updateData[key] == value || updateData[key] == null) {
        updateData.remove(key);
        continue;
      }
    }

    if (updateData.length <= 1) {
      if (updateData['shop_id'] == _product.shopId) {
        updateData.remove('shop_id');
      }
    }

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
      final _operatingHoursRequest = context.read<OperatingHoursBody>();
      final availability = _product.availability;
      if (!listEquals(
        _operatingHoursRequest.request.unavailableDates..sort(),
        availability.unavailableDates..sort(),
      )) {
        // We update the availability of the product.
        updateSchedule = true;
      }
    }

    if (updateData.isEmpty && !updateSchedule) {
      // this would mean that there is nothing to update
      throw FailureException('Nothing to update');
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
        final _shop = context.read<Shops>().findById(_product.shopId);
        updatedProductSchedule = await context.read<Products>().setAvailability(
              id: _product.id,
              data: widget.scheduleState == ProductScheduleState.custom
                  ? context.read<OperatingHoursBody>().request.toJson()
                  : _shop!.operatingHours.toJson(),
            );
      }

      return (updateData.isNotEmpty && updatedProductDetails) ||
          (updateSchedule && updatedProductSchedule);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _onConfirm() async {
    try {
      if (_isLoading) return;
      setState(() {
        _isLoading = true;
      });

      if (widget.productId != null) {
        final success = await _updateProduct();
        if (success) {
          if (!mounted) return;
          AppRouter.profileNavigatorKey.currentState
              ?.popUntil(ModalRoute.withName(UserShop.routeName));
        } else {
          showToast('Failed to update product');
        }
      } else {
        await _createProduct();
        if (!mounted) return;
        AppRouter.profileNavigatorKey.currentState?.pushAndRemoveUntil(
          AppNavigator.appPageRoute(
            builder: (_) => const AddProductConfirmation(),
          ),
          ModalRoute.withName(UserShop.routeName),
        );
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
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
      body: ConstrainedScrollView(
        child: Padding(
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
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description!,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton.filled(
                      text: 'Confirm',
                      onPressed: () async => performFuture<void>(
                        () async => _onConfirm(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
