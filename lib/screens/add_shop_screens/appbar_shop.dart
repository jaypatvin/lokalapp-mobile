import 'package:flutter/material.dart';

class AppbarShop extends StatefulWidget {
  final bool isEdit;
  final String shopName;
  AppbarShop({this.isEdit, this.shopName});
  @override
  _AppbarShopState createState() => _AppbarShopState();
}

class _AppbarShopState extends State<AppbarShop> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(double.infinity, 83),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
          ],
        ),
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Container(
          decoration: BoxDecoration(color: Color(0xff57183f)),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 70, 0, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_sharp,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    SizedBox(
                      width: 80,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.shopName,
                          textAlign: TextAlign.center,
                          // widget.isEdit ?  "Edit Shop" : "Add Shop",
                          style: TextStyle(
                              color: Color(0xFFFFC700),
                              fontFamily: "GoldplayAltBold",
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
