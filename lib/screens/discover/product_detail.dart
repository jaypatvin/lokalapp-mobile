import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/cart.dart';
import '../../providers/shops.dart';
import '../../utils/themes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../chat/components/chat_avatar.dart';
import '../profile_screens/components/store_rating.dart';

class ProductDetail extends StatefulWidget {
  final Product? product;
  ProductDetail(this.product);
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final TextEditingController _instructionsController = TextEditingController();
  final FocusNode _nodeInstructions = FocusNode();
  PhotoViewController? _photoViewcontroller;

  int _current = 0;
  int quantity = 1;
  String? _appBarTitle;
  String? _buttonLabel;

  @override
  void initState() {
    super.initState();
    final product = widget.product!;
    this._appBarTitle = context.read<Shops>().findById(product.shopId)!.name;
    this._buttonLabel = "ADD TO CART";
    _photoViewcontroller = PhotoViewController();

    // get order details from cart if it exists
    final cart = context.read<ShoppingCart>();
    if (cart.contains(product.id)) {
      final order = cart.getProductOrder(product.id)!;
      _instructionsController.value = TextEditingValue(
        text: order.notes!,
        selection: TextSelection.fromPosition(
          TextPosition(offset: order.notes!.length),
        ),
      );
      this.quantity = order.quantity;
      this._appBarTitle = "Edit Order";
      this._buttonLabel = "UPDATE CART";
    }
  }

  @override
  void dispose() {
    _photoViewcontroller!.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void add() {
    setState(() {
      quantity++;
    });
  }

  void minus() {
    setState(() {
      if (quantity != 0) quantity--;
    });
  }

  void onPageChanged(int index) {
    if (this.mounted) {
      setState(() {
        _current = index;
      });
    }
  }

  buildReviews() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: TextButton(
            onPressed: () {},
            child: Text("Read Reviews"),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.read<Shops>().findById(widget.product!.shopId)!;
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
                displayName: shop.name,
                displayPhoto: shop.profilePhoto,
                radius: (kToolbarHeight * 0.80) / 2,
              ),
            ),
            SizedBox(width: 8.0),
            Text(
              _appBarTitle!,
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Goldplay",
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: kTealColor,
              size: 28.0,
            ),
            onPressed: null,
          ),
        ],
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
        tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _ProductGallery(
                product: widget.product,
                currentIndex: _current,
                controller: _photoViewcontroller,
                onPageChanged: onPageChanged,
              ),
              SizedBox(height: 10),
              _ProductItemAndPrice(
                productName: widget.product!.name,
                productPrice: widget.product!.basePrice,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [StoreRating(), buildReviews()],
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.product!.description!),
              ),
              Divider(thickness: 1, height: 2, color: Colors.grey.shade300),
              SizedBox(height: 16),
              _SpecialInstructionsLabel(),
              _SpecialInstructionsTextField(
                controller: this._instructionsController,
                focusNode: this._nodeInstructions,
              ),
              SizedBox(height: 20),
              Divider(thickness: 1, height: 2, color: Colors.grey.shade300),
              SizedBox(height: 30),
              //buildQuantity(),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Quantity\t"),
                    TextSpan(
                      text: "$quantity",
                      style: TextStyle(
                        fontFamily: "Goldplay",
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: kTealColor,
                      ),
                    ),
                  ],
                  style: TextStyle(
                    fontFamily: "Goldplay",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _QuantityController(
                onAdd: add,
                onSubtract: minus,
              ),
              SizedBox(height: 30),
              Divider(thickness: 1, height: 2, color: Colors.grey.shade300),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      this._buttonLabel,
                      kTealColor,
                      true,
                      () {
                        Provider.of<ShoppingCart>(context, listen: false).add(
                          shopId: widget.product!.shopId,
                          productId: widget.product!.id,
                          quantity: quantity,
                          notes: _instructionsController.text,
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
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
        height: MediaQuery.of(context).size.height / 2,
        child: Center(child: Text("No Images")),
      );
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
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
            //enableRotation: true,
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
            style: TextStyle(
              fontFamily: "Goldplay",
              fontWeight: FontWeight.w800,
              fontSize: 26.0,
              color: kNavyColor,
            ),
          ),
        ),
        Text(
          productPrice.toString(),
          style: TextStyle(
            color: kOrangeColor,
            fontSize: 32.0,
            fontWeight: FontWeight.w800,
          ),
        )
      ],
    );
  }
}

class _SpecialInstructionsLabel extends StatelessWidget {
  const _SpecialInstructionsLabel({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Special Instructions",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontFamily: "Goldplay",
            fontSize: 24,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          "Optional",
          style: TextStyle(
            fontFamily: "Goldplay",
            fontSize: 16,
            fontWeight: FontWeight.w500,
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
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey.shade500,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
          ),
          // errorBorder: InputBorder.none,
          // disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 24.0,
          ),
          hintText: "e.g no bell peppers, please.",
          hintStyle: TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 16,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 60.0,
          width: 60.0,
          child: RawMaterialButton(
            onPressed: onSubtract,
            elevation: 5.0,
            fillColor: Colors.white,
            shape: CircleBorder(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Icon(
              Icons.remove,
              size: 35.0,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Container(
          height: 60.0,
          width: 60.0,
          child: RawMaterialButton(
            onPressed: onAdd,
            elevation: 5.0,
            fillColor: Colors.white,
            shape: CircleBorder(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Icon(
              Icons.add,
              size: 35.0,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
