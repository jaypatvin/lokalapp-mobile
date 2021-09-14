import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../providers/activities.dart';
import '../../providers/invite.dart';
import '../../providers/post_requests/auth_body.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../providers/user.dart';
import '../../providers/user_auth.dart';
import '../../providers/users.dart';
import '../../services/local_image_service.dart';
import '../../utils/themes.dart';
import '../../utils/utility.dart';
import '../../widgets/app_button.dart';
import '../../widgets/checkbox_form_field.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/photo_box.dart';
import '../verification_screens/verify_screen.dart';

class ProfileRegistration extends StatefulWidget {
  @override
  _ProfileRegistrationState createState() => _ProfileRegistrationState();
}

class _ProfileRegistrationState extends State<ProfileRegistration> {
  bool isUploading = false;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _streetAddressController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  File profilePhoto;
  bool _hasEmptyField = false;

  final _formKey = GlobalKey<FormState>();

  Future<bool> registerUser() async {
    setState(() {
      isUploading = true;
    });

    LocalImageService _imageService =
        Provider.of<LocalImageService>(context, listen: false);
    String mediaUrl = "";
    if (profilePhoto != null) {
      mediaUrl = await _imageService.uploadImage(
          file: profilePhoto, name: 'profile_photo');
    }

    UserAuth auth = Provider.of<UserAuth>(context, listen: false);
    CurrentUser user = Provider.of<CurrentUser>(context, listen: false);
    AuthBody authBody = Provider.of<AuthBody>(context, listen: false);
    Invite invite = Provider.of<Invite>(context, listen: false);
    print(auth.user.uid);
    authBody.update(
      profilePhoto: mediaUrl,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      address: _streetAddressController.text,
      userUid: auth.user.uid,
      email: auth.user.email,
    );

    await user.register(authBody.data);
    bool inviteCodeClaimed = false;
    if (user.state == UserState.LoggedIn) {
      inviteCodeClaimed = await invite.claim(
        email: user.email,
        userId: user.id,
        authToken: user.idToken,
      );
    }
    return inviteCodeClaimed;
  }

  void _getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.country}, ${placemark.postalCode}, ${placemark.locality}, ${placemark.name}, ${placemark.position}, ${placemark.subLocality}';
    print(completeAddress);
    String formattedAddress =
        "${placemark.country}, ${placemark.locality}, ${placemark.postalCode}";
    _locationController.text = formattedAddress;
  }

  Widget userLoc() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _getLocation,
          icon: Icon(
            Icons.my_location,
            color: kNavyColor,
          ),
        ),
        Text(
          _locationController.text,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w800,
            fontFamily: "Goldplay",
          ),
        )
      ],
    );
  }

  void _registerHandler() async {
    if (!_formKey.currentState.validate()) return;
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _streetAddressController.text.isEmpty) {
      setState(() {
        _hasEmptyField = true;
        return;
      });
    }
    bool success = await registerUser();
    print(success);
    if (success) {
      context.read<Activities>().fetch();
      context.read<Shops>().fetch();
      context.read<Products>().fetch();
      context.read<Users>().fetch();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyScreen(),
          ),
          (route) => false);
    }
  }

  void _picturePickerHandler() async {
    final photo = await context.read<MediaUtility>().showMediaDialog(context);
    setState(() {
      profilePhoto = photo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      appBar: CustomAppBar(
        backgroundColor: kInviteScreenColor,
        leadingColor: kTealColor,
        onPressedLeading: () => Navigator.maybePop(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  "Let's set up your profile",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0.sp,
                  ),
                ),
                SizedBox(height: 25.0.h),
                GestureDetector(
                  onTap: _picturePickerHandler,
                  child: PhotoBox(
                    file: profilePhoto,
                    shape: BoxShape.circle,
                    width: 120.0.w,
                    height: 120.0.h,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0.h,
            ),
            if (_hasEmptyField)
              Text(
                "You must fill out all field to proceed.",
                style: TextStyle(
                  color: kPinkColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.0.sp,
                ),
              ),
            SizedBox(height: 10.0.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: _RegistrationForm(
                formKey: _formKey,
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                streetAddressController: _streetAddressController,
                onFormSubmit: _registerHandler,
                formFieldDecoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  border: new OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
                    borderSide: _hasEmptyField
                        ? BorderSide(color: kPinkColor)
                        : BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
                    borderSide: _hasEmptyField
                        ? BorderSide(color: kPinkColor)
                        : BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegistrationForm extends StatelessWidget {
  final Key formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController streetAddressController;
  final InputDecoration formFieldDecoration;
  final void Function() onChanged;
  final void Function() onFormSubmit;

  _RegistrationForm({
    Key key,
    this.formKey,
    this.firstNameController,
    this.lastNameController,
    this.streetAddressController,
    this.formFieldDecoration,
    this.onChanged,
    this.onFormSubmit,
  }) : super(key: key);

  final _checkBoxTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: "Goldplay",
    fontWeight: FontWeight.w600,
    fontSize: 13.0.sp,
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: onChanged,
      key: formKey,
      child: Column(
        children: [
          SizedBox(
            height: 40.0.h,
            child: TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              controller: firstNameController,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0.sp,
              ),
              decoration: formFieldDecoration.copyWith(hintText: "First Name"),
            ),
          ),
          SizedBox(height: 15.0.h),
          SizedBox(
            height: 40.0.h,
            child: TextFormField(
              autocorrect: false,
              controller: lastNameController,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0.sp,
              ),
              decoration: formFieldDecoration.copyWith(hintText: "Last Name"),
            ),
          ),
          SizedBox(height: 15.0.h),
          CheckboxFormField(
            validator: (checked) => checked
                ? null
                : "You must accept the Terms & Conditions and Privacy Policy",
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "I have read the "),
                  TextSpan(
                    text: "Terms & Conditions",
                    style: _checkBoxTextStyle.copyWith(
                      color: kTealColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: " and "),
                  TextSpan(
                    text: "Privacy Policy",
                    style: _checkBoxTextStyle.copyWith(
                      color: kTealColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                style: _checkBoxTextStyle,
              ),
            ),
          ),
          SizedBox(
            height: 30.0.h,
          ),
          SizedBox(
            height: 40.0.h,
            child: TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              controller: streetAddressController,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0.sp,
              ),
              decoration:
                  formFieldDecoration.copyWith(hintText: "Street Address"),
            ),
          ),
          SizedBox(height: 30.0.h),
          SizedBox(
            width: 200.0.w,
            child: AppButton(
              "CREATE PROFILE",
              kTealColor,
              true,
              onFormSubmit,
              textStyle: TextStyle(color: kNavyColor),
            ),
          )
        ],
      ),
    );
  }
}
