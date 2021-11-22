import 'lokal_api/orders_service.dart';

class LokalApiService {
  static LokalApiService? _instance;

  static LokalApiService? get instance {
    if (_instance == null) {
      _instance = LokalApiService();
    }
    return _instance;
  }

  OrdersService? get orders => OrdersService.instance;
}
