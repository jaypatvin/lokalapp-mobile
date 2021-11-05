import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lokalapp/services/api/api.dart';
import 'package:lokalapp/services/api/user_api_service.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../providers/post_requests/auth_body.dart';
import '../../services/local_image_service.dart';
import '../../utils/constants/themes.dart';
import '../../utils/utility.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/inputs/input_name_field.dart';
import '../../widgets/photo_box.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/profile/edit';
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  File? _profilePhoto;

  @override
  initState() {
    var user = context.read<Auth>().user!;
    Provider.of<AuthBody>(context, listen: false).update(
      firstName: user.firstName,
      lastName: user.lastName,
      profilePhoto: user.profilePhoto,
      email: user.email,
      communityId: user.communityId,
    );

    _fNameController.text = user.firstName!;
    _lNameController.text = user.lastName!;
    _streetController.text = user.address!.street!;
    super.initState();
  }

  Future<bool> _updateUser() async {
    var user = context.read<Auth>().user!;
    var authBody = Provider.of<AuthBody>(context, listen: false);
    var imageService = Provider.of<LocalImageService>(context, listen: false);
    try {
      var userPhotoUrl = authBody.profilePhoto;
      if (_profilePhoto != null) {
        try {
          userPhotoUrl = await imageService.uploadImage(
            file: _profilePhoto!,
            name: "profile-photo",
          );
        } catch (e) {
          userPhotoUrl = authBody.profilePhoto;
        }
      }

      authBody.update(
        firstName: _fNameController.text,
        lastName: _lNameController.text,
        address: _streetController.text,
        profilePhoto: userPhotoUrl,
      );

      return await UserAPIService(context.read<API>()).update(
        body: authBody.data,
        userId: user.id!,
      );
    } catch (e) {
      // do something with error
      print(e);
      return false;
    }
  }

  Widget buildPhotoSection(double height, double width) {
    var authBody = Provider.of<AuthBody>(context, listen: false);
    return GestureDetector(
      onTap: () async {
        var photo = await Provider.of<MediaUtility>(context, listen: false)
            .showMediaDialog(context);
        setState(() {
          _profilePhoto = photo;
        });
      },
      child: Container(
        height: height * 0.25,
        child: Stack(
          children: [
            Center(
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.modulate,
                ),
                child: PhotoBox(
                  file: _profilePhoto,
                  shape: BoxShape.circle,
                  url: authBody.profilePhoto,
                  displayBorder: false,
                ),
              ),
            ),
            Center(
              child: Text(
                "Edit Photo",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double padding = height * 0.05;
    return Scaffold(
      backgroundColor: Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        titleText: "Edit Profile",
        backgroundColor: kTealColor,
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Container(
        padding: EdgeInsets.all(padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildPhotoSection(height, width),
              SizedBox(
                height: height * 0.02,
              ),
              InputNameField(
                controller: _fNameController,
                hintText: "First Name",
                fillColor: Colors.white,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              InputNameField(
                controller: _lNameController,
                hintText: "Last Name",
                fillColor: Colors.white,
              ),
              SizedBox(
                height: height * 0.04,
              ),
              InputNameField(
                controller: _streetController,
                hintText: "Street",
                fillColor: Colors.white,
              ),
              SizedBox(
                height: height * 0.05,
              ),
              SizedBox(
                width: width * 0.6,
                child: AppButton(
                  "Apply Changes",
                  kTealColor,
                  true,
                  () async {
                    bool success = await _updateUser();
                    if (success) {
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to update user profile"),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
