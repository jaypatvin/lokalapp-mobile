import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/activities.dart';
import '../utils/themes.dart';
import '../widgets/custom_app_bar.dart';
import 'cart/cart_container.dart';
import 'home/draft_post.dart';
import 'home/timeline.dart';

class Home extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Padding buildTextField(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.02,
      ),
      child: Container(
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
                contentPadding:
                    EdgeInsets.only(left: 18, bottom: 11, top: 14, right: 15),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  // borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(20.0),
                  ),
                ),
                fillColor: Colors.white,
                suffixIcon: Icon(
                  MdiIcons.squareEditOutline,
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
    );
  }

  @override
  void initState() {
    super.initState();
    final activities = context.read<Activities>();
    if (activities.feed.length == 0) {
      activities.fetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        titleText: "White Plains",
        backgroundColor: kTealColor,
        buildLeading: false,
      ),
      body: CartContainer(
        child: Column(
          children: [
            buildTextField(context),
            Expanded(
              child: Consumer<Activities>(
                builder: (context, activities, child) {
                  return activities.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
                          onRefresh: () => activities.fetch(),
                          child: Timeline(activities.feed),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
