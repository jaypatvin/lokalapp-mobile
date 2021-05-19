import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/root/root.dart';
import 'package:lokalapp/widgets/onboarding.dart';

import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/pull_up_cart_state.dart';
import '../utils/themes.dart';
import 'cart/sliding_up_cart.dart';
import 'draft_post.dart';
import 'timeline.dart';

class Home extends StatelessWidget {
  Padding buildTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 0),
      child: Column(
        children: [
          Container(
            child: Theme(
              data: ThemeData(primaryColor: Colors.grey.shade400),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DraftPost()));
                },
                child: TextField(
                  enabled: false,
                  textAlign: TextAlign.justify,
                  decoration: InputDecoration(
                    isDense: true, // Added this
                    filled: true,
                    contentPadding: EdgeInsets.only(
                        left: 18, bottom: 11, top: 14, right: 15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      // borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                    ),
                    fillColor: Colors.white,
                    suffixIcon: Icon(
                      Icons.assignment_turned_in,
                      color: Color(0xffE0E0E0),
                    ),
                    hintText: 'What\'s on your mind?',

                    alignLabelWithHint: true,
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showAlert(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 22),
        // contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        content: Container(
          height: height * 0.3,
          width: width * 0.9,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Container(
            width: width * 0.9,
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        width: width * 0.25,
                        child: Icon(
                          Icons.home_outlined,
                          size: 80,
                          color: Color(0xffCC3752),
                        ),
                      ),
                      Text(
                        "Home",
                        style: TextStyle(color: Color(0xffCC3752)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 5, right: 15, bottom: 5),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, top: 30, right: 15, bottom: 5),
                            child: Text(
                              'The Home Tab is where you can',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 8, right: 15, bottom: 5, top: 1),
                            child: Text(
                              'find posts, photos and updates',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                              padding:
                                  EdgeInsets.only(right: 30, bottom: 5, top: 1),
                              child: Text(
                                'shared by the people in this' + " ",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 14),
                              )),
                          Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 15, bottom: 5, top: 1),
                              child: Text(
                                'community or share some of yours! ',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 14),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Center(
                                child: Container(
                                  height: 43,
                                  width: 180,
                                  child: FlatButton(
                                    color: kTealColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(color: kTealColor),
                                    ),
                                    textColor: kTealColor,
                                    child: Text(
                                      "Okay!",
                                      style: TextStyle(
                                          fontFamily: "Goldplay",
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration.zero, () => showAlert(context));
    return Scaffold(
      backgroundColor: Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
            ],
          ),
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Container(
            decoration: BoxDecoration(color: kTealColor),
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      "White Plains",
                      style: TextStyle(
                          fontFamily: "Goldplay",
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0XFFFFC700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SlidingUpCart(
        child: Column(
          children: [
            buildTextField(context),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: Timeline(),
            ),
            Consumer2<ShoppingCart, PullUpCartState>(
              builder: (context, cart, cartState, _) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height *
                      (cart.items.length > 0 && cartState.isPanelVisible
                          ? 0.32
                          : 0.2),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
