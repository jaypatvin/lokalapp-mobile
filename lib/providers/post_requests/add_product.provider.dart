import 'dart:io';

import 'package:flutter/foundation.dart';

class AddProductProvider extends ChangeNotifier {
  AddProductProvider({
    this.name = '',
    this.description = '',
    this.shopId = '',
    this.basePrice = 0.0,
    this.quantity = 0,
    this.gallery = const <File>[],
    this.category = '',
  });

  String name;
  String description;
  String shopId;
  double basePrice;
  int quantity;
  List<File> gallery;
  String category;
}
