// import 'lokal_api/orders_service.dart';

class LokalApiService {
  static LokalApiService? _instance;

  static LokalApiService? get instance {
    return _instance ??= LokalApiService();
  }

  // OrdersService? get orders => OrdersService.instance;
}
