import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../models/product_review.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/users.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/stateless.view.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/discover/product_reviews.vm.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/product_review_card.dart';

class ProductReviews extends StatelessWidget {
  const ProductReviews({Key? key, required this.productId}) : super(key: key);
  final String productId;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _ProductReviewsView(),
      viewModel: ProductReviewsViewModel(productId: productId),
    );
  }
}

class _ProductReviewsView extends StatelessView<ProductReviewsViewModel> {
  @override
  Widget render(BuildContext context, ProductReviewsViewModel viewModel) {
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      appBar: const CustomAppBar(
        titleText: 'View Reviews',
        titleStyle: TextStyle(color: Colors.white),
        backgroundColor: kTealColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        // child: ListView.builder(itemBuilder: (ctx, index) {}),
        child: FutureBuilder<List<ProductReview>>(
          initialData: const [],
          future: viewModel.fetchReviews(),
          builder: (ctx, snapshot) {
            final _product =
                context.read<Products>().findById(viewModel.productId);
            if (_product == null) {
              return const Center(
                child: Text('Error fetching product reviews.'),
              );
            }

            if (snapshot.connectionState != ConnectionState.done) {
              return SizedBox.expand(
                child: LottieBuilder.asset(
                  kAnimationLoading,
                  fit: BoxFit.fitWidth,
                ),
              );
            } else if (!snapshot.hasData) {
              return const Text('No reviews yet.');
            } else if (snapshot.hasError) {
              return const Text('Error fetching reviews');
            } else {
              final reviews = snapshot.data!;
              final _shop = context.read<Shops>().findById(_product.shopId);

              return ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (ctx, index) {
                  final _review = snapshot.data![index];
                  final _user = context.read<Users>().findById(_review.userId);
                  final _name = _user != null
                      ? '${_user.firstName} ${_user.lastName.substring(0, 1)}'
                      : null;

                  return ProductReviewCard.fromProductReview(
                    review: _review,
                    product: _product,
                    shopName: _shop?.name,
                    userName: _name,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
