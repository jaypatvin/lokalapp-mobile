import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../services/local_image_service.dart';
import '../../states/current_user.dart';
import '../../utils/themes.dart';
import '../../widgets/rounded_button.dart';
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
  RoundedButton roundedButton = RoundedButton();

  Future<void> selectImage(parentContext) async {
    return await showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Upload Picture"),
          children: [
            SimpleDialogOption(
              child: Text("Camera"),
              onPressed: () {
                Provider.of<LocalImageService>(context, listen: false)
                    .launchCamera();
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: Text("Gallery"),
              onPressed: () {
                Provider.of<LocalImageService>(context, listen: false)
                    .launchGallery();
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  Future<bool> registerUser() async {
    setState(() {
      isUploading = true;
    });

    LocalImageService _imageService =
        Provider.of<LocalImageService>(context, listen: false);
    if (_imageService.fileExists) {
      await _imageService.uploadImage();
    }

    CurrentUser _user = Provider.of<CurrentUser>(context, listen: false);
    _user.updatePostBody(
        profilePhoto: _imageService.mediaUrl,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        address: _streetAddressController.text);

    bool isUserCreated = await _user.register();
    bool inviteCodeClaimed = false;
    if (isUserCreated) {
      inviteCodeClaimed = await _user.claimInviteCode();
    }
    return inviteCodeClaimed;
  }

  Widget buildStreetAddress() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            child: TextField(
              keyboardType: TextInputType.name,
              controller: _streetAddressController,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(40.0),
                    ),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white70,
                  hintText: "Street Address",
                  contentPadding: EdgeInsets.all(20.0)),
            )),
      ],
    );
  }

  Widget buildFirstName() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            child: TextField(
              keyboardType: TextInputType.name,
              controller: _firstNameController,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(40.0),
                    ),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white70,
                  hintText: "First Name",
                  contentPadding: EdgeInsets.all(20.0)),
            )),
      ],
    );
  }

  Widget buildLastName() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            child: TextField(
              keyboardType: TextInputType.name,
              controller: _lastNameController,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(40.0),
                    ),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white70,
                  hintText: "Last Name",
                  contentPadding: EdgeInsets.all(20.0)),
            )),
      ],
    );
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
              fontFamily: "Goldplay"),
        )
      ],
    );
  }

  Widget createProfile() {
    return RoundedButton(
      onPressed: () async {
        bool success = await registerUser();
        if (success) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => VerifyScreen()),
              (route) => false);
        }
      },
      label: "CREATE PROFILE",
      fontSize: 20.0,
      minWidth: 250,
      fontFamily: "GoladplayBold",
      fontWeight: FontWeight.bold,
    );
  }

  Widget photoBox({File file}) {
    return GestureDetector(
      onTap: () => selectImage(context),
      child: Container(
        width: 180.0,
        height: 170.0,
        decoration: BoxDecoration(
          image: file == null
              ? null
              : DecorationImage(fit: BoxFit.cover, image: FileImage(file)),
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: kTealColor),
        ),
        child: file != null
            ? null
            : Icon(
                Icons.add,
                color: kTealColor,
              ),
      ),
    );
  }

  Widget profileSetUpText() {
    return Center(
      child: Text(
        "Let's set up your profile.",
        style: TextStyle(fontFamily: "GoldplayBold", fontSize: 22.0),
      ),
    );
  }

  Scaffold buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: kInviteScreenColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                    color: kTealColor,
                  ),
                ],
              ),
              SizedBox(
                height: 28.0,
              ),
              Column(
                children: [
                  profileSetUpText(),
                  SizedBox(
                    height: 25.0,
                  ),
                  Consumer<LocalImageService>(
                    builder: (context, imageService, child) {
                      return photoBox(file: imageService.file);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Column(
                children: [
                  buildFirstName(),
                  SizedBox(
                    height: 20.0,
                  ),
                  buildLastName(),
                  SizedBox(
                    height: 60.0,
                  ),
                  buildStreetAddress(),
                  SizedBox(
                    height: 15.0,
                  ),
                  userLoc(),
                  SizedBox(
                    height: 50.0,
                  ),
                  createProfile(),
                  SizedBox(
                    height: 30.0,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildPage(context);
  }
}
