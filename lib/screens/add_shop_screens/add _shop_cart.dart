import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lokalapp/screens/add_shop_screens/shopDescription.dart';
import 'package:lokalapp/screens/profile_screens/components/store_rating.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/rounded_button.dart';

class AddShopCart extends StatefulWidget {
  @override
  _AddShopCartState createState() => _AddShopCartState();
}

class _AddShopCartState extends State<AddShopCart> {
  int selectedRadioTile;
  TextEditingController _instructionsController = TextEditingController();
  final maxLines = 10;
  int quantity = 1;
  @override
  void initState() {
    super.initState();
    // selectedRadio = 0;
    selectedRadioTile = 0;
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  void add() {
    setState(() {
      quantity++;
    });
  }

  void minus() {
    setState(() {
      if (quantity != 1) quantity--;
    });
  }

  buildAppBar() {
    return PreferredSize(
      preferredSize: Size(double.infinity, 83),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Container(
            margin: const EdgeInsets.fromLTRB(15, 60, 15, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_sharp,
                        color: kTealColor,
                        size: 28,
                      ),
                    ),
                    // SizedBox(
                    //   width: 60,r
                    // ),
                    Icon(Icons.more_horiz, color: kTealColor, size: 28)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildImage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              // width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        'https://i1.wp.com/www.eva-bakes.com/wp-content/uploads/2020/04/camo-brownie2.jpg?w=550&ssl=1'),
                    fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildItemAndPrice() {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.space,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "Camoufladge Brownies",
              style: TextStyle(
                  fontFamily: "Goldplay",
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            )),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 15),
              child: Text(
                '525.00',
                style: TextStyle(
                    color: Color(0XFFFF7A00),
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        )
      ],
    );
  }

  buildReviews() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            padding: const EdgeInsets.only(top: 20),
            child: TextButton(onPressed: () {}, child: Text("Read Reviews")))
      ],
    );
  }

  buildMessage() {
    return Row(
      children: [
        Container(
          // padding: const EdgeInsets.all(2.0),
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 1, bottom: 10),
              child: Text(
                  "Swine strip steak pork chop leberkas jowl, pork loin ball tip pork belly shank meatloaf cow venison turkey pancetta short ribs. "),
            ),
          ),
        )
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

  buildRadioTileCustomPickUp() {
    return Row(children: [
      Container(
        child: Expanded(
          child: RadioListTile(
            value: 1,
            groupValue: selectedRadioTile,
            title: Text(
              "Custom Pick-up",
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

  buildSpecialInstructions() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            "Special Instructions",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: "Goldplay",
                fontSize: 20),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text("Optional",
            style: TextStyle(
              fontFamily: "Goldplay",
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ))
      ],
    );
  }

  buildSpecialInstructionsTextField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(12),
          height: maxLines * 15.0,
          width: MediaQuery.of(context).size.width * 0.91,
          color: Color(0xffE0E0E0),
          child: TextField(
            controller: _instructionsController,
            onChanged: null,
            cursorColor: Colors.black,
            keyboardType: TextInputType.multiline,
            maxLines: maxLines,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.grey.shade500,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
                ),
                // errorBorder: InputBorder.none,
                // disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 18, bottom: 11, top: 30, right: 15),
                hintText: "e.g no bell peppers, please.",
                hintStyle: TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 14,
                  fontFamily: "GoldplayBold",
                  // fontWeight: FontWeight.w500,
                )),
          ),
        ),
      ],
    );
  }

  buildDivider() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Divider(
        thickness: 1,
        height: 2,
        color: Colors.grey.shade300,
      ),
    );
  }

  buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 43,
          width: 180,
          child: FlatButton(
            // height: 50,
            // minWidth: 100,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(color: kTealColor),
            ),
            textColor: kTealColor,
            child: Text(
              "MESSAGE SELLER",
              style: TextStyle(
                  fontFamily: "Goldplay",
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            onPressed: () {},
          ),
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
              "ADD TO CART",
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

  buildQuantity() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text(
            "Quantity",
            style: TextStyle(
                fontFamily: "Goldplay",
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          '$quantity',
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 20, color: kTealColor),
        )
      ],
    );
  }

  buildQuantityButtons() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FloatingActionButton(
          onPressed: minus,
          child: new Icon(
            Icons.remove,
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
        ),
        SizedBox(
          width: 15,
        ),
        FloatingActionButton(
          onPressed: add,
          child: new Icon(Icons.add, color: Colors.black),
          backgroundColor: Colors.white,
        ),
      ],
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildImage(),
          SizedBox(
            height: 10,
          ),
          buildItemAndPrice(),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [StoreRating(), buildReviews()],
          ),
          SizedBox(
            height: 10,
          ),
          buildMessage(),
          buildDivider(),
          SizedBox(
            height: 10,
          ),

          buildSpecialInstructions(),
          // SizedBox(
          //   height: 20,
          // ),
          buildSpecialInstructionsTextField(),

          SizedBox(
            height: 20,
          ),

          buildDivider(),
          SizedBox(
            height: 30,
          ),
          buildQuantity(),
          SizedBox(
            height: 20,
          ),
          buildQuantityButtons(),
          SizedBox(
            height: 30,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Divider(
              thickness: 1,
              height: 2,
              color: Colors.grey.shade300,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildButtons(),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(),
        body: buildBody());
  }
}
