import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants/themes.dart';
import '../widgets/app_button.dart';
import 'auth/invite_screen.dart';
import 'auth/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _current = 0;
  bool isActive = false;
  CarouselController _buttonCarouselController = CarouselController();
  final List _list = [1, 2, 3, 4];
  @override
  void initState() {
    super.initState();
    _buttonCarouselController = CarouselController();
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
              buildDots(),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget buildScreen() {
    return Column(
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100.0.h,
                child: Image.asset(
                  "assets/Lokalv2.png",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 20.0.h),
              Text(
                "Welcome to Lokal",
                style: TextStyle(
                  color: kNavyColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0.sp,
                ),
              ),
              SizedBox(height: 18.0.h),
              Text(
                "Get to know more your neighborhood safely and securely.",
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "Goldplay",
                  color: kNavyColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.0.h),
              buildDots()
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kYellowColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildScreen(),
              SizedBox(height: 36.0.h),
              SizedBox(
                width: 172.w,
                height: 40.h,
                child: AppButton(
                  "SIGN IN",
                  kTealColor,
                  true,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  ),
                  textStyle: TextStyle(
                    color: kNavyColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10.0.h),
              SizedBox(
                width: 172.w,
                height: 40.h,
                child: AppButton(
                  "REGISTER",
                  kTealColor,
                  false,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvitePage(),
                    ),
                  ),
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
