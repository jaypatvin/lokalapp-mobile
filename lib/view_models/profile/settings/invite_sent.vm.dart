import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/lokal_invite.dart';
import '../../../state/view_model.dart';

class InviteSentViewModel extends ViewModel {
  InviteSentViewModel(this._invite);

  final LokalInvite _invite;

  String get inviteCode => _invite.code!;

  void copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: inviteCode));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invite code copied to clipboard.'),
      ),
    );
  }
}
