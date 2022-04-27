import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/cart.dart';
import '../../providers/shops.dart';
import '../../providers/wishlist.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/discover/product_detail.vm.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../chat/components/chat_avatar.dart';
import 'product_detail/product_detail.gallery.dart';
import 'product_detail/product_detail.name_price.dart';
import 'product_detail/product_detail.quantity_controller.dart';
import 'product_detail/product_detail.special_instructions.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = '/discover/productDetail';
  const ProductDetail(this.product, {Key? key}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    if (product.archived) {
      return const Center(
        child: Text('Sorry, the product has been deleted.'),
      );
    }

    return MVVM(
      view: (_, __) => _ProductDetailView(),
      viewModel: ProductDetailViewModel(
        product: product,
        cart: context.read<ShoppingCart>(),
        shop: context.read<Shops>().findById(product.shopId)!,
      ),
    );
  }
}

class _ProductDetailView extends HookView<ProductDetailViewModel> {
  @override
  Widget render(BuildContext context, ProductDetailViewModel vm) {
    final _instructionsController = useTextEditingController();
    final _nodeInstructions = useFocusNode();
    final _photoView = useMemoized(() => PhotoViewController());
    final _galleryIndex = useState<int>(0);

    useEffect(
      () {
        final cart = context.read<ShoppingCart>();
        if (cart.contains(vm.product.id)) {
          final order = cart.getProductOrder(vm.product.id)!;
          _instructionsController.value = TextEditingValue(
            text: order.notes!,
            selection: TextSelection.fromPosition(
              TextPosition(offset: order.notes!.length),
            ),
          );
        }

        void listener() {
          vm.onInstructionsChanged(_instructionsController.text);
        }

        _instructionsController.addListener(listener);

        return () {
          _instructionsController.removeListener(listener);
        };
      },
      [],
    );

    // This is not used with hooks since we want to rebuild these widgets
    // everytime the screen is rebuilt.
    final _children = <Widget>[];

    _children.addAll(
      [
        SizedBox(height: 10.0.h),
        ProductDetailGallery(
          product: vm.product,
          currentIndex: _galleryIndex.value,
          controller: _photoView,
          onPageChanged: (index) => _galleryIndex.value = index,
        ),
        SizedBox(height: 10.h),
        ProductItemAndPrice(
          productName: vm.product.name,
          productPrice: vm.product.basePrice,
        ),
        SizedBox(height: 10.0.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                RatingBar.builder(
                  initialRating: vm.product.avgRating,
                  minRating: 1,
                  maxRating: 5,
                  allowHalfRating: true,
                  unratedColor: Colors.grey.shade300,
                  itemBuilder: (ctx, _) {
                    return const Icon(
                      Icons.star,
                      color: Colors.amber,
                    );
                  },
                  onRatingUpdate: (rating) {},
                  ignoreGestures: true,
                  itemSize: 18.0.h,
                ),
                SizedBox(width: 5.0.w),
                Text(
                  vm.product.avgRating.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.amber),
                )
              ],
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: Theme.of(context).textTheme.subtitle2?.copyWith(
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
              ),
              child: const Text('Read Reviews'),
            ),
          ],
        ),
        SizedBox(height: 10.0.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            vm.product.description,
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(height: 10.0.h),
        Divider(thickness: 1, height: 2, color: Colors.grey.shade300),
        SizedBox(height: 20.0.h),
      ],
    );

    if (vm.available) {
      _children.addAll(
        [
          Row(
            children: [
              Text(
                'Special Instructions',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 5.0.w),
              Text(
                'Optional',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0.h, bottom: 20.0.h),
            child: SpecialInstructionsTextField(
              controller: _instructionsController,
              focusNode: _nodeInstructions,
            ),
          ),
          Divider(thickness: 1, height: 2, color: Colors.grey.shade300),
          SizedBox(height: 10.0.h),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Quantity',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 20.0.w),
                Text(
                  vm.quantity.toString(),
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: kTealColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          QuantityController(
            onAdd: vm.increase,
            onSubtract: vm.decrease,
          ),
          SizedBox(height: 30.0.h),
          Divider(thickness: 1, height: 2, color: Colors.grey.shade300),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0.h),
            child: Row(
              children: [
                Expanded(
                  child: AppButton.transparent(
                    text: 'SUBSCRIBE',
                    onPressed: vm.onSubscribe,
                  ),
                ),
                Expanded(
                  child: AppButton.filled(
                    text: vm.buttonLabel,
                    onPressed: vm.onSubmit,
                    color: vm.buttonColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      _children.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0.h),
          child: SizedBox(
            width: double.infinity,
            child: Consumer<UserWishlist>(
              builder: (ctx, wishlist, __) {
                if (wishlist.isLoading) {
                  return AppButton.transparent(
                    text: '',
                  );
                }

                final _inWishlist = wishlist.items.contains(vm.product.id);
                return AppButton.transparent(
                  text:
                      _inWishlist ? 'Remove from Wishlist' : 'Add to Wishlist',
                  onPressed: vm.onWishlistPressed,
                );
              },
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        leadingColor: kTealColor,
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: vm.goToShop,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                child: ChatAvatar(
                  displayName: vm.shop.name,
                  displayPhoto: vm.shop.profilePhoto,
                  radius: 15.0.r,
                ),
              ),
              const SizedBox(width: 8.0),
              Flexible(
                child: Text(
                  vm.appBarTitle,
                  // style: Theme.of(context).textTheme.headline5,
                  style: const TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Added to center the Title
              SizedBox(
                width: 15.0.r + 24.0, // 24 is the icon size for the leading
              ),
            ],
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.more_horiz,
        //       color: kTealColor,
        //       size: 28.0.r,
        //     ),
        //     onPressed: null,
        //   ),
        // ],
      ),
      body: KeyboardActions(
        config: KeyboardActionsConfig(
          keyboardBarColor: Colors.transparent,
          actions: [
            KeyboardActionsItem(
              focusNode: _nodeInstructions,
              displayActionBar: false,
            ),
          ],
        ),
        tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Column(
            children: _children,
          ),
        ),
      ),
    );
  }
}
