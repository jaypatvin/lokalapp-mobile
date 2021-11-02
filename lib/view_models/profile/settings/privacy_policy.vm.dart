import 'package:flutter/material.dart';
import 'package:lokalapp/utils/shared_preference.dart';
import 'package:provider/provider.dart';

class PrivacyPolicyViewModel extends ChangeNotifier {
  PrivacyPolicyViewModel(this.context);
  static const sessionKey = 'privacy_policy';
  final BuildContext context;

  String? _html;
  String? get html => _html;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void init() {
    final _sharedPrefs = context.read<UserSharedPreferences>();
    final _tos = _sharedPrefs.getSessionCache(sessionKey);

    if (_tos != null && _tos.isNotEmpty) {
      _html = _tos;
    } else {
      fetch();
    }
  }

  Future<void> fetch() async {
    _isLoading = true;
    notifyListeners();

    try {
      this._html = await Future.delayed(
        const Duration(seconds: 2),
        () => """
                <html>
                  <h1>Privacy Policy</h1>
                  <p>Mock data for Privacy Policy. Expects an html.</p>
                  <br/>
                  <h1>Bullets:</h1>
                  <ol>
                    <li>First Item</li>
                    <li>Second Item</li>
                    <li>Third Item</li>
                  </ol>
                </html>
                """,
      );

      context.read<UserSharedPreferences>().setSessionCache(sessionKey, _html!);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      _showError(e.toString());
    }
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }
}
