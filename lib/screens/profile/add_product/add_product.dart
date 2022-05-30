import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../models/failure_exception.dart';
import '../../../models/lokal_images.dart';
import '../../../models/status.dart';
import '../../../providers/post_requests/product_body.dart';
import '../../../providers/products.dart';
import '../../../utils/constants/themes.dart';
import '../../../utils/media_utility.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/inputs/input_description_field.dart';
import '../../../widgets/inputs/input_name_field.dart';
import '../../../widgets/overlays/constrained_scrollview.dart';
import '../../../widgets/overlays/screen_loader.dart';
import '../../../widgets/photo_box.dart';
import '../shop/user_shop.dart';
import 'components/add_product_gallery.dart';
import 'product_details.dart';

class AddProduct extends StatefulWidget {
  static const routeName = '/profile/addProduct';
  const AddProduct({this.productId});

  final String? productId;

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> with ScreenLoader {
  late final String _title;

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  String? _errorTextName;
  String? _errorTextDescription;
  String? _errorTextPrice;

  final List<PhotoBoxImageSource> _images = [];

  @override
  void initState() {
    super.initState();

    if (widget.productId != null && widget.productId!.isNotEmpty) {
      final product = context.read<Products>().findById(widget.productId);

      if (product != null) {
        if (product.gallery?.isNotEmpty ?? false) {
          _images.addAll(
            product.gallery!
                .map<PhotoBoxImageSource>(
                  (image) => PhotoBoxImageSource(url: image.url),
                )
                .toList(),
          );
        }

        _nameController.text = product.name;
        _priceController.text = product.basePrice.toString();
        _descriptionController.text = product.description;
        _title = 'Edit Product';

        List<LokalImages>? _productGallery = <LokalImages>[];
        if (product.gallery != null) {
          _productGallery = product.gallery;
        }

        context.read<ProductBody>()
          ..clear()
          ..update(
            name: product.name,
            description: product.description,
            shopId: product.shopId,
            basePrice: product.basePrice,
            quantity: product.quantity,
            productCategory: product.productCategory,
            status: product.status.value,
            canSubscribe: product.canSubscribe,
            gallery: _productGallery!.map((e) => e.toJson()).toList(),
          );
        return;
      }
    }

    _title = 'Add a New Product';
  }

  Future<void> _onSelectImage(int index) async {
    final file = await context.read<MediaUtility>().showMediaDialog(context);
    if (file != null) {
      setState(() {
        if (_images.isEmpty || index >= _images.length) {
          _images.add(PhotoBoxImageSource(file: file));
        } else {
          _images[index] = PhotoBoxImageSource(file: file);
        }
      });
    }
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardBarColor: Colors.grey.shade200,
      actions: [
        KeyboardActionsItem(
          focusNode: _nameFocusNode,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(),
                child: Text(
                  'Done',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black,
                      ),
                ),
              );
            },
          ],
        ),
        KeyboardActionsItem(
          focusNode: _descriptionFocusNode,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(),
                child: Text(
                  'Done',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black,
                      ),
                ),
              );
            },
          ],
        ),
        KeyboardActionsItem(
          focusNode: _priceFocusNode,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(),
                child: Text(
                  'Done',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black,
                      ),
                ),
              );
            },
          ],
        ),
      ],
    );
  }

  Widget _buildProductPrice() {
    return Row(
      children: [
        Text(
          'Product Price',
          style: Theme.of(context)
              .textTheme
              .subtitle2
              ?.copyWith(color: Colors.black),
        ),
        const SizedBox(width: 27),
        Expanded(
          child: InputNameField(
            controller: _priceController,
            focusNode: _priceFocusNode,
            errorText: _errorTextPrice,
            keyboardType: TextInputType.number,
            hintText: 'PHP',
            style: const TextStyle(fontSize: 18),
            onChanged: (value) {
              if (_errorTextPrice != null) {
                setState(() {
                  _errorTextPrice = null;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  void _onSubmitHandler() {
    if (_nameController.text.isEmpty) {
      setState(() {
        _errorTextName = 'Name must not be empty.';
      });
    }

    if (_descriptionController.text.isEmpty) {
      setState(() {
        _errorTextDescription = 'Description must not be empty.';
      });
    }

    if (_priceController.text.isEmpty ||
        double.tryParse(_priceController.text)! <= 0) {
      setState(() {
        _errorTextPrice = 'Enter a valid price.';
      });
    }

    if (_errorTextName?.isNotEmpty ??
        _errorTextDescription?.isNotEmpty ??
        _errorTextPrice?.isNotEmpty ??
        false) {
      return;
    }

    context.read<ProductBody>().update(
          basePrice: double.tryParse(_priceController.text) ?? 0,
          name: _nameController.text,
          description: _descriptionController.text,
        );

    Navigator.push(
      context,
      AppNavigator.appPageRoute(
        builder: (_) => ProductDetails(
          images: _images,
          productId: widget.productId,
        ),
      ),
    );
  }

  Future<bool?> _onDeleteNotify() async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        return Center(
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 58),
                  child: Text(
                    'Are you sure you want to delete this product?',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 23),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    'All active orders of this product will still push '
                    'through but they will not be able to order again. '
                    'We will notify subscribers that their next order will '
                    'be their last.',
                    textAlign: TextAlign.center,
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: AppButton.transparent(
                            text: 'Cancel',
                            onPressed: () => Navigator.pop(ctx, false),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppButton.filled(
                            text: 'Confirm',
                            color: kPinkColor,
                            onPressed: () => Navigator.pop(ctx, true),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onDeleteHandler() async {
    try {
      final delete = await _onDeleteNotify() ?? false;

      if (delete) {
        await performFuture(
          () async => context.read<Products>().deleteProduct(widget.productId!),
        );
        if (!mounted) return;
        Navigator.popUntil(
          context,
          ModalRoute.withName(UserShop.routeName),
        );
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }

  @override
  void deactivate() {
    context.read<ProductBody>().clear();
    super.deactivate();
  }

  @override
  Widget screen(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width * 0.05;
    final topPadding = MediaQuery.of(context).size.height * 0.02;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        titleText: _title,
        actions: _title == 'Edit Product'
            ? [
                IconButton(
                  icon: const Icon(
                    MdiIcons.trashCanOutline,
                  ),
                  onPressed: _onDeleteHandler,
                ),
              ]
            : null,
      ),
      body: ConstrainedScrollView(
        child: KeyboardActions(
          config: _buildConfig(),
          disableScroll: true,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              topPadding,
              horizontalPadding,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Photos',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 85,
                  child: AddProductGallery(
                    images: _images,
                    onSelectImage: _onSelectImage,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Product Name',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 12),
                InputNameField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  hintText: 'Item Name',
                  errorText: _errorTextName,
                  onChanged: (value) {
                    if (_errorTextName != null) {
                      setState(() {
                        _errorTextName = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Description',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 12),
                InputDescriptionField(
                  controller: _descriptionController,
                  focusNode: _descriptionFocusNode,
                  hintText: 'Product Description',
                  errorText: _errorTextDescription,
                  onChanged: (value) {
                    if (_errorTextDescription != null) {
                      setState(() {
                        _errorTextDescription = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),
                _buildProductPrice(),
                const Spacer(),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.filled(
                    text: 'Next',
                    onPressed: _onSubmitHandler,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
