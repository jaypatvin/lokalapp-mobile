import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/categories.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/custom_app_bar.dart';

class ExploreCategories extends StatelessWidget {
  static const routeName = '/discover/categories';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: kOrangeColor,
        titleText: 'Explore Categories',
        onPressedLeading: () => Navigator.of(context).pop(),
      ),
      body: Consumer<Categories>(
        builder: (ctx, provider, _) {
          if (provider.isLoading || provider.categories.isEmpty) {
            return const CircularProgressIndicator();
          }
          final categories = provider.categories;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0.w),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0.h, bottom: 10.0.h),
                    child: Text(
                      'Explore Categories',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Goldplay',
                        fontSize: 20.0.sp,
                      ),
                    ),
                  ),
                ),
                if (provider.isLoading || provider.categories.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (!provider.isLoading && provider.categories.isNotEmpty)
                  SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (ctx2, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: SizedBox(
                            width: 100.0.w,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 35.0.r,
                                  backgroundColor: const Color(0XFFF1FAFF),
                                  foregroundImage: NetworkImage(
                                    categories[index].iconUrl,
                                  ),
                                  onForegroundImageError: (obj, stack) {},
                                ),
                                SizedBox(height: 10.0.h),
                                Text(
                                  categories[index].name,
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: categories.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.55.r,
                      crossAxisCount: 4,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
