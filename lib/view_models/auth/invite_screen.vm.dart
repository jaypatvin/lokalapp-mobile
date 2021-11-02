import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../providers/post_requests/auth_body.dart';
import '../../screens/auth/community.dart';
import '../../screens/auth/profile_registration.dart';
import '../../services/api/api.dart';
import '../../services/api/invite_api_service.dart';

class InviteScreenViewModel extends ChangeNotifier {
  InviteScreenViewModel._(this.context, this._apiService);

  factory InviteScreenViewModel(BuildContext context) {
    final _apiService = InviteAPIService(context.read<API>());
    return InviteScreenViewModel._(context, _apiService);
  }

  final BuildContext context;
  final InviteAPIService _apiService;

  final FocusNode inviteTextNode = FocusNode();
  final TextEditingController codeController = TextEditingController();
  bool displayError = false;

  KeyboardActionsConfig buildConfig() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey.shade200,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: inviteTextNode,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(),
                child: Text(
                  "Done",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black,
                      ),
                ),
              );
            },
          ],
        ),
      ],
    );
  }

  Future<void> validateInviteCode() async {
    final auth = context.read<Auth>();

    try {
      final _lokalInvite = await _apiService.check(codeController.text);
      final communityId = _lokalInvite.communityId;
      if (communityId.isEmpty) throw 'No Community ID returned.';

      final fireUser = auth.firebaseUser;
      context.read<AuthBody>()
        ..update(communityId: communityId)
        ..setInviteCode(codeController.text);
      if (displayError) {
        displayError = false;
        notifyListeners();
      }
      if (fireUser != null) {
        pushNewScreen(context, screen: ProfileRegistration());
      } else {
        pushNewScreen(context, screen: Community());
      }
      
    } catch (e) {
      displayError = true;
      notifyListeners();
      this._showError(e.toString());
    }
  }

  Future<void> showInviteCodeDescription(Widget dialogOption) {
    return showDialog<void>(
      context: context,
      builder: (ctx) {
        return dialogOption;
      },
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }
}
