import 'package:flutter/material.dart';

import 'package:lokalapp/screens/profile_screens/components/store_card.dart';

import 'package:lokalapp/utils/themes.dart';

class OrderScreenGrid extends StatefulWidget {
  // Function callback;

  // OrderScreenGrid(this.callback);
  @override
  _OrderScreenGridState createState() => _OrderScreenGridState();
}

class _OrderScreenGridState extends State<OrderScreenGrid> {
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
            decoration: BoxDecoration(color: kTealColor),
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.s,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
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
                    padding: const EdgeInsets.only(
                      top: 30,
                    ),
                    child: Text(
                      "Bakey Bakey",
                      style: TextStyle(
                          fontFamily: "Goldplay",
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0XFFFFC700)),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 30),
                      child: IconButton(
                          icon: Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {}))
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(children: [
            SizedBox(
              height: 10,
              // width: 10,
            ),
            StoreCard(
              crossAxisCount: 2,
            ),
          ]),
        ),
        // Column(children: [
        //   Expanded(
        //     child: GestureDetector(
        //       onTap: () {},
        //       child: Container(
        //         decoration: BoxDecoration(
        //             color: Colors.yellow[100],
        //             border: Border.all(
        //               color: Colors.red,
        //               width: 5,
        //             )),
        //         child: StoreCard(
        //           crossAxisCount: 2,
        //         ),
        //       ),
        //     ),
        //   ),
        // ]),
      ),
    );
  }
}
