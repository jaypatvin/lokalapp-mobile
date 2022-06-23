import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../models/order.dart';
import '../../../models/shop.dart';
import '../../../providers/products.dart';
import '../../../providers/shops.dart';
import '../../../providers/users.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/stateless.view.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/constants/themes.dart';
import '../../../view_models/activity/buyer/view_reviews.vm.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/product_review_card.dart';

class ViewReviews extends StatelessWidget {
  const ViewReviews({Key? key, required this.order}) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _ViewReviewsView(),
      viewModel: ViewReviewsViewModel(order: order),
    );
  }
}

class _ViewReviewsView extends StatelessView<ViewReviewsViewModel> {
  @override
  Widget render(BuildContext context, ViewReviewsViewModel viewModel) {
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
        child: FutureBuilder<List<OrderProduct>>(
          initialData: const [],
          future: viewModel.fetchOrderReviews(),
          builder: (ctx, snapshot) {
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
              return ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (ctx, index) {
                  final _orderProduct = snapshot.data![index];
                  final _product = context.read<Products>().findById(
                        _orderProduct.id,
                      );

                  final Shop? _shop;
                  if (_product != null) {
                    _shop = context.read<Shops>().findById(_product.shopId);
                  } else {
                    _shop = null;
                  }
                  final _user = context
                      .read<Users>()
                      .findById(_orderProduct.review?.userId);
                  final _name = _user != null
                      ? '${_user.firstName} ${_user.lastName.substring(0, 1)}'
                      : null;

                  return ProductReviewCard.fromOrderReview(
                    _orderProduct,
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