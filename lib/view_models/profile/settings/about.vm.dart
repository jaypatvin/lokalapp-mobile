import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/shared_preference.dart';

class AboutViewModel extends ChangeNotifier {
  AboutViewModel(this.context);
  static const sessionKey = 'lokal_about';
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
                  <h1>Change Notes</h1>
                  <p>Mock data for About. Expects an html.</p>
                  <br/>
                  <h1>Bullets:</h1>
                  <ul>
                    <li>First Item</li>
                    <li>Second Item</li>
                    <li>Third Item</li>
                  </ul>
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
