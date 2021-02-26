import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/rounded_button.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'auth/invite_page.dart';
import 'auth/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _current = 0;
  bool isActive = false;
  CarouselController _buttonCarouselController = CarouselController();
  RoundedButton roundedButton = RoundedButton();
  final List _list = [1, 2, 3, 4];
  @override
  void initState() {
    _buttonCarouselController = CarouselController();
    super.initState();
  }

  Widget slider() {
    return Stack(children: [
      CarouselSlider(
        carouselController: _buttonCarouselController,
        options: CarouselOptions(
          height: 300,
          initialPage: 0,
          viewportFraction: 1.0,
          autoPlay: false,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index, reason) {
            if (this.mounted) {
              setState(() {
                _current = index;
              });
            }
          },
        ),
        items: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(color: Color(0xFFFFC700)),
            child: buildScreen(),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(color: Color(0xFFFFC700)),
            child: buildDemoScreen(),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(color: Color(0xFFFFC700)),
            child: buildDemoScreen2(),
          ),
        ],
      ),
    ]);
  }

  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _list.map((url) {
        int index = _list.indexOf(url);
        return Container(
          width: 9.0,
          height: 10.0,
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: Colors.black),
            color: _current == index
                ? Color.fromRGBO(0, 0, 0, 0.9)
                : Color(0xFFFFC700),
          ),
        );
      }).toList(),
    );
  }

  Widget buildDemoScreen2() {
    return Column(children: [
      Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100.0,
                child: Image.network(
                  "https://thumbs.dreamstime.com/z/ocean-island-cartoon-palm-trees-sea-uninhabited-islands-sky-sand-beach-sun-panorama-view-solitude-tropical-nature-ocean-island-138916615.jpg",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 22.0,
              ),
              Text(
                "Heyyyyyy,",
                style: TextStyle(
                    color: Color(0xFF103045),
                    fontWeight: FontWeight.w900,
                    fontSize: 30.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "No man is an island.",
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 30.0),
              buildDots()
            ],
          ),
        ),
      ),
    ]);
  }

  Widget buildDemoScreen() {
    return Column(children: [
      Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/f/f8/01_Icon-Community%402x.png",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 22.0,
              ),
              Text(
                "Hi There!",
                style: TextStyle(
                    color: Color(0xFF103045),
                    fontWeight: FontWeight.w900,
                    fontSize: 28.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Let's support each other",
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 30.0),
              buildDots()
            ],
          ),
        ),
      ),
    ]);
  }

  Widget buildScreen() {
    return Column(children: [
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 110.0,
              child: Image.asset(
                "assets/Lokalv2.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 22.0,
            ),
            Text(
              "Welcome to Lokal",
              style: TextStyle(
                  color: Color(0xFF103045),
                  fontWeight: FontWeight.bold,
                  fontFamily: "GoldplayBold",
                  fontSize: 30.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "This is a subhead about the Lokal app.",
              style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "Goldplay",
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 26.0),
            buildDots()
          ],
        ),
      ),
    ]);
  }

  Widget signIn() {
    return RoundedButton(
        label: 'SIGN IN',
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        });
  }

  Widget register() {
    return ButtonTheme(
      minWidth: 190.0,
      height: 45.0,
      child: FlatButton(
        child: Text(
          "REGISTER",
          style: TextStyle(
              color: Color(0XFF09A49A),
              fontFamily: "Goldplay",
              fontWeight: FontWeight.bold,
              fontSize: 20.0),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Color(0XFF09A49A))),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => InvitePage()));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFFFC700),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 4,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      slider(),
                      SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 50),
                          alignment: Alignment.topCenter,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                signIn(),
                                SizedBox(
                                  height: 10,
                                ),
                                register()
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]),
      ),
    ));
  }
}
