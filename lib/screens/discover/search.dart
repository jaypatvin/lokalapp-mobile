import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/themes.dart';
import '../../view_models/discover/search.vm.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/inputs/search_text_field.dart';
import '../profile/components/product_card.dart';

class Search extends StatefulWidget {
  static const routeName = '/discover/search';
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (ctx) => SearchViewModel(ctx)..init(),
        builder: (_, __) {
          return Consumer<SearchViewModel>(builder: (ctx, vm, __) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: CustomAppBar(
                leadingColor: kTealColor,
                backgroundColor: Colors.white,
                title: Hero(
                  tag: "search_field",
                  child: SearchTextField(
                    controller: vm.searchController,
                    enabled: true,
                    onChanged: vm.onChanged,
                  ),
                ),
                onPressedLeading: () => Navigator.of(context).pop(),
              ),
              body: Builder(
                builder: (context) {
                  if (vm.isSearching)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  if (vm.searchResults.isEmpty)
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Recent Searches",
                            style: TextStyle(
                              fontSize: 20.0.sp,
                              fontFamily: "Goldplay",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: vm.recentSearches.length,
                          itemBuilder: (ctx, index) {
                            return ListTile(
                              title: Text(vm.recentSearches[index]),
                              trailing: IconButton(
                                onPressed: () => vm.onSearchDelete(index),
                                icon: Icon(Icons.close),
                              ),
                            );
                          },
                        ),
                      ],
                    );

                  return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: vm.searchResults.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 2 / 3,
        crossAxisCount: 2,
      ),
      itemBuilder: (ctx2, index) {
        try {
          return Container(
            margin: EdgeInsets.symmetric(
              vertical: 5.0.h,
              horizontal: 2.5.w,
            ),
            child: GestureDetector(
              onTap: () => vm.onProductTap(index),
              child: ProductCard(vm.searchResults[index].id),
            ),
          );
        } catch (e) {
          return const SizedBox();
        }
      },
    ); 
                },
              ),
            );
          });
        });
  }
}
