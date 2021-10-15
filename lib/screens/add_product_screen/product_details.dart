import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../providers/post_requests/product_body.dart';
import '../../utils/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/input_name.dart';
import 'components/add_product_gallery.dart';
import 'components/product_header.dart';
import 'product_schedule.dart';

class ProductDetails extends StatefulWidget {
  final AddProductGallery? gallery;
  final String? productId;

  ProductDetails({required this.gallery, this.productId});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool forDelivery = true;
  bool forPickup = true;
  final _stockController = TextEditingController();
  final FocusNode _stockFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    final details = context.read<ProductBody>();

    _stockController.text = details.quantity.toString();
  }

  Widget _buildCategories() {
    final productBody = context.read<ProductBody>();
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: Text(
            "Product Category",
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
              //border: Border.all(color: Colors.grey.shade200),
            ),
            child: ButtonTheme(
              alignedDropdown: true,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 13.h,
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                iconEnabledColor: kTealColor,
                iconDisabledColor: kTealColor,
                iconSize: 24.0.sp,
                icon: Icon(MdiIcons.chevronDown),
                underline: SizedBox(),
                value: productBody.productCategory,
                hint: Text(
                  "Select",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                items: <String>['A', 'B', 'C', 'D'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  productBody.update(productCategory: value);
                  setState(() {});
                },
                style: Theme.of(context).textTheme.bodyText1,
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
            "Current Stock",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const SizedBox(width: 15.0),
        Expanded(
          child: Consumer<ProductBody>(
            builder: (context, productBody, child) {
              return InputName(
                keyboardType: TextInputType.number,
                focusNode: this._stockFocusNode,
                controller: _stockController,
                hintText: "Quantity",
                style: Theme.of(context).textTheme.bodyText1,
                onChanged: (value) {
                  context
                      .read<ProductBody>()
                      .update(quantity: int.tryParse(value) ?? 0);
                },
                errorText:
                    productBody.quantity! < 0 ? "Enter a valid number." : null,
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildDeliveryOptions() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: null, //() => setState(() => forPickup = !forPickup),
            child: Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.transparent, //Colors.black,
                        width: 2,
                      ),
                    ),
                    child: Theme(
                      data: ThemeData(
                        accentColor: Colors.transparent,
                        unselectedWidgetColor: Colors.transparent,
                      ),
                      child: Checkbox(
                        checkColor: Colors.black,
                        value: forPickup,
                        onChanged: null,
                        // onChanged: (value) {
                        //   setState(() {
                        //     forPickup = value;
                        //   });
                        // },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text("Customer Pick-up"),
              ],
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: null, //() => setState(() => forDelivery = !forDelivery),
            child: Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.transparent, //Colors.black,
                        width: 2,
                      ),
                    ),
                    child: Theme(
                      data: ThemeData(
                        accentColor: Colors.transparent,
                        unselectedWidgetColor: Colors.transparent,
                      ),
                      child: Checkbox(
                        checkColor: Colors.black,
                        value: forDelivery,
                        onChanged: null,
                        // onChanged: (value) {
                        //   setState(() {
                        //     forDelivery = value;
                        //   });
                        // },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text("Delivery"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width * 0.05;
    final topPadding = MediaQuery.of(context).size.height * 0.03;
    final image = widget.gallery!.photoBoxes.first;

    final bool valid = (forDelivery | forPickup) &&
        context.read<ProductBody>().productCategory != null &&
        context.read<ProductBody>().productCategory!.isNotEmpty &&
        context.read<ProductBody>().quantity != null &&
        context.read<ProductBody>().quantity! >= 0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        titleText: "Product Details",
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
                        "Done",
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                "Delivery Options",
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 10),
              _buildDeliveryOptions(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  "Next",
                  kTealColor,
                  true,
                  valid
                      ? () {
                          pushNewScreen(
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
    );
  }
}
