import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../view_model.dart';

/// A view widget implementing [Hooks] and [ViewModel].
abstract class HookView<T extends ViewModel> extends HookWidget {
  const HookView({super.key, this.reactive = true});

  /// Whether this view will listen to changes in the [ViewModel].
  final bool reactive;

  @override
  Widget build(BuildContext context) =>
      render(context, Provider.of<T>(context, listen: reactive));

  Widget render(BuildContext context, T viewModel);
}
