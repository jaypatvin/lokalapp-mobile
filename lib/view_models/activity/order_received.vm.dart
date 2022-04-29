import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../models/failure_exception.dart';
import '../../models/order.dart';
import '../../models/post_requests/product/product_review.request.dart';
import '../../services/api/api.dart';
import '../../services/api/product_api.dart';
import '../../state/view_model.dart';
import '../../utils/constants/assets.dart';

class OrderReceivedViewModel extends ViewModel {
  OrderReceivedViewModel(this.order);
  final Order order;

  bool ratingSubmitted = false;
  int rating = 0;

  String ratingTitle = '';
  String ratingMessage = '';
  String assetName = kSvg1StarRating;

  void onBackToActivity() {
    locator<AppRouter>().popUntil(
      AppRoute.activity,
      predicate: ModalRoute.withName(ActivityRoutes.activity),
    );
  }

  Future<void> onRatingUpdate(double rating) async {
    this.rating = rating.toInt();
    ratingTitle = '${this.rating} star${rating == 1 ? "..." : "s!"}';
    ratingMessage = this.rating == 5
        ? 'Glad you enjoyed our service!'
        : 'Please let us know how we can improve our service!';
    switch (this.rating) {
      case 1:
        assetName = kSvg1StarRating;
        break;
      case 2:
        assetName = kSvg2StarRating;
        break;
      case 3:
        assetName = kSvg3StarRating;
        break;
      case 4:
        assetName = kSvg4StarRating;
        break;
      default:
        assetName = kSvg5StarRating;
        break;
    }

    try {
      ratingSubmitted = await locator<ProductAPI>().review(
        productId: order.productIds.first,
        request: ProductReviewRequest(
          orderId: order.id,
          rating: this.rating,
        ),
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }

    notifyListeners();
  }
}
