import 'package:flutter/material.dart';
import 'package:lokalapp/utils/themes.dart';

class ExploreCategories extends StatelessWidget {
  Widget getTextWidgets(context) {
    var iconText = [
      "Dessert & Pastries",
      "Meals & Snacks",
      "Drinks",
      "Fashion"
    ];
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      for (var text in iconText)
        Expanded(
            child: Container(
                padding: const EdgeInsets.only(left: 21, top: 10, right: 11),
                child: Text(
                  text,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: "Goldplay"),
                ))),
    ]);
  }

  List icon = List.generate(
    4,
    (i) => Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 3),
              child: CircleAvatar(
                  radius: 43,
                  backgroundColor: Color(0XFFF1FAFF),
                  child: Icon(
                    Icons.food_bank,
                    color: kTealColor,
                    size: 45,
                  )),
            ),
          ],
        ),
      ],
    ),
  ).toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
            ],
          ),
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Container(
            decoration: BoxDecoration(color: Color(0XFFFF7A00)),
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 30),
                        child: IconButton(
                            icon: Icon(Icons.arrow_back_outlined),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 50),
                    child: Text(
                      "Explore Categories",
                      style: TextStyle(
                          fontFamily: "Goldplay",
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0XFFFFC700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Explore Categories",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "GoldplayBold",
                        fontWeight: FontWeight.w700),
                  ))
            ],
          ),
          Row(mainAxisSize: MainAxisSize.min, children: [
            // SizedBox(
            //   height: 50,
            // ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 3),
                height: MediaQuery.of(context).size.height / 8,
                width: MediaQuery.of(context).size.width / 2,
                child: ListTile(
                  title: Container(
                    // padding:
                    // const EdgeInsets.only(right: 5.0),

                    child: Row(
                      children: icon,
                    ),
                  ),
                  subtitle: getTextWidgets(context),
                ),
              ),
            )
          ]),
          SizedBox(
            height: 80,
          ),
          Row(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 3),
                height: MediaQuery.of(context).size.height / 8,
                width: MediaQuery.of(context).size.width / 2,
                child: ListTile(
                  title: Container(
                    // padding:
                    // const EdgeInsets.only(right: 5.0),

                    child: Row(
                      children: icon,
                    ),
                  ),
                  subtitle: getTextWidgets(context),
                ),
              ),
            )
          ]),
          SizedBox(
            height: 80,
          ),
          Row(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 3),
                height: MediaQuery.of(context).size.height / 8,
                width: MediaQuery.of(context).size.width / 2,
                child: ListTile(
                  title: Container(
                    child: Row(
                      children: icon,
                    ),
                  ),
                  subtitle: getTextWidgets(context),
                ),
              ),
            )
          ]),
        ]),
      ),
    );
  }
}
