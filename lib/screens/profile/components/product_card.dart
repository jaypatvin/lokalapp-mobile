import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../providers/cart.dart';
import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/discover/product_card.vm.dart';
import '../../chat/components/chat_avatar.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(this.productId);
  final String productId;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => const _ProductCardView(),
      viewModel: ProductCardViewModel(
        productId: productId,
      ),
    );
  }
}

class _ProductCardView extends HookView<ProductCardViewModel> {
  // ignore: unused_element
  const _ProductCardView({super.key});

  @override
  Widget render(BuildContext context, ProductCardViewModel vm) {
    useEffect(
      () {
        final products = context.read<Products>();
        final shops = context.read<Shops>();
        final cart = context.read<ShoppingCart>();
        void borderListener() {
          vm.updateDisplayBorder(
            displayBorder: context.read<ShoppingCart>().contains(vm.productId),
          );
        }

        products.addListener(vm.onProductsUpdate);
        shops.addListener(vm.onProductsUpdate);
        cart.addListener(borderListener);

        return () {
          products.removeListener(vm.onProductsUpdate);
          shops.removeListener(vm.onProductsUpdate);
          cart.removeListener(borderListener);
        };
      },
      [vm],
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        border: vm.displayBorder
            ? Border.all(color: Colors.orange, width: 3)
            : Border.all(color: Colors.white),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: vm.productImage ?? '',
              fit: BoxFit.cover,
              placeholder: (_, __) => Shimmer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              errorWidget: (ctx, url, err) {
                if (vm.productImage?.isEmpty ?? true) {
                  return const Center(child: Text('No image.'));
                }
                return const Center(child: Text('Error displaying image.'));
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ColoredBox(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    vm.productName,
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vm.productPrice,
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            ?.copyWith(color: kOrangeColor, fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: vm.onLike,
                        child: !vm.isLiked
                            ? const Icon(
                                MdiIcons.heartOutline,
                                size: 16.0,
                                color: Colors.black,
                              )
                            : const Icon(
                                MdiIcons.heart,
                                size: 16.0,
                                color: kPinkColor,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ChatAvatar(
                        displayName: vm.shop.name,
                        displayPhoto: vm.shop.profilePhoto,
                        radius: 7,
                        onTap: vm.onShopTap,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          vm.shop.name,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 9.0,
                          ),
                          Text(
                            vm.productRating,
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
