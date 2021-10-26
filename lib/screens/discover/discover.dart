import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/categories.dart';
import '../../utils/constants/themes.dart';
import '../../utils/shared_preference.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/overlays/onboarding.dart';
import '../../widgets/inputs/search_text_field.dart';
import '../cart/cart_container.dart';
import '../profile/components/store_card.dart';
import 'search.dart';
import 'components/recommended_products.dart';
import 'explore_categories.dart';

class Discover extends StatefulWidget {
  static const routeName = "/discover";
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  Widget _buildCategories() {
    return Consumer<Categories>(
      builder: (ctx, provider, _) {
        if (provider.isLoading || provider.categories.isEmpty) {
          return CircularProgressIndicator();
        }
        final categories = provider.categories;
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
                    foregroundImage: NetworkImage(categories[index].iconUrl),
                    onForegroundImageError: (obj, stack) {},
                  ),
                  SizedBox(height: 10.0.h),
                  Text(
                    categories[index].name,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Onboarding(
      screen: MainScreen.discover,
      child: Scaffold(
        appBar: CustomAppBar(
          titleText: "Discover",
          backgroundColor: kOrangeColor,
          buildLeading: false,
        ),
        body: CartContainer(
          displayButton: true,
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.5.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: StoreCard(
                          crossAxisCount: 2,
                        ),
                      ),
                    ],
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
