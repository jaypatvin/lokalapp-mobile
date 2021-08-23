import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lokalapp/screens/activity/buyer/cash_on_delivery.dart';

import '../../../models/order.dart';
import '../../../utils/themes.dart';
import '../../../widgets/custom_app_bar.dart';
import 'bank_details.dart';

class PaymentOption extends StatelessWidget {
  final Order order;

  const PaymentOption({Key key, @required this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0XFFE5E5E5),
      appBar: CustomAppBar(
        titleText: "Choose a Payment Option",
        titleStyle: TextStyle(color: Colors.black),
        backgroundColor: Colors.white,
        leadingColor: kTealColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_sharp,
            color: kTealColor,
            size: 28,
          ),
          onPressed: () {
            Navigator.of(context).pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(shrinkWrap: true, children: [
          SizedBox(
            height: 30,
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: ListTile(
              tileColor: Colors.blue[100],
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: SvgPicture.asset(
                  "assets/payment/cash.svg",
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                "Cash On Delivery",
                style: TextStyle(
                    fontFamily: "Goldplay",
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: kTealColor,
                    size: 18,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CashOnDelivery(
                          order: this.order,
                        ),
                      ),
                    ).then((success) {
                      if (success) Navigator.pop(context);
                    });
                  }),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: ListTile(
              tileColor: Colors.blue[100],
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: SvgPicture.asset(
                  "assets/payment/bank.svg",
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                "Bank Transfer/Deposit",
                style: TextStyle(
                    fontFamily: "Goldplay",
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: kTealColor,
                  size: 18,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BankDetails(
                        order: this.order,
                      ),
                    ),
                  ).then((success) {
                    if (success) Navigator.pop(context);
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: ListTile(
              tileColor: Colors.blue[100],
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                //TODO: fix GCash Asset
                child: SvgPicture.asset(
                  "assets/payment/gcash.svg",
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                "Gcash",
                style: TextStyle(
                    fontFamily: "Goldplay",
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: kTealColor,
                    size: 18,
                  ),
                  onPressed: () {}),
            ),
          ),
        ]),
      ),
    );
  }
}
