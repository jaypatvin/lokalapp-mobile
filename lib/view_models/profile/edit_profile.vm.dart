import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../app/app.locator.dart';
import '../../app/app_router.dart';
import '../../models/failure_exception.dart';
import '../../models/post_requests/user/user_update.request.dart';
import '../../providers/auth.dart';
import '../../services/api/api.dart';
import '../../services/local_image_service.dart';
import '../../state/view_model.dart';
import '../../utils/constants/assets.dart';
import '../../utils/media_utility.dart';

class EditProfileViewModel extends ViewModel {
  late String _firstName;
  String get firstName => _firstName;

  late String _lastName;
  String get lastName => _lastName;

  late String _street;
  String get street => _street;

  File? _profilePhoto;
  File? get profilePhoto => _profilePhoto;

  final UserAPI _apiService = locator<UserAPI>();

  final _appRouter = locator<AppRouter>();

  @override
  void init() {
    final user = context.read<Auth>().user!;

    _firstName = user.firstName;
    _lastName = user.lastName;
    _street = user.address.street;
  }

  Future<String?> _uploadProfilePhoto() async {
    final userPhoto = context.read<Auth>().user?.profilePhoto;
    final imageService = context.read<LocalImageService>();
    var userPhotoUrl = userPhoto;
    if (_profilePhoto == null) return userPhotoUrl;

    try {
      userPhotoUrl = await imageService.uploadImage(
        file: _profilePhoto!,
        src: kUserImagesSrc,
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast('Error changing the image');
      userPhotoUrl = userPhoto;
    }
    return userPhotoUrl;
  }

  Future<void> updateUser() async {
    final user = context.read<Auth>().user!;
    try {
      final userPhotoUrl = await _uploadProfilePhoto();
      await _apiService.update(
        request: UserUpdateRequest(
          firstName: _firstName,
          lastName: _lastName,
          street: _street,
          profilePhoto: userPhotoUrl,
          displayName: '$_firstName $_lastName',
        ),
        userId: user.id,
      );
      _appRouter.popScreen(AppRoute.profile);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }

  void onFirstNameChanged(String value) {
    _firstName = value;
    notifyListeners();
  }

  void onLastNameChanged(String value) {
    _lastName = value;
    notifyListeners();
  }

  void onStreetChanged(String value) {
    _street = value;
    notifyListeners();
  }

  Future<void> onPhotoPick() async {
    _profilePhoto = await context.read<MediaUtility>().showMediaDialog(context);
    notifyListeners();
  }
}
