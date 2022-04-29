import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

import '../../../../providers/auth.dart';
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
      appBar: const CustomAppBar(
        titleText: 'Notification Settings',
        backgroundColor: kTealColor,
        titleStyle: TextStyle(color: Colors.white),
      ),
      body: ChangeNotifierProvider(
        create: (_) => NotificationSettingViewModel(auth: context.read<Auth>()),
        builder: (ctx, _) {
          return Consumer<NotificationSettingViewModel>(
            builder: (ctx, viewModel, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    child: Text(
                      'Receive notifications for',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
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
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          title: Text(
                            key.name.titleCase,
                            style: Theme.of(context).textTheme.bodyText2,
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
