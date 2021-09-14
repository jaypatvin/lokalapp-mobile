import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/shared_preference.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/search_text_field.dart';
import '../cart/cart_container.dart';
import '../profile_screens/components/store_card.dart';
import '../search/search.dart';
import 'components/recommended_products.dart';
import 'explore_categories.dart';

class Discover extends StatefulWidget {
  static const routeName = "/discover";
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> with AfterLayoutMixin<Discover> {
  var _userSharedPreferences = UserSharedPreferences();

  Widget _buildCategories() {
    final categories = [
      "Dessert & Pastries",
      "Meals & Snacks",
      "Drinks",
      "Fashion"
    ];
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: categories.length,
      itemBuilder: (ctx, index) {
        return SizedBox(
          width: 100.0.w,
          child: Column(
            children: [
              CircleAvatar(
                radius: 35.0.r,
                backgroundColor: Color(0XFFF1FAFF),
                child: Icon(
                  Icons.food_bank,
                  color: kTealColor,
                  size: 35.0.sp,
                ),
              ),
              SizedBox(height: 10.0.h),
              Text(
                categories[index],
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0.sp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _userSharedPreferences = UserSharedPreferences();
    _userSharedPreferences.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: "Discover",
        backgroundColor: kOrangeColor,
        buildLeading: false,
      ),
      body: CartContainer(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.0.h),
              GestureDetector(
                child: Hero(
                  tag: "search_field",
                  child: SearchTextField(
                    enabled: false,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => Search(),
                      ),
                    ),
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => Search(),
                  ),
                ),
              ),
              SizedBox(height: 10.0.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: Text(
                  "Recommended",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: "Goldplay",
                    fontSize: 20.sp,
                  ),
                ),
              ),
              SizedBox(height: 5.0.h),
              RecommendedProducts(),
              SizedBox(height: 15.0.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: Row(
                  children: [
                    Text(
                      "Explore Categories",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Goldplay",
                        fontSize: 20.0.sp,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExploreCategories()));
                      },
                      child: Row(
                        children: [
                          Text(
                            "View All",
                            style: TextStyle(
                                fontFamily: "Goldplay",
                                color: kTealColor,
                                fontWeight: FontWeight.w700),
                          ),
                          Icon(
                            Icons.arrow_forward_outlined,
                            color: kTealColor,
                            size: 16.0.sp,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0.h),
              SizedBox(
                height: 125.0.h,
                child: _buildCategories(),
              ),
              SizedBox(height: 10.0.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: Text(
                  "Recent",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: "Goldplay",
                    fontSize: 20.sp,
                  ),
                ),
              ),
              SizedBox(height: 10.0.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: StoreCard(
                      crossAxisCount: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout

    _userSharedPreferences.isDiscover ? Container() : showAlert(context);
    setState(() {
      _userSharedPreferences.isDiscover = true;
    });
  }

  @override
  dispose() {
    _userSharedPreferences?.dispose();
    super.dispose();
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
                          Icons.web_asset_outlined,
                          size: 80,
                          color: Color(0xffCC3752),
                        ),
                      ),
                      Text(
                        "Discover",
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
                              'Discover is where you can find',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(right: 15, bottom: 5, top: 1),
                            child: Text(
                              'food, products, services or ' + " " + " ",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                              padding:
                                  EdgeInsets.only(right: 30, bottom: 5, top: 1),
                              child: Text(
                                'anything that is being sold',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 14),
                              )),
                          Container(
                              padding:
                                  EdgeInsets.only(right: 25, bottom: 5, top: 1),
                              child: Text(
                                ' in this community. ' + " " + " " + " " + " ",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 14),
                              )),
                          SizedBox(
                            height: 30,
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
}
