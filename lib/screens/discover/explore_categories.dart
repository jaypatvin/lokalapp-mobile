import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';

class ExploreCategories extends StatelessWidget {
  final categories = [
    "Dessert & Pastries",
    "Meals & Snacks",
    "Drinks",
    "Fashion",
    "Dessert & Pastries",
    "Meals & Snacks",
    "Drinks",
    "Fashion",
    "Dessert & Pastries",
    "Meals & Snacks",
    "Drinks",
    "Fashion",
    "Dessert & Pastries",
    "Meals & Snacks",
    "Drinks",
    "Fashion",
    "Dessert & Pastries",
    "Meals & Snacks",
    "Drinks",
    "Fashion",
    "Dessert & Pastries",
    "Meals & Snacks",
    "Drinks",
    "Fashion",
    "Dessert & Pastries",
    "Meals & Snacks",
    "Drinks",
    "Fashion",
    "Dessert & Pastries",
    "Meals & Snacks",
    "Drinks",
    "Fashion",
    "Dessert & Pastries",
    "Meals & Snacks",
    "Drinks",
    "Fashion",
    "Dessert & Pastries",
    "Meals & Snacks",
    "Drinks",
    "Fashion",
    "Dessert & Pastries",
    "Meals & Snacks",
    "Drinks",
    "Fashion",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leadingColor: Colors.white,
        backgroundColor: kOrangeColor,
        titleText: "Explore Categories",
        onPressedLeading: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20.0.h),
              Text(
                "Explore Categories",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: "Goldplay",
                  fontSize: 20.0.sp,
                ),
              ),
              SizedBox(height: 10.0.h),
              Row(
                children: [
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.55.r,
                        crossAxisCount: 4,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {},
                          child: SizedBox(
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
}
