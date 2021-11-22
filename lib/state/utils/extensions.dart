import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension ProviderExtension on BuildContext {
  T fetch<T>({bool listen = true}) => Provider.of<T>(this, listen: listen);
}
