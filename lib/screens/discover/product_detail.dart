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
import '../../services/bottom_nav_bar_hider.dart';
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
    final _navBarHider = useMemoized<BottomNavBarHider>(
      () => context.read<BottomNavBarHider>(),
    );

    useEffect(
      () {
        Future.delayed(const Duration(milliseconds: 100), () {
          _navBarHider.isHidden = true;
        });
        void listener() {
          vm.onInstructionsChanged(_instructionsController.text);
        }

        _instructionsController.addListener(listener);
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
        return () {
          Future.delayed(const Duration(milliseconds: 100), () {
            _navBarHider.isHidden = false;
          });
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
                  itemSize: 24.0.h,
                ),
                Text(
                  vm.product.avgRating.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.amber),
                )
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: Theme.of(context).textTheme.subtitle2?.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                  ),
                  child: const Text('Read Reviews'),
                ),
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            vm.product.description ?? '',
            style: Theme.of(context).textTheme.bodyText1,
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
          Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                text: 'Special Instructions ',
                children: [
                  TextSpan(
                    text: 'Optional',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontSize: 12.0.sp),
                  ),
                ],
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(fontSize: 20.0.sp),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0.h, bottom: 20.0.h),
            child: SpecialInstructionsTextField(
              controller: _instructionsController,
              focusNode: _nodeInstructions,
            ),
          ),
          Divider(thickness: 1, height: 2, color: Colors.grey.shade300),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0.h),
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(text: 'Quantity\t\t'),
                  TextSpan(
                    text: vm.quantity.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(fontSize: 20.0.sp, color: kTealColor),
                  ),
                ],
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(fontSize: 20.0.sp),
              ),
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
                  child: AppButton.filled(
                    text: vm.buttonLabel,
                    onPressed: vm.onSubmit,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      _children.add(
        SizedBox(
          width: double.infinity,
          // child: AppButton.transparent(text: 'Add to Wishlist'),
          child: Consumer<UserWishlist>(
            builder: (ctx, wishlist, __) {
              if (wishlist.isLoading) {
                return AppButton.transparent(
                  text: '',
                );
              }

              final _inWishlist = wishlist.items.contains(vm.product.id);

              return AppButton.transparent(
                text: _inWishlist ? 'Remove from Wishlist' : 'Add to Wishlist',
                onPressed: vm.onWishlistPressed,
              );
            },
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        leadingColor: kTealColor,
        backgroundColor: Colors.white,
        onPressedLeading: () => Navigator.pop(context),
        title: GestureDetector(
          onTap: vm.goToShop,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: kToolbarHeight * 0.80,
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
                  style: Theme.of(context).textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: _children,
          ),
        ),
      ),
    );
  }
}
