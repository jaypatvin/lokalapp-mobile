import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

import '../../../../providers/auth.dart';
import '../../../../services/api/api.dart';
import '../../../../services/api/user_api_service.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/profile/settings/notification_settings/notification_setting.vm.dart';
import '../../../../widgets/custom_app_bar.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        titleText: 'Notification Settings',
        backgroundColor: kTealColor,
        titleStyle: const TextStyle(color: Colors.white),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: ChangeNotifierProvider(
        create: (_) => NotificationSettingViewModel(
          auth: context.read<Auth>(),
          userAPIService: UserAPIService(context.read<API>()),
        ),
        builder: (ctx, _) {
          return Consumer<NotificationSettingViewModel>(
            builder: (ctx, viewModel, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0.h,
                      horizontal: 10.0.w,
                    ),
                    child: Text(
                      'Receive notifications for',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(color: kTealColor),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: viewModel.notifications.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 5),
                      itemBuilder: (ctx2, index) {
                        final key =
                            viewModel.notifications.keys.elementAt(index);
                        return ListTile(
                          tileColor: Colors.white,
                          title: Text(
                            key.name.titleCase,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          trailing: CupertinoSwitch(
                            value: viewModel.notifications[key]!,
                            onChanged: (value) => viewModel.toggleNotifications(
                              key,
                              value: value,
                            ),
                            activeColor: kTealColor,
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
