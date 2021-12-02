import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../providers/bank_codes.dart';
import '../../providers/categories.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/users.dart';
import '../../routers/app_router.dart';
import '../../screens/auth/invite_screen.dart';
import '../../screens/bottom_navigation.dart';
import '../../state/view_model.dart';

class LoginScreenViewModel extends ViewModel {
  LoginScreenViewModel();

  final formKey = GlobalKey<FormState>();

  bool _displayError = false;
  bool get displayError => _displayError;

  Future<void> _loginHandler() async {
    if (context.read<Auth>().user != null) {
      context.read<Shops>().fetch();
      context.read<Products>().fetch();
      context.read<Categories>().fetch();
      context.read<BankCodes>().fetch();
      await context.read<Users>().fetch();

      AppRouter.rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
        BottomNavigation.routeName,
        (route) => false,
      );
    } else {
      AppRouter.rootNavigatorKey.currentState
          ?.pushReplacementNamed(InvitePage.routeName);
    }
  }

  void onFormChanged() {
    notifyListeners();
  }

  Future<void> emailLogin({
    required String email,
    required String password,
  }) async {
    try {
      _displayError = false;
      notifyListeners();

      if (!(formKey.currentState?.validate() ?? false)) return;

      await context.read<Auth>().loginWithEmail(email, password);
      await _loginHandler();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
        case 'wrong-password':
          this._displayError = true;
          notifyListeners();
          break;
        case 'user-not-found':
          break;
        default:
          throw e.message ?? 'Error Logging In';
      }
    } catch (e) {
      showToast(e.toString());
    }
  }

  Future<void> facebookLogin() async {
    try {
      await context.read<Auth>().loginWithFacebook();
      await _loginHandler();
    } catch (e) {
      showToast(e.toString());
    }
  }

  Future<void> googleLogin() async {
    try {
      await context.read<Auth>().loginWithGoogle();
      await _loginHandler();
    } catch (e) {
      showToast(e.toString());
    }
  }

  Future<void> appleLogin() async {
    try {
      await context.read<Auth>().loginWithApple();
      await _loginHandler();
    } catch (e) {
      showToast(e.toString());
    }
  }
}
