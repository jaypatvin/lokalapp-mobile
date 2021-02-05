import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/themes.dart';
import '../widgets/rounded_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as Im;
import '../services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../states/current_user.dart';

import '../screens/bottom_navigation.dart';

class ProfileRegistration extends StatefulWidget {
  @override
  _ProfileRegistrationState createState() => _ProfileRegistrationState();
}

class _ProfileRegistrationState extends State<ProfileRegistration> {
  File file;
  bool isUploading = false;
  String profilePhotoId = Uuid().v4();
  final picker = ImagePicker();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _streetAddressController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  RoundedButton roundedButton = RoundedButton();

  //  CurrentUser _users = Provider.of<CurrentUser>(context, listen: false);

  handleCamera() async {
    Navigator.pop(context);
    final pickedImage = await picker.getImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    if (pickedImage != null) {
      setState(() {
        file = File(pickedImage.path);
      });
    }
  }

  handleGallery() async {
    Navigator.pop(context);
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        file = File(pickedImage.path);
      });
    }
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Upload Picture"),
            children: [
              SimpleDialogOption(
                child: Text("Camera"),
                onPressed: () {
                  handleCamera();
                },
              ),
              SimpleDialogOption(
                child: Text("Gallery"),
                onPressed: () {
                  handleGallery();
                },
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$profilePhotoId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 90));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask = storageRef
        .child("profilePhotoId_$profilePhotoId.jpg")
        .putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future registerUser() async {
    setState(() {
      isUploading = true;
    });
    String mediaUrl = "";
    if (file != null) {
      await compressImage();
      mediaUrl = await uploadImage(file);
    }

    CurrentUser _user = Provider.of<CurrentUser>(context, listen: false);
    _user.updatePostBody(
        profilePhoto: mediaUrl,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        address: _streetAddressController.text);

    bool isUserCreated = false;
    bool validInviteCode = await _user.claimInviteCode();
    if (validInviteCode) {
      isUserCreated = await _user.createUser();
    }

    if (isUserCreated) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigation()),
          (route) => false);
    }
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
        //handleSubmit();
        await registerUser();
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => WelcomeScreen()),
        //     (route) => false);
      },
      //onPressed: () => registerUser(),
      label: "CREATE PROFILE",
      fontSize: 20.0,
      minWidth: 250,
      fontFamily: "GoladplayBold",
      fontWeight: FontWeight.bold,
    );
  }

  Widget photoBox() {
    return GestureDetector(
      onTap: () {
        selectImage(context);
      },
      child: Container(
        width: 180.0,
        height: 170.0,
        decoration: BoxDecoration(
          // image:
          //     DecorationImage(fit: BoxFit.cover, image: FileImage(file)) ,
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: kTealColor),
        ),
        child: IconButton(
          onPressed: () {
            selectImage(context);
          },
          icon: Icon(
            Icons.add,
            color: kTealColor,
          ),
        ),
      ),
    );
  }

  Widget photoBoxWithPic() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 180.0,
        height: 170.0,
        decoration: BoxDecoration(
          image: DecorationImage(fit: BoxFit.cover, image: FileImage(file)),
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: kTealColor),
        ),
        child: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.add,
            color: kTealColor,
          ),
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
                  file == null ? photoBox() : photoBoxWithPic(),
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
