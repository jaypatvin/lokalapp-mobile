import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../utils/constants/assets.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/profile/settings/terms_of_service.vm.dart';
import '../../../../widgets/custom_app_bar.dart';

class TermsOfService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: kTealColor,
        titleText: 'Terms of Service',
        titleStyle: TextStyle(color: Colors.white),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: ChangeNotifierProvider<TermsOfServiceViewModel>(
        create: (ctx) => TermsOfServiceViewModel(ctx)..init(),
        builder: (ctx, _) {
          return Consumer<TermsOfServiceViewModel>(
            builder: (ctx2, vm, _) {
              return SingleChildScrollView(
                child: vm.isLoading
                    ? Center(
                        child: Lottie.asset(
                          kAnimationLoading,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Html(
                        data: vm.html,
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
