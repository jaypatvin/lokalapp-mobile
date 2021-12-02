import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/cart.dart';
import '../../providers/shops.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/discover/product_detail.vm.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../chat/components/chat_avatar.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = '/discover/productDetail';
  const ProductDetail(this.product, {Key? key}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _ProductDetailView(),
      viewModel: ProductDetailViewModel(
        product: this.product,
        cart: context.read<ShoppingCart>(),
        shop: context.read<Shops>().findById(this.product.shopId)!,
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

    useEffect(() {
      final void Function() listener = () {
        vm.onInstructionsChanged(_instructionsController.text);
      };
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
        _instructionsController.removeListener(listener);
      };
    }, []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        buildLeading: true,
        leadingColor: kTealColor,
        backgroundColor: Colors.white,
        onPressedLeading: () => Navigator.pop(context),
        title: Row(
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
            SizedBox(width: 8.0),
            Flexible(
              child: Text(
                vm.appBarTitle,
                style: Theme.of(context).textTheme.headline5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
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
              toolbarButtons: [
                (node) {
                  return TextButton(
                    onPressed: () => node.unfocus(),
                    child: Text(
                      "Done",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.black),
                    ),
                  );
                },
              ],
            ),
          ],
        ),
        tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _ProductGallery(
                product: vm.product,
                currentIndex: _galleryIndex.value,
                controller: _photoView,
                onPageChanged: (index) => _galleryIndex.value = index,
              ),
              SizedBox(height: 10.h),
              _ProductItemAndPrice(
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
                          return Icon(
                            Icons.star,
                            color: Colors.amber,
                          );
                        },
                        onRatingUpdate: (rating) => null,
                        ignoreGestures: true,
                        itemSize: 24.0.h,
                      ),
                      Container(
                        child: Text(
                          vm.product.avgRating.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.amber),
                        ),
                      )
                    ],
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () => null,
                      child: Text(
                        "Read Reviews",
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.subtitle2?.fontSize,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
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
              SizedBox(height: 10.0.h),
              _SpecialInstructionsTextField(
                controller: _instructionsController,
                focusNode: _nodeInstructions,
              ),
              SizedBox(height: 20.0.h),
              Divider(thickness: 1, height: 2, color: Colors.grey.shade300),
              SizedBox(height: 20.0.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Quantity\t\t"),
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
              SizedBox(height: 20.0.h),
              _QuantityController(
                onAdd: vm.increase,
                onSubtract: vm.decrease,
              ),
              SizedBox(height: 30.0.h),
              Divider(thickness: 1, height: 2, color: Colors.grey.shade300),
              SizedBox(height: 20.0.h),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      vm.buttonLabel,
                      kTealColor,
                      true,
                      vm.onSubmit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductGallery extends StatelessWidget {
  final Product? product;
  final int currentIndex;
  final PhotoViewController? controller;
  final void Function(int) onPageChanged;
  const _ProductGallery({
    Key? key,
    required this.product,
    required this.currentIndex,
    required this.controller,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gallery = product!.gallery;
    if (gallery == null || gallery.length <= 0)
      return SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: Center(child: Text("No Images")),
      );
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: product!.gallery!.length,
            onPageChanged: onPageChanged,
            gaplessPlayback: true,
            builder: (context, index) {
              final image = product!.gallery![index];
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(image.url),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
                disableGestures: true,
                controller: controller,
                errorBuilder: (ctx, _, __) => const SizedBox.shrink(),
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Theme.of(context).canvasColor,
            ),
            loadingBuilder: (context, event) => Center(
              child: Container(
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
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: gallery.map((url) {
                int index = gallery.indexOf(url);
                return Container(
                  width: 9.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.black),
                    color: currentIndex == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductItemAndPrice extends StatelessWidget {
  final String? productName;
  final double? productPrice;
  const _ProductItemAndPrice({
    Key? key,
    required this.productName,
    required this.productPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            productName!,
            maxLines: null,
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          productPrice.toString(),
          style: Theme.of(context).textTheme.headline5?.copyWith(
                color: kOrangeColor,
                fontSize: 26.0.sp,
                fontWeight: FontWeight.w600,
              ),
        )
      ],
    );
  }
}

class _SpecialInstructionsTextField extends StatelessWidget {
  final maxLines = 10;
  final TextEditingController controller;
  final FocusNode? focusNode;
  const _SpecialInstructionsTextField(
      {Key? key, required this.controller, this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxLines * 15.0,
      child: TextField(
        focusNode: this.focusNode,
        controller: controller,
        onChanged: null,
        cursorColor: Colors.black,
        keyboardType: TextInputType.multiline,
        maxLines: maxLines,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey.shade300,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey.shade300,
            ),
          ),
          // errorBorder: InputBorder.none,
          // disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 24.0.w,
            vertical: 24.0.w,
          ),
          hintText: "e.g no bell peppers, please.",
          hintStyle: TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 16.0.sp,
            fontFamily: "Goldplay",
            fontWeight: FontWeight.w500,
            // fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _QuantityController extends StatelessWidget {
  final void Function()? onAdd;
  final void Function()? onSubtract;
  const _QuantityController({
    Key? key,
    this.onAdd,
    this.onSubtract,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double dimension = 50.0.w;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onSubtract,
          child: Icon(
            Icons.remove,
            size: 35.0.r,
            color: Colors.black,
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(dimension, dimension),
            shape: CircleBorder(),
            primary: Colors.white,
            elevation: 0.0,
            side: BorderSide(color: Colors.black),
          ),
        ),
        SizedBox(width: 15.0.w),
        ElevatedButton(
          onPressed: onAdd,
          child: Icon(
            Icons.add,
            size: 35.0.r,
            color: Colors.black,
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(dimension, dimension),
            shape: CircleBorder(),
            primary: Colors.white,
            elevation: 0.0,
            side: BorderSide(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
