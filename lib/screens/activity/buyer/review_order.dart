import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../models/order.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/activity/buyer/review_order.vm.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/inputs/input_description_field.dart';
import '../../../widgets/overlays/screen_loader.dart';

class ReviewOrder extends StatelessWidget {
  const ReviewOrder({super.key, required this.order});
  final Order order;
  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _ReviewOrderView(),
      viewModel: ReviewOrderViewModel(order: order),
    );
  }
}

class _ReviewOrderView extends HookView<ReviewOrderViewModel>
    with HookScreenLoader {
  @override
  Widget screen(BuildContext context, ReviewOrderViewModel viewModel) {
    final focusNodes = useRef(
      List<FocusNode>.generate(
        viewModel.order.products.length,
        (index) => useFocusNode(),
      ),
    );

    final order = viewModel.order;
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      appBar: CustomAppBar(
        backgroundColor: kTealColor,
        titleText: 'Review Order',
        titleStyle: const TextStyle(color: Colors.white),
        leadingWidth: 100,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, index) {
                  final product = order.products[index];

                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.image.isNotEmpty)
                            CachedNetworkImage(
                              imageUrl: product.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Shimmer(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              errorWidget: (_, __, ___) => const Center(
                                child: Text(
                                  'Error displaying Image',
                                ),
                              ),
                            )
                          else
                            const SizedBox(
                              height: 50,
                              width: 50,
                              child: Center(
                                child: Text('No image'),
                              ),
                            ),
                          const SizedBox(width: 16),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                viewModel.getShopId(product) ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Rate the item here',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(color: const Color(0xFF828282)),
                            ),
                          ),
                          RatingBar.builder(
                            itemSize: 20,
                            minRating: 1,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 2),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) =>
                                viewModel.onUpdateRating(
                              product: product,
                              rating: rating.toInt(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      InputDescriptionField(
                        hintText: 'Enter review here',
                        focusNode: focusNodes.value[index],
                        onChanged: (message) => viewModel.onUpdateReview(
                          product: product,
                          review: message,
                        ),
                      ),
                    ],
                  );
                },
                childCount: order.products.length,
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton.filled(
                      text: 'Submit Review',
                      onPressed: () async {
                        for (final node in focusNodes.value) {
                          node.unfocus();
                        }
                        await performFuture(viewModel.onSubmitReview);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
