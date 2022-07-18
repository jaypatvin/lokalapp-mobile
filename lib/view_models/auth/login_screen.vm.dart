import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../models/failure_exception.dart';
import '../../models/post_requests/shared/application_log.dart';
import '../../providers/auth.dart';
import '../../providers/bank_codes.dart';
import '../../providers/categories.dart';
import '../../services/application_logger.dart';
import '../../state/view_model.dart';

class LoginScreenViewModel extends ViewModel {
  LoginScreenViewModel();

  final formKey = GlobalKey<FormState>();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final _appRouter = locator<AppRouter>();

  Future<void> _loginHandler() async {
    if (context.read<Auth>().user != null) {
      context.read<Categories>().fetch();
      context.read<BankCodes>().fetch();

      _appRouter.pushNamedAndRemoveUntil(
        AppRoute.root,
        Routes.dashboard,
      );
    } else {
      _appRouter.navigateTo(AppRoute.root, Routes.invitePage, replace: true);
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
      //_displayError = false;
      _errorMessage = null;
      notifyListeners();

      if (!(formKey.currentState?.validate() ?? false)) return;

      await context.read<Auth>().loginWithEmail(email, password);
      context.read<ApplicationLogger>().log(
        actionType: ActionTypes.userLogin,
        communityId: context.read<Auth>().user?.communityId,
        metaData: {'email': email},
      );

      await _loginHandler();
    } on FirebaseAuthException catch (e, stack) {
      switch (e.code) {
        case 'invalid-email':
        case 'wrong-password':
          _errorMessage = 'The email and password combination is incorrect.';
          context.read<ApplicationLogger>().log(
            actionType: ActionTypes.userLoginFailed,
            metaData: {'email': email},
          );
          notifyListeners();
          break;
        case 'user-not-found':
          _errorMessage = 'There is no exisiting user with that email.';
          notifyListeners();
          break;
        case 'user-disabled':
          _errorMessage =
              'The current account is disabled. Please contact support.';
          notifyListeners();
          break;
        default:
          FirebaseCrashlytics.instance.recordError(e, stack);
          showToast(e.message ?? 'Error Logging In');
      }
    } on SocketException catch (e) {
      showToast(e.toString());
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }

  Future<void> facebookLogin() async {
    try {
      await context.read<Auth>().loginWithFacebook();
      await _loginHandler();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }

  Future<void> googleLogin() async {
    try {
      await context.read<Auth>().loginWithGoogle();
      await _loginHandler();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }

  Future<void> appleLogin() async {
    try {
      await context.read<Auth>().loginWithApple();
      await _loginHandler();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }
}
