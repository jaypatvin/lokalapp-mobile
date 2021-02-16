import 'package:flutter/material.dart';
class AppbarShop extends StatefulWidget {
  final bool isEdit;
  AppbarShop({this.isEdit});
  @override
  _AppbarShopState createState() => _AppbarShopState();
}

class _AppbarShopState extends State<AppbarShop> {

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(double.infinity, 130),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
          ],
        ),
        width: MediaQuery.of(context).size.width,
        height: 500,
        child: Container(
          decoration: BoxDecoration(color: Color(0xff57183f)),
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 95, 0, 0),
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
                        size: 35,
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
                          widget.isEdit ?  "Edit Shop" : "Add Shop",
                          style: TextStyle(
                              color: Color(0xFFFFC700),
                              fontFamily: "Goldplay",
                              fontSize: 24,
                              fontWeight: FontWeight.w600
                              ),
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


