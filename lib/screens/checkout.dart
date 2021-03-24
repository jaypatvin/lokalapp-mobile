import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/utils/themes.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  int selectedRadioTile;

  buildRadioTileDelivery() {
    return Row(
      children: [
        Container(
          child: Expanded(
            child: RadioListTile(
              value: 2,
              groupValue: selectedRadioTile,
              title: Text(
                "Delivery",
                style: TextStyle(fontSize: 14),
              ),
              onChanged: (val) {
                setSelectedRadioTile(val);
              },
              activeColor: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  buildDeliveryOption() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            "Delivery Option",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: "Goldplay"),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text("Pick 1",
            style: TextStyle(
              fontFamily: "Goldplay",
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 43,
          width: 180,
          child: Text(
            "Order Total: ",
            style: TextStyle(
                fontFamily: "Goldplay",
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          height: 43,
          width: 180,
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
              "CHECKOUT",
              style: TextStyle(
                  fontFamily: "Goldplay",
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  buildRadioTileCustomPickUp() {
    return Row(children: [
      Container(
        child: Expanded(
          child: RadioListTile(
            value: 1,
            groupValue: selectedRadioTile,
            title: Text(
              "Customer Pick-up",
              style: TextStyle(fontSize: 14),
            ),
            onChanged: (val) {
              print("Radio Tile pressed $val");
              setSelectedRadioTile(val);
            },
            activeColor: Colors.black,
          ),
        ),
      ),
    ]);
  }

  @override
  void initState() {
    super.initState();
    selectedRadioTile = 0;
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
                    padding: const EdgeInsets.only(top: 30, left: 80),
                    child: Text(
                      "Shopping Cart",
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
        child: Column(
          children: [
            SizedBox(
              height: 30,
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
                              Row(
                                children: [
                                  Container(
                                    child: CircleAvatar(
                                      radius: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Shop name",
                                    style: TextStyle(fontSize: 13),
                                  )
                                ],
                              ),
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
                  height: 25,
                ),
                buildDeliveryOption(),
                buildRadioTileDelivery(),
                buildRadioTileCustomPickUp()
              ],
            ),
            SizedBox(
              height: 90,
            ),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: 18,
            ),
            buildButtons(),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "525.00",
                    style: TextStyle(
                        color: Color(0XFFFF7A00),
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}