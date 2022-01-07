import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../models/lokal_images.dart';
import '../../../providers/post_requests/product_body.dart';
import '../../../providers/products.dart';
import '../../../routers/app_router.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/inputs/input_description_field.dart';
import '../../../widgets/inputs/input_name_field.dart';
import '../../../widgets/overlays/screen_loader.dart';
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
  AddProductGallery? _gallery;
  String? _title;

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  String? _errorTextName;
  String? _errorTextPrice;

  @override
  void initState() {
    super.initState();

    if (widget.productId != null && widget.productId!.isNotEmpty) {
      final product = context.read<Products>().findById(widget.productId);

      if (product != null) {
        _gallery = AddProductGallery(
          images: product.gallery,
        );
        _nameController.text = product.name;
        _priceController.text = product.basePrice.toString();
        _descriptionController.text = product.description!;
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
            status: product.status,
            canSubscribe: product.canSubscribe,
            gallery: _productGallery!.map((e) => e.toMap()).toList(),
          );
        return;
      }
    }

    _gallery = AddProductGallery();
    _title = 'Add a New Product';
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
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: InputNameField(
            controller: _priceController,
            focusNode: _priceFocusNode,
            errorText: _errorTextPrice,
            keyboardType: TextInputType.number,
            hintText: 'PHP',
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
        _errorTextName = 'Enter a valid name.';
      });
      return;
    }

    if (_priceController.text.isEmpty ||
        double.tryParse(_priceController.text)! <= 0) {
      setState(() {
        _errorTextPrice = 'Enter a valid price.';
      });
      return;
    }

    context.read<ProductBody>().update(
          basePrice: double.tryParse(_priceController.text) ?? 0,
          name: _nameController.text,
          description: _descriptionController.text,
        );

    AppRouter.pushNewScreen(
      context,
      screen: ProductDetails(
        gallery: _gallery,
        productId: widget.productId,
      ),
    );
  }

  Future<bool?> _onDeleteNotify() async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        return Center(
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 20.0.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20.0.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0.w),
                  child: Text(
                    'Are you sure you want to delete this product?',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 15.0.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0.w),
                  child: const Text(
                    'All active orders of this product will still push '
                    'through but they will not be able to order again. '
                    'We will notify subscribers that their next order will '
                    'be their last.',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10.0.h),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: AppButton(
                            'Cancel',
                            kTealColor,
                            false,
                            () => Navigator.pop(ctx, false),
                          ),
                        ),
                        SizedBox(width: 5.0.w),
                        Expanded(
                          child: AppButton(
                            'Confirm',
                            kPinkColor,
                            true,
                            () => Navigator.pop(ctx, true),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0.h),
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
    } catch (e) {
      showToast(e.toString());
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
        onPressedLeading: () {
          Navigator.pop(context);
        },
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
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          topPadding,
          horizontalPadding,
          0,
        ),
        child: KeyboardActions(
          config: _buildConfig(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product Photos',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              _gallery!,
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Text(
                'Product Name',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.005,
              ),
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Text(
                'Description',
                style: Theme.of(context).textTheme.headline6,
              ),
              InputDescriptionField(
                controller: _descriptionController,
                focusNode: _descriptionFocusNode,
                hintText: 'Product Description',
              ),
              const SizedBox(height: 20),
              _buildProductPrice(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  'Next',
                  kTealColor,
                  true,
                  _onSubmitHandler,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
