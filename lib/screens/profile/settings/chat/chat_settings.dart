import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/auth.dart';
import '../../../../services/api/api.dart';
import '../../../../services/api/user_api_service.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/profile/settings/chat/chat_settings.vm.dart';
import '../../../../widgets/custom_app_bar.dart';

class ChatSettings extends StatelessWidget {
  const ChatSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        titleText: 'Chat Settings',
        backgroundColor: kTealColor,
        leadingColor: Colors.white,
        titleStyle: TextStyle(color: Colors.white),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: ChangeNotifierProvider(
        create: (_) => ChatSettingsViewModel(
          context.read<Auth>().user!,
          UserAPIService(context.read<API>()),
        ),
        builder: (ctx, _) {
          return Consumer<ChatSettingsViewModel>(
            builder: (ctx2, viewModel, _) {
              return ListView(
                children: [
                  ListTile(
                    tileColor: Colors.white,
                    leading: Text(
                      "Show Read Receipients",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    trailing: CupertinoSwitch(
                      value: viewModel.showReadReceipts,
                      onChanged: (value) => viewModel.toggleReadReceipt(value),
                      activeColor: kTealColor,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
