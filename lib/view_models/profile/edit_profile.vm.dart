import 'dart:io';

import '../../routers/app_router.dart';
import '../../services/api/api.dart';
import '../../services/api/user_api_service.dart';
import '../../utils/utility.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../providers/post_requests/auth_body.dart';
import '../../services/local_image_service.dart';
import '../../state/view_model.dart';

class EditProfileViewModel extends ViewModel {
  late String _firstName;
  String get firstName => _firstName;

  late String _lastName;
  String get lastName => _lastName;

  late String _street;
  String get street => _street;

  File? _profilePhoto;
  File? get profilePhoto => _profilePhoto;

  late UserAPIService _apiService;

  @override
  void init() {
    _apiService = UserAPIService(context.read<API>());
    final user = context.read<Auth>().user!;

    this._firstName = user.firstName!;
    this._lastName = user.lastName!;
    this._street = user.address!.street;

    context.read<AuthBody>().update(
          firstName: user.firstName,
          lastName: user.lastName,
          profilePhoto: user.profilePhoto,
          email: user.email,
          communityId: user.communityId,
          displayName: user.displayName,
          notify: false,
        );
  }

  Future<String?> _uploadProfilePhoto() async {
    final authBody = context.read<AuthBody>();
    final imageService = context.read<LocalImageService>();
    var userPhotoUrl = authBody.profilePhoto;
    if (_profilePhoto == null) return userPhotoUrl;

    try {
      userPhotoUrl = await imageService.uploadImage(
        file: _profilePhoto!,
        name: "profile-photo",
      );
    } catch (e) {
      showToast('Error changing the image');
      userPhotoUrl = authBody.profilePhoto;
    }
    return userPhotoUrl;
  }

  Future<void> updateUser() async {
    final user = context.read<Auth>().user!;
    final authBody = context.read<AuthBody>();
    try {
      final userPhotoUrl = await _uploadProfilePhoto();
      authBody.update(
        firstName: _firstName,
        lastName: _lastName,
        address: _street,
        profilePhoto: userPhotoUrl,
        displayName: '$_firstName $_lastName',
      );

      await _apiService.update(
        body: authBody.data,
        userId: user.id!,
      );
      AppRouter.profileNavigatorKey.currentState?.pop();
    } catch (e) {
      showToast(e.toString());
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
