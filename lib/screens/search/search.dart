import 'package:flutter/material.dart';
import 'package:lokalapp/utils/themes.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = TextEditingController();
  buildSearch() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          height: 45,
          width: MediaQuery.of(context).size.width,
          child: Theme(
            data: ThemeData(primaryColor: Color(0xffF2F2F2)),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                isDense: true,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 5)],
            ),
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_sharp,
                              color: kTealColor,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            })),
                    SizedBox(
                      width: 120,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text("Search",
                          style: TextStyle(
                            fontFamily: "Goldplay",
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: kTealColor,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              buildSearch(),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Recent Searches",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Goldplay",
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
