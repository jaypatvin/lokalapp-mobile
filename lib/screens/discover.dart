import 'package:flutter/material.dart';
import 'package:lokalapp/screens/profile_screens/components/store_card.dart';
import 'package:lokalapp/screens/profile_screens/profile_search_bar.dart';

class Discover extends StatelessWidget {
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Color(0xffFFC700),
              title: CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xffFF7100),
                  child: Text(
                    "LOKAL",
                    softWrap: true,
                    style: TextStyle(
                        fontFamily: "Goldplay",
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  )),
              actions: [
                IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {})
              ],
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
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
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Recommended",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "Goldplay",
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 15),
                          height: MediaQuery.of(context).size.height / 3,
                          width: MediaQuery.of(context).size.width,
                          // color: Colors.blue,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 8,
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                              width: 200,
                              child: Card(
                                child: Center(child: Text('Dummy Card')),
                              ),
                            ),
                            // Row(
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: [
                            //     Flexible(
                            //       child: Container(
                            //         height: MediaQuery.of(context)
                            //                 .size
                            //                 .height *
                            //             0.4,
                            //         color: Colors.black,
                            //         width:
                            //             MediaQuery.of(context).size.width,
                            //         child: StoreCard(),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Explore",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "Goldplay",
                              fontSize: 16),
                        ),
                      ),
                      Row(
                        children: [
                          Text("View All"),
                          IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                              ),
                              onPressed: () {})
                        ],
                      )
                    ],
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 15),
                          height: MediaQuery.of(context).size.height / 6,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 6,
                            itemBuilder: (BuildContext context, int index) =>
                                Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      child: CircleAvatar(
                                          radius: 40,
                                          child: Icon(
                                            Icons.food_bank,
                                            size: 38,
                                          )),
                                    ),
                                  ],
                                ),
                                Text("Meals")
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Recent",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "Goldplay",
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 15),
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 8,
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                              width: 200,
                              child: Card(
                                child: Center(child: Text('Dummy Card')),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )));
  }
}
