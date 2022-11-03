import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../models/lokal_category.dart';
import '../../../providers/categories.dart';
import '../../../providers/post_requests/product_body.dart';
import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_checkbox.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/inputs/input_name_field.dart';
import '../../../widgets/overlays/constrained_scrollview.dart';
import '../../../widgets/photo_box.dart';
import 'components/product_header.dart';
import 'product_schedule.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    Key? key,
    required this.images,
    this.productId,
  }) : super(key: key);
  final String? productId;
  final List<PhotoBoxImageSource> images;

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
    final categories = context.read<Categories>();

    if (categories.categories.isEmpty) {
      categories.fetch().then((_) {
        if (categories.categories.isEmpty ||
            (details.productCategory?.isNotEmpty ?? false)) return;
        details.update(
          productCategory: categories.categories.first.name,
        );
      });
    } else {
      if (details.productCategory?.isNotEmpty ?? false) return;
      details.update(
        productCategory: categories.categories.first.name,
        notify: false,
      );
    }
  }

  Widget _buildTable() {
    final productBody = context.read<ProductBody>();
    return Table(
      columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(3)},
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      // border: const TableBorder(
      //   horizontalInside: BorderSide(
      //     color: Colors.white,
      //     width: 5,
      //   ),
      // ),
      children: [
        TableRow(
          children: [
            Text(
              'Product Category',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  ?.copyWith(color: Colors.black),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: ButtonTheme(
                alignedDropdown: true,
                padding: const EdgeInsets.symmetric(horizontal: 22),
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
                      icon: const Icon(MdiIcons.chevronDown),
                      underline: const SizedBox(),
                      value: productBody.productCategory,
                      hint: Text(
                        'Select',
                        style: Theme.of(context).textTheme.bodyText2,
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
                      style: Theme.of(context).textTheme.bodyText2,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const TableRow(
          children: [
            SizedBox(height: 22),
            SizedBox(height: 22),
          ],
        ),
        TableRow(
          children: [
            Text(
              'Current Stock',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  ?.copyWith(color: Colors.black),
            ),
            Consumer<ProductBody>(
              builder: (context, productBody, child) {
                return InputNameField(
                  keyboardType: TextInputType.number,
                  focusNode: _stockFocusNode,
                  controller: _stockController,
                  hintText: 'Quantity',
                  style: Theme.of(context).textTheme.bodyText2,
                  onChanged: (value) {
                    context
                        .read<ProductBody>()
                        .update(quantity: int.tryParse(value) ?? 0);
                  },
                  errorText: productBody.quantity! < 0
                      ? 'Enter a valid number.'
                      : null,
                );
              },
            )
          ],
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
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(height: 10),
        Consumer<ProductBody>(
          builder: (ctx, productBody, child) {
            return AppCheckBox(
              shape: BoxShape.circle,
              value: productBody.canSubscribe,
              onTap: () => productBody.update(
                canSubscribe: !productBody.canSubscribe,
              ),
              title: Text(
                'Available for Subscription',
                style: Theme.of(context).textTheme.subtitle2,
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const SizedBox(width: 34),
            Expanded(
              child: Text(
                'Lets your customers create an auto-order on specific dates.',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(fontWeight: FontWeight.w400),
                maxLines: 2,
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width * 0.05;
    final topPadding = MediaQuery.of(context).size.height * 0.03;
    final image = widget.images.isNotEmpty
        ? widget.images.first
        : const PhotoBoxImageSource();

    final bool valid = (_forDelivery | _forPickup) &&
        context.read<ProductBody>().productCategory != null &&
        context.read<ProductBody>().productCategory!.isNotEmpty &&
        context.read<ProductBody>().quantity != null &&
        context.read<ProductBody>().quantity! >= 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        titleText: 'Product Details',
      ),
      body: ConstrainedScrollView(
        child: Padding(
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
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<ProductBody>(
                  builder: (context, product, child) {
                    return ProductHeader(
                      productHeaderImageSource: image,
                      productName: product.name ?? '',
                      productPrice: product.basePrice ?? 0.0,
                      productStock: product.quantity ?? 0,
                    );
                  },
                ),
                const SizedBox(height: 32),
                _buildTable(),
                const SizedBox(height: 32),
                _buildSubscriptionSection(),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.filled(
                    text: 'Next',
                    onPressed: valid
                        ? () {
                            Navigator.push(
                              context,
                              AppNavigator.appPageRoute(
                                builder: (_) => ProductSchedule(
                                  images: widget.images,
                                  productId: widget.productId,
                                ),
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
