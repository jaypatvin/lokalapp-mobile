import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/post_requests/auth_body.dart';
import '../../providers/user.dart';
import '../../services/local_image_service.dart';
import '../../utils/themes.dart';
import '../../utils/utility.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/input_name.dart';
import '../../widgets/photo_box.dart';
import '../../widgets/rounded_button.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  File _profilePhoto;

  @override
  initState() {
    var user = Provider.of<CurrentUser>(context, listen: false);
    Provider.of<AuthBody>(context, listen: false).update(
      firstName: user.firstName,
      lastName: user.lastName,
      profilePhoto: user.profilePhoto,
      email: user.email,
      communityId: user.communityId,
    );

    _fNameController.text = user.firstName;
    _lNameController.text = user.lastName;
    _streetController.text = user.address.street;
    super.initState();
  }


  Future updateUser() async {
    var user = Provider.of<CurrentUser>(context, listen: false);
    var authBody = Provider.of<AuthBody>(context, listen: false);
    var imageService = Provider.of<LocalImageService>(context, listen: false);
    try {
      var userPhotoUrl = authBody.profilePhoto;
      if (_profilePhoto != null) {
        try {
          userPhotoUrl = await imageService.uploadImage(
            file: _profilePhoto,
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

      return await user.update(authBody.data);
    } catch (e) {
      // do something with error
      print(e);
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
                style: kTextStyle.copyWith(
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
      appBar: customAppBar(
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
              InputName(
                controller: _fNameController,
                hintText: "First Name",
                fillColor: Colors.white,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              InputName(
                controller: _lNameController,
                hintText: "Last Name",
                fillColor: Colors.white,
              ),
              SizedBox(
                height: height * 0.04,
              ),
              InputName(
                controller: _streetController,
                hintText: "Street",
                fillColor: Colors.white,
              ),
              SizedBox(
                height: height * 0.05,
              ),
              RoundedButton(
                label: "Apply Changes",
                height: 10,
                minWidth: width * 0.6,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: "Goldplay",
                fontColor: Colors.white,
                onPressed: () async {
                  bool success = await updateUser();
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
            ],
          ),
        ),
      ),
    );
  }
}
