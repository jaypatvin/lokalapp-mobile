import 'package:flutter/material.dart';
import 'package:lokalapp/screens/addShop.dart';
import 'package:lokalapp/widgets/rounded_button.dart';

class ProfileNoShop extends StatefulWidget {
  final bool hasStore;
  ProfileNoShop({this.hasStore});

  @override
  _ProfileNoShopState createState() => _ProfileNoShopState();
}

class _ProfileNoShopState extends State<ProfileNoShop> {
  Column buildNoShopText() {
    return Column(
      children: [
        Padding(padding: const EdgeInsets.all(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Shop not set up yet",
                style: TextStyle(
                  fontFamily: "GoldplayBoldAlt",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff828282),
                )),
            SizedBox(
              height: 30,
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        buildAddShopButton()
      ],
    );
  }

  Row buildAddShopButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RoundedButton(
          label: "ADD SHOP",
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddShop()));
          },
          minWidth: 170,
          fontSize: 18,
          height: 50,
          fontFamily: "GoldplayBold",
          fontWeight: FontWeight.bold,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildNoShopText();
  }
}
