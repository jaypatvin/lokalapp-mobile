import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

import '../../../models/lokal_invite.dart';
import '../../../state/view_model.dart';

class InviteSentViewModel extends ViewModel {
  InviteSentViewModel(this._invite);

  final LokalInvite _invite;

  String get inviteCode => _invite.code!;

  Future<void> copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: inviteCode));
    showToast('Invite code copied to clipboard.');
  }
}
