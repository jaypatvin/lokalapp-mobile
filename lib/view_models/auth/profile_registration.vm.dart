import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/app_navigator.dart';
import '../../providers/auth.dart';
import '../../providers/bank_codes.dart';
import '../../providers/categories.dart';
import '../../providers/post_requests/auth_body.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/users.dart';
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
    final _imageService = context.read<LocalImageService>();
    String mediaUrl = '';
    if (profilePhoto != null) {
      mediaUrl = await _imageService.uploadImage(
        file: profilePhoto!,
        src: kUserImagesSrc,
      );
    }

    final auth = context.read<Auth>();
    final AuthBody authBody = context.read<AuthBody>();
    final String inviteCode = authBody.inviteCode!;
    final _apiService = InviteAPIService(context.read<API>());
    authBody.update(
      profilePhoto: mediaUrl,
      firstName: _firstName,
      lastName: _lastName,
      address: _streetName,
      userUid: auth.authUid,
      email: auth.authEmail,
    );

    await auth.register(authBody.data);
    bool inviteCodeClaimed = false;
    if (auth.user != null) {
      try {
        inviteCodeClaimed = await _apiService.claim(
          userId: auth.user!.id!,
          code: inviteCode,
        );
      } catch (e) {
        showToast(e.toString());
      }
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
      await context.read<Shops>().fetch();
      await context.read<Products>().fetch();
      await context.read<Users>().fetch();
      await context.read<Categories>().fetch();
      await context.read<BankCodes>().fetch();
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
    } on FirebaseAuthException catch (e) {
      showToast(e.toString());
      return false;
    } catch (e) {
      showToast(e.toString());
      return false;
    }
  }
}
