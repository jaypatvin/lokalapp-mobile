import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/shared_preference.dart';

class HelpCenterViewModel extends ChangeNotifier {
  HelpCenterViewModel(this.context);
  static const sessionKey = 'help_center';
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
                  <h1>Need Help?</h1>
                  <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
                  Commodo enim malesuada ut ut dui euismod enim pulvinar ac. 
                  Tincidunt dictum ullamcorper eu turpis. 
                  Odio at vitae hendrerit nunc, gravida placerat eget 
                  consectetur ultricies. Ullamcorper et in aliquam convallis 
                  in lectus gravida.</p>
                  <p>Expects an html.</p>
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
