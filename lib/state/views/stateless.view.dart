import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model.dart';

/// A view widget implementing [Stateless] widget and [ViewModel].
abstract class StatelessView<T extends ViewModel> extends StatelessWidget {
  const StatelessView({Key? key, this.reactive = true}) : super(key: key);

  /// Whether this view will listen to changes in the [ViewModel].
  final bool reactive;

  @override
  Widget build(BuildContext context) =>
      render(context, Provider.of<T>(context, listen: reactive));

  Widget render(BuildContext context, T viewModel);
}
