import 'package:flutter/material.dart';

class MyShopCard extends StatelessWidget {
  Widget get shopStatitstics => Column(
        children: [
          Container(
            color: Colors.black,
            child: ListView(
              children: [
                ListTile(
                  leading: Text("Total Earning"),
                )
              ],
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return shopStatitstics;
  }
}
