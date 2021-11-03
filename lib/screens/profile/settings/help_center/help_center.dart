import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../utils/constants/assets.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/profile/settings/help_center.vm.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';

class HelpCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: kTealColor,
        titleText: 'Help Center"',
        titleStyle: TextStyle(color: Colors.white),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: ChangeNotifierProvider<HelpCenterViewModel>(
        create: (ctx) => HelpCenterViewModel(ctx)..init(),
        builder: (ctx, _) {
          return Consumer<HelpCenterViewModel>(
            builder: (ctx2, vm, _) {
              return SingleChildScrollView(
                child: vm.isLoading
                    ? Center(
                        child: Lottie.asset(
                          kAnimationLoading,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        children: [
                          Html(
                            data: vm.html,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .9,
                            child: AppButton(
                              'Send us a message',
                              kTealColor,
                              true,
                              null,
                            ),
                          ),
                        ],
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
