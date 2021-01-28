import 'package:flutter/material.dart';

class ProfileSearchBar extends StatefulWidget {
  @override
  _ProfileSearchBarState createState() => _ProfileSearchBarState();
}

class _ProfileSearchBarState extends State<ProfileSearchBar> {
    TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
      child: Column(
        children: [
          Container(
            height: 45,
            child: Theme(
              data: ThemeData(primaryColor: Color(0xffF2F2F2)),
              child: TextField(
                controller: _searchController,
                onTap: () {},
                decoration: InputDecoration(
                  isDense: true, // Added this
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(25.0),
                    ),
                  ),
                  fillColor: Color(0xffF2F2F2),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xffBDBDBD),
                    size: 30,
                  ),
                  hintText: 'Search',
                  labelStyle: TextStyle(fontSize: 20),
                  hintStyle: TextStyle(color: Color(0xffBDBDBD)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}