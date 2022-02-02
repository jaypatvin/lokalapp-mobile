import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/failure_exception.dart';
import '../../providers/auth.dart';
import '../../routers/app_router.dart';
import '../../screens/auth/profile_registration.dart';
import '../../screens/bottom_navigation.dart';
import '../../state/view_model.dart';

class RegisterScreenViewModel extends ViewModel {
  final formKey = GlobalKey<FormState>();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  @override
  void init() {}

  void _registerHandler() {
    if (context.read<Auth>().user == null) {
      AppRouter.rootNavigatorKey.currentState?.pushReplacementNamed(
        ProfileRegistration.routeName,
      );
    } else {
      AppRouter.rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
        BottomNavigation.routeName,
        (route) => false,
      );
    }
  }

  Future<void> emailSignUp({
    required String email,
    required String password,
  }) async {
    try {
      if (!(formKey.currentState?.validate() ?? false)) return;

      await context.read<Auth>().signUp(email, password);

      AppRouter.rootNavigatorKey.currentState?.pushReplacementNamed(
        ProfileRegistration.routeName,
      );
    } on FirebaseAuthException catch (e, stack) {
      if (e.code == 'email-already-in-use') {
        if (context.read<Auth>().user != null) {
          AppRouter.rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
            BottomNavigation.routeName,
            (route) => false,
          );
          return;
        }

        _errorMessage = 'The email is connected to an existing account';
        notifyListeners();
        return;
      }
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e.code);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }

  Future<void> appleSignUp() async {
    try {
      await context.read<Auth>().loginWithApple();
      _registerHandler();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }

  Future<void> facebookSignUp() async {
    try {
      await context.read<Auth>().loginWithFacebook();
      _registerHandler();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }

  Future<void> googleSignUp() async {
    try {
      await context.read<Auth>().loginWithGoogle();
      _registerHandler();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }

  String? passwordValidator(String? input) {
    String? error;

    const String numCharacterError = 'Must have at least 8 characters.';
    const String numberError = 'Must have at least one number.';
    const String specialError = 'Must have at least one special character.';

    if (input == null || input.isEmpty) {
      return '$numCharacterError\n$numberError\n$specialError';
    }

    if (input.length < 8) {
      error ??= '';
      error += '$numCharacterError\n';
    }

    if (!input.contains(RegExp('[0-9]'))) {
      error ??= '';
      error += '$numberError\n';
    }

    const pattern = r"[ `!@#$%^&*()_+\-=\[\]{};'" + r':"\\|,.<>\/?~]';
    if (!input.contains(RegExp(pattern))) {
      error ??= '';
      error += '$specialError\n';
    }

    return error?.trim();
  }

  void onFormChanged() {
    notifyListeners();
  }
}
