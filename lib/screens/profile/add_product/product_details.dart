import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/lokal_category.dart';
import '../../../providers/categories.dart';
import '../../../providers/post_requests/product_body.dart';
import '../../../routers/app_router.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_checkbox.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/inputs/input_name_field.dart';
import 'components/add_product_gallery.dart';
import 'components/product_header.dart';
import 'product_schedule.dart';

class ProductDetails extends StatefulWidget {
  final AddProductGallery? gallery;
  final String? productId;

  const ProductDetails({required this.gallery, this.productId});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final bool _forDelivery = true;
  final bool _forPickup = true;
  final _stockController = TextEditingController();
  final FocusNode _stockFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    final details = context.read<ProductBody>();
    _stockController.text = details.quantity.toString();

    if (context.read<Categories>().categories.isEmpty) {
      context.read<Categories>().fetch();
    }
  }

  Widget _buildCategories() {
    final productBody = context.read<ProductBody>();
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: Text(
            'Product Category',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const SizedBox(width: 15.0),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5.0.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(30.0.r),
            ),
            child: ButtonTheme(
              alignedDropdown: true,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 13.h,
              ),
              child: Consumer<Categories>(
                builder: (ctx, provider, _) {
                  if (provider.isLoading || provider.categories.isEmpty) {
                    return const SizedBox();
                  }

                  if (productBody.productCategory != null &&
                          productBody.productCategory!.isEmpty ||
                      !provider.categories
                          .any((c) => c.id == productBody.productCategory!)) {
                    productBody.update(
                      productCategory: provider.categories.first.id,
                    );
                  }

                  return DropdownButton<String>(
                    isExpanded: true,
                    iconEnabledColor: kTealColor,
                    iconDisabledColor: kTealColor,
                    iconSize: 24.0.sp,
                    icon: const Icon(MdiIcons.chevronDown),
                    underline: const SizedBox(),
                    value: productBody.productCategory,
                    hint: Text(
                      'Select',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    items: provider.categories.map((LokalCategory category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      productBody.update(productCategory: value);
                      setState(() {});
                    },
                    style: Theme.of(context).textTheme.bodyText1,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStock() {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: Text(
            'Current Stock',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const SizedBox(width: 15.0),
        Expanded(
          child: Consumer<ProductBody>(
            builder: (context, productBody, child) {
              return InputNameField(
                keyboardType: TextInputType.number,
                focusNode: _stockFocusNode,
                controller: _stockController,
                hintText: 'Quantity',
                style: Theme.of(context).textTheme.bodyText1,
                onChanged: (value) {
                  context
                      .read<ProductBody>()
                      .update(quantity: int.tryParse(value) ?? 0);
                },
                errorText:
                    productBody.quantity! < 0 ? 'Enter a valid number.' : null,
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildDeliveryOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: AppCheckBox(
            value: _forPickup,
            onTap: () {}, // () => setState(() => _forPickup = !_forPickup),
            title: const Text('Customer Pick-up'),
          ),
        ),
        Expanded(
          child: AppCheckBox(
            value: _forDelivery,
            onTap: () {}, //() => setState(() => _forDelivery = !_forDelivery),
            title: const Text('Delivery'),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subscription',
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 10),
        Consumer<ProductBody>(
          builder: (ctx, productBody, child) {
            return AppCheckBox(
              value: productBody.canSubscribe,
              onTap: () => productBody.update(
                canSubscribe: !productBody.canSubscribe,
              ),
              title: Text(
                'Available for Subscription',
                style: Theme.of(context).textTheme.headline6,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width * 0.05;
    final topPadding = MediaQuery.of(context).size.height * 0.03;
    final image = widget.gallery!.photoBoxes.first;

    final bool valid = (_forDelivery | _forPickup) &&
        context.read<ProductBody>().productCategory != null &&
        context.read<ProductBody>().productCategory!.isNotEmpty &&
        context.read<ProductBody>().quantity != null &&
        context.read<ProductBody>().quantity! >= 0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        titleText: 'Product Details',
        onPressedLeading: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          topPadding,
          horizontalPadding,
          0,
        ),
        child: KeyboardActions(
          config: KeyboardActionsConfig(
            keyboardBarColor: Colors.grey[200],
            actions: [
              KeyboardActionsItem(
                focusNode: _stockFocusNode,
                displayArrows: false,
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
          ),
          disableScroll: true,
          tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<ProductBody>(
                  builder: (context, product, child) {
                    return ProductHeader(
                      photoBox: image,
                      productName: product.name,
                      productPrice: product.basePrice,
                      //productStock: product.quantity,
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                _buildCategories(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                _buildCurrentStock(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Text(
                  'Delivery Options',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 10),
                _buildDeliveryOptions(),
                const SizedBox(height: 10),
                _buildSubscriptionSection(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.filled(
                    text: 'Next',
                    onPressed: valid
                        ? () {
                            AppRouter.pushNewScreen(
                              context,
                              screen: ProductSchedule(
                                gallery: widget.gallery,
                                productId: widget.productId,
                              ),
                            );
                          }
                        : null,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
