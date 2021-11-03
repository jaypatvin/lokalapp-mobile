import 'lokal_api/chat_service.dart';
import 'lokal_api/comments_service.dart';
import 'lokal_api/community_service.dart';
import 'lokal_api/orders_service.dart';
import 'lokal_api/shops_service.dart';
import 'lokal_api/subscription_service.dart';

class LokalApiService {
  static LokalApiService? _instance;

  static LokalApiService? get instance {
    if (_instance == null) {
      _instance = LokalApiService();
    }
    return _instance;
  }

  CommentsService? get comment => CommentsService.instance;
  CommunityService? get community => CommunityService.instance;
  ShopsService? get shop => ShopsService.instance;
  ChatService? get chat => ChatService.instance;
  OrdersService? get orders => OrdersService.instance;
  SubscriptionService? get subscription => SubscriptionService.instance;
}
