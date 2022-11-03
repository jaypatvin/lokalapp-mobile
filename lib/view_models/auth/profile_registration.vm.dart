import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/app_navigator.dart';
import '../../models/failure_exception.dart';
import '../../models/post_requests/invite.request.dart';
import '../../providers/auth.dart';
import '../../providers/bank_codes.dart';
import '../../providers/categories.dart';
import '../../providers/post_requests/auth_body.dart';
import '../../routers/app_router.dart';
import '../../services/api/api.dart';
import '../../services/api/invite_api_service.dart';
import '../../services/local_image_service.dart';
import '../../state/view_model.dart';
import '../../utils/constants/assets.dart';
import '../../utils/media_utility.dart';
import '../../widgets/verification/verify_screen.dart';

class ProfileRegistrationViewModel extends ViewModel {
  File? _profilePhoto;
  File? get profilePhoto => _profilePhoto;

  bool _hasEmptyField = false;
  bool get hasEmptyField => _hasEmptyField;

  String _firstName = '';
  String get firstName => _firstName;

  String _lastName = '';
  String get lastName => _lastName;

  String _streetName = '';
  String get streetName => _streetName;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onFirstNameChanged(String firstName) {
    _firstName = firstName;
    notifyListeners();
  }

  void onLastNameChanged(String lastName) {
    _lastName = lastName;
    notifyListeners();
  }

  void onStreetNameChanged(String streetName) {
    _streetName = streetName;
    notifyListeners();
  }

  Future<bool> _registerUser() async {
    final imageService = context.read<LocalImageService>();
    String mediaUrl = '';
    if (profilePhoto != null) {
      mediaUrl = await imageService.uploadImage(
        file: profilePhoto!,
        src: kUserImagesSrc,
      );
    }

    final auth = context.read<Auth>();
    final AuthBody authBody = context.read<AuthBody>();
    final String inviteCode = authBody.inviteCode!;
    final apiService = InviteAPIService(context.read<API>());
    authBody.update(
      profilePhoto: mediaUrl,
      firstName: _firstName,
      lastName: _lastName,
      address: _streetName,
      email: auth.authEmail,
      displayName: '$_firstName $_lastName',
    );

    try {
      await auth.register(authBody.request);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast('Cannot create profile. Please try again');
      return false;
    }

    bool inviteCodeClaimed = false;
    try {
      if (auth.user != null) {
        inviteCodeClaimed = await apiService.claim(
          request: InviteRequest(userId: auth.user!.id, code: inviteCode),
        );
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast('Cannot claim invite code.');
      return true;
    }

    return inviteCodeClaimed;
  }

  Future<void> registerHandler() async {
    if (!formKey.currentState!.validate()) return;
    if (_firstName.isEmpty || _lastName.isEmpty || _streetName.isEmpty) {
      _hasEmptyField = true;
      notifyListeners();
      return;
    }
    final bool success = await _registerUser();
    if (success) {
      context.read<Categories>().fetch();
      context.read<BankCodes>().fetch();

      AppRouter.rootNavigatorKey.currentState?.pushAndRemoveUntil(
        AppNavigator.appPageRoute(
          builder: (context) => const VerifyScreen(),
        ),
        (route) => false,
      );
    }
  }

  Future<void> picturePickerHandler() async {
    _profilePhoto = await context.read<MediaUtility>().showMediaDialog(context);
    notifyListeners();
  }

  Future<bool> onWillPop() async {
    try {
      await context.read<Auth>().deleteAccount();
      return true;
    } on FirebaseAuthException catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e.toString());
      return false;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
      return false;
    }
  }
}
