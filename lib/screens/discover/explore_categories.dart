import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../providers/categories.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../cart/cart_container.dart';

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
      body: CartContainer(
        alwaysDisplayButton: true,
        child: Consumer<Categories>(
          builder: (ctx, provider, _) {
            if (provider.isLoading || provider.categories.isEmpty) {
              return const CircularProgressIndicator();
            }
            final categories = provider.categories;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 20),
                      child: Text(
                        'Explore Categories',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Goldplay',
                          fontSize: 20.0,
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
                    SliverFillRemaining(
                      child: AlignedGridView.count(
                        crossAxisCount: 4,
                        itemCount: categories.length,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 18,
                        itemBuilder: (ctx, index) {
                          return GestureDetector(
                            onTap: () => provider.onCategoryTap(index),
                            child: Column(
                              children: [
                                // TODO: separate widget
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0XFFF1FAFF),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: CachedNetworkImage(
                                      imageUrl: categories[index].iconUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) => Shimmer(
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (ctx, url, err) {
                                        if (categories[index].iconUrl.isEmpty) {
                                          return const Center(
                                            child: Text(
                                              'No image.',
                                              style: TextStyle(fontSize: 8),
                                            ),
                                          );
                                        }
                                        return const Center(
                                          child: Text(
                                            'Error displaying image.',
                                            style: TextStyle(fontSize: 8),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  categories[index].name,
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      ?.copyWith(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  // SliverGrid(
                  //   delegate: SliverChildBuilderDelegate(
                  //     (ctx2, index) {
                  //       return GestureDetector(
                  //         onTap: () => provider.onCategoryTap(index),
                  //         child: Column(
                  //           children: [
                  //             // TODO: separate widget
                  //             Container(
                  //               height: 70,
                  //               width: 70,
                  //               decoration: const BoxDecoration(
                  //                 shape: BoxShape.circle,
                  //                 color: Color(0XFFF1FAFF),
                  //               ),
                  //               child: ClipRRect(
                  //                 borderRadius: BorderRadius.circular(30.0),
                  //                 child: CachedNetworkImage(
                  //                   imageUrl: categories[index].iconUrl,
                  //                   fit: BoxFit.cover,
                  //                   placeholder: (_, __) => Shimmer(
                  //                     child: DecoratedBox(
                  //                       decoration: BoxDecoration(
                  //                         color: Colors.grey.shade300,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   errorWidget: (ctx, url, err) {
                  //                     if (categories[index].iconUrl.isEmpty) {
                  //                       return const Center(
                  //                         child: Text(
                  //                           'No image.',
                  //                           style: TextStyle(fontSize: 8),
                  //                         ),
                  //                       );
                  //                     }
                  //                     return const Center(
                  //                       child: Text(
                  //                         'Error displaying image.',
                  //                         style: TextStyle(fontSize: 8),
                  //                       ),
                  //                     );
                  //                   },
                  //                 ),
                  //               ),
                  //             ),
                  //             const SizedBox(height: 10.0),
                  //             Text(
                  //               categories[index].name,
                  //               maxLines: 2,
                  //               softWrap: true,
                  //               overflow: TextOverflow.ellipsis,
                  //               textAlign: TextAlign.center,
                  //               style: Theme.of(context)
                  //                   .textTheme
                  //                   .subtitle2
                  //                   ?.copyWith(
                  //                     fontSize: 10,
                  //                     color: Colors.black,
                  //                   ),
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     },
                  //     childCount: categories.length,
                  //   ),
                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 4,
                  //     mainAxisSpacing: 18,
                  //     crossAxisSpacing: 30,
                  //     childAspectRatio: MediaQuery.of(context).size.width /
                  //         (MediaQuery.of(context).size.height / 0.7),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
