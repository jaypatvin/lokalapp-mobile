import 'lokal_api/orders_service.dart';
import 'lokal_api/shops_service.dart';

class LokalApiService {
  static LokalApiService? _instance;

  static LokalApiService? get instance {
    if (_instance == null) {
      _instance = LokalApiService();
    }
    return _instance;
  }
  ShopsService? get shop => ShopsService.instance;
  OrdersService? get orders => OrdersService.instance;
}
