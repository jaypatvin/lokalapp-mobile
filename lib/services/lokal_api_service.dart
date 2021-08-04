import 'lokal_api/activity_feed_service.dart';
import 'lokal_api/chat_service.dart';
import 'lokal_api/comments_service.dart';
import 'lokal_api/community_service.dart';
import 'lokal_api/invite_service.dart';
import 'lokal_api/orders_service.dart';
import 'lokal_api/products_service.dart';
import 'lokal_api/shops_service.dart';
import 'lokal_api/users_service.dart';

class LokalApiService {
  static LokalApiService _instance;

  static LokalApiService get instance {
    if (_instance == null) {
      _instance = LokalApiService();
    }
    return _instance;
  }

  ActivityFeedService get activity => ActivityFeedService.instance;
  CommentsService get comment => CommentsService.instance;
  CommunityService get community => CommunityService.instance;
  InviteService get invite => InviteService.instance;
  ProductsService get product => ProductsService.instance;
  ShopsService get shop => ShopsService.instance;
  UsersService get user => UsersService.instance;
  ChatService get chat => ChatService.instance;
  OrdersService get orders => OrdersService.instance;
}
