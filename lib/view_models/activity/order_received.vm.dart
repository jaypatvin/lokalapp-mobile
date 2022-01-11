import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/order.dart';
import '../../routers/app_router.dart';
import '../../screens/activity/activity.dart';
import '../../services/api/api.dart';
import '../../services/api/product_api_service.dart';
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
    AppRouter.activityNavigatorKey.currentState?.popUntil(
      ModalRoute.withName(Activity.routeName),
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

    final _api = context.read<API>();
    final _apiService = ProductApiService(_api);

    try {
      ratingSubmitted = await _apiService.rate(
        productId: order.productIds.first,
        body: {
          'value': this.rating,
          'order_id': order.id,
        },
      );
    } catch (e) {
      showToast(e.toString());
    }

    notifyListeners();
  }
}
