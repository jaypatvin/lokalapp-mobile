import 'package:flutter/material.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/rounded_button.dart';

class ProfileRegistration extends StatefulWidget {
  @override
  _ProfileRegistrationState createState() => _ProfileRegistrationState();
}

class _ProfileRegistrationState extends State<ProfileRegistration> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _streetAddressController = TextEditingController();

  RoundedButton roundedButton = RoundedButton();
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
      onPressed: () {},
      label: "CREATE PROFILE",
      fontSize: 20.0,
      minWidth: 250,
      fontFamily: "GoladplayBold",
      fontWeight: FontWeight.bold,
    );
  }

  Widget photoBox() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 180.0,
        height: 170.0,
        decoration: BoxDecoration(
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
                    onPressed: () {},
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
