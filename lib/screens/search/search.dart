import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/search_text_field.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leadingColor: kTealColor,
        backgroundColor: Colors.white,
        title: Hero(
          tag: "search_field",
          child: SearchTextField(
            controller: _searchController,
          ),
        ),
        onPressedLeading: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        child: Column(
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
            )
          ],
        ),
      ),
    );
  }
}
