import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/auth.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/profile/settings/chat/chat_settings.vm.dart';
import '../../../../widgets/custom_app_bar.dart';

class ChatSettings extends StatelessWidget {
  const ChatSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        titleText: 'Chat Settings',
        backgroundColor: kTealColor,
        titleStyle: const TextStyle(color: Colors.white),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: ChangeNotifierProvider(
        create: (_) => ChatSettingsViewModel(context.read<Auth>()),
        builder: (ctx, _) {
          return Consumer<ChatSettingsViewModel>(
            builder: (ctx2, viewModel, _) {
              return Padding(
                padding: const EdgeInsets.only(top: 15),
                child: ListView(
                  children: [
                    ListTile(
                      tileColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      leading: Text(
                        'Show Read Receipts',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      trailing: CupertinoSwitch(
                        value: viewModel.showReadReceipts,
                        onChanged: (value) => viewModel.toggleReadReceipt(
                          value: value,
                        ),
                        activeColor: kTealColor,
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
