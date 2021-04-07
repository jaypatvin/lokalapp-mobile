import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/shops.dart';
import '../../utils/themes.dart';
import 'checkout.dart';

class OrderConfirmation extends StatelessWidget {
  buildButtons(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: 5),
        Container(
          padding: const EdgeInsets.all(2),
          height: 43,
          width: 190,
          child: FlatButton(
            // height: 50,
            // minWidth: 100,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(color: Color(0XFFCC3752)),
            ),
            textColor: Colors.black,
            child: Text(
              "CANCEL ORDER",
              style: TextStyle(
                  fontFamily: "Goldplay",
                  fontSize: 14,
                  color: Color(0XFFCC3752),
                  fontWeight: FontWeight.w600),
            ),
            onPressed: () {},
          ),
        ),
        Container(
          height: 43,
          width: 190,
          padding: const EdgeInsets.all(2),
          child: FlatButton(
            // height: 50,
            // minWidth: 100,
            color: kTealColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(color: kTealColor),
            ),
            textColor: Colors.black,
            child: Text(
              "PLACE ORDER",
              style: TextStyle(
                  fontFamily: "Goldplay",
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Checkout()));
            },
          ),
        ),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }

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
                      padding: const EdgeInsets.only(top: 30, left: 60),
                      child: Text(
                        "Checkout",
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
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 22, bottom: 10),
                  child: Text("Order Summary",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          fontFamily: "Goldplay")),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipPath(
                      child: Container(
                        // height: MediaQuery.of(context).size.height * 0.2,
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[400],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        padding: const EdgeInsets.all(20),
                        child: ListView(children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 2,
                                // width: 30,
                              ),
                              Consumer<Shops>(builder: (ctx, shops, child) {
                                return Row(
                                  children: [
                                    Container(
                                      child: CircleAvatar(
                                        radius: 12,
                                        //TODO: refactor/simplify this
                                        backgroundImage:
                                            shops.items[0].profilePhoto !=
                                                        null &&
                                                    shops.items[0].profilePhoto
                                                        .isNotEmpty
                                                ? NetworkImage(
                                                    shops.items[0].profilePhoto,
                                                  )
                                                : null,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      shops.items[0].name,
                                      style: TextStyle(fontSize: 13),
                                    )
                                  ],
                                );
                              }),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 70.00,
                                      height: 60.00,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmedia.timeout.com%2Fimages%2F103437036%2Fimage.jpg&f=1&nofb=1'),
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          padding:
                                              const EdgeInsets.only(right: 90),
                                          child: Text(
                                            "Pizza Pie",
                                            // softWrap: true,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "GoldplayBold",
                                                fontWeight: FontWeight.w700),
                                          )),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        child: Text(
                                          "Dozen",
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontFamily: "GolplayBold",
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          "December 20",
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontFamily: "GolplayBold",
                                              fontWeight: FontWeight.w300),
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "x1",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Container(
                                          // padding: const EdgeInsets.all(0.0),
                                          child: Text(
                                        "525.00",
                                        // textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300),
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 9,
                              ),
                              Divider(
                                color: Colors.grey,
                                indent: 0,
                                // endIndent: 25,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                // mainAxisAlignment:
                                // MainAxisAlignment.spaceBetween,
                                // mainAxisAlignment: MainAxisAlignment.end,
                                // crossAxisAlignment: CrossAxisAlignment.e,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  // SizedBox(
                                  //   width: 130,
                                  // ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                right: 40),
                                            child: Text(
                                              "Edit",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 70,
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(left: 70),
                                      child: Text(
                                        " Total",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Goldplay",
                                            fontWeight: FontWeight.w300),
                                      )),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "525.00",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color(0XFFFF7A00)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: 15,
                      ),
                      child: Text(
                        "Order Total: ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        "525.00",
                        style: TextStyle(
                            color: Color(0XFFFF7A00),
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 200,
                ),
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 10,
                ),
                buildButtons(context),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ]),
        ));
  }
}