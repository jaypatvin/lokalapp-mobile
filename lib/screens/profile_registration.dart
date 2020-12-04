import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/rounded_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:lokalapp/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:lokalapp/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';

class ProfileRegistration extends StatefulWidget {
  final Users currentUser;
  ProfileRegistration({this.currentUser});
  @override
  _ProfileRegistrationState createState() => _ProfileRegistrationState();
}

class _ProfileRegistrationState extends State<ProfileRegistration> {
  File file;
  bool isUploading = false;
  String profilePhotoId = Uuid().v4();
  final picker = ImagePicker();
  Position _currentPosition;
  String _currentAddress;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _streetAddressController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  RoundedButton roundedButton = RoundedButton();

  createPostinFirestore(
      {String profilePhoto,
      String firstName,
      String lastName,
      String location,
      String address}) {
    usersRef.doc(widget.currentUser.uid).set({
      "profile_photo": profilePhotoId,
      "ownerId": widget.currentUser.uid,
      "first_name": widget.currentUser.firstName,
      "last_name": widget.currentUser.lastName,
      "address": widget.currentUser.address
    });
  }

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
    ;
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

  handleSubmit() async {
    await compressImage();
    String mediaUrl = await uploadImage(file);
    createPostinFirestore(
        profilePhoto: mediaUrl,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        address: _streetAddressController.text,
        location: _locationController.text);
    _firstNameController.clear();
    _lastNameController.clear();
    _streetAddressController.clear();
    setState(() {
      file = null;
      isUploading = false;
    });
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

  Widget location() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.add_location_rounded,
            color: kNavyColor,
          ),
        ),
        Text(
          "White Plains, Quezon City",
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
      onPressed: () {
        handleSubmit();
      },
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
          // image: DecorationImage(fit: BoxFit.cover),
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

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Photo"),
        backgroundColor: Colors.teal,
        actions: [
          FlatButton(
            onPressed: handleSubmit,
            child: Text(
              "Post",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          )
        ],
      ),
      body: Container(
        width: 180.0,
        height: 170.0,
        decoration: BoxDecoration(
          image: DecorationImage(fit: BoxFit.cover, image: FileImage(file)),
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: kTealColor),
        ),
        child: IconButton(
          onPressed: () {
            // selectImage(context);
          },
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

  @override
  Widget build(BuildContext context) {
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
                  photoBox(),
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
                  location(),
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
}
