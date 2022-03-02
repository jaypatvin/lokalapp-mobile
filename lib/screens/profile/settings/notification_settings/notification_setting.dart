import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../providers/auth.dart';
import '../../../../services/api/api.dart';
import '../../../../services/api/user_api_service.dart';
import '../../../../services/database/database.dart';
import '../../../../utils/constants/assets.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/profile/settings/notification_settings/notification_setting.vm.dart';
import '../../../../widgets/custom_app_bar.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);
  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  late final NotificationSettingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = NotificationSettingViewModel(
      user: context.read<Auth>().user!,
      userAPIService: UserAPIService(context.read<API>()),
      database: context.read<Database>(),
    )..init();
  }

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
      body: ChangeNotifierProvider.value(
        value: _viewModel,
        builder: (ctx, _) {
          return Consumer<NotificationSettingViewModel>(
            builder: (ctx, viewModel, _) {
              if (viewModel.isLoading) {
                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Lottie.asset(kAnimationLoading),
                  ),
                );
              }
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
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: kTealColor,
                          ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: viewModel.notificationTypes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 5),
                      itemBuilder: (ctx2, index) {
                        final key =
                            viewModel.notificationTypes.keys.elementAt(index);
                        final notificationType =
                            viewModel.notificationTypes[key]!;
                        return ListTile(
                          tileColor: Colors.white,
                          title: Text(
                            notificationType.name,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          trailing: CupertinoSwitch(
                            value: notificationType.value,
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
