import 'package:flutter/material.dart';
import 'package:lokalapp/screens/bottom_navigation.dart';
import 'package:lokalapp/widgets/condensed_operating_hours.dart';
import 'package:lokalapp/widgets/operating_hours.dart';
import 'package:lokalapp/widgets/rounded_button.dart';
import '../../utils/themes.dart';
import 'shopDescription.dart';

class AddShop extends StatefulWidget {
    final Map<String, String> account;
    static String id = '/addShop';
    AddShop({Key key, this.account,}) : super(key: key);
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop>{
  TextEditingController _shopName = TextEditingController();

  String state;

  bool _setOperatingHours = false;

PreferredSize buildAppBar(){
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
              margin: const EdgeInsets.fromLTRB(20, 95, 0, 0),
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
                        width: 98,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Add Shop",
                            style: TextStyle(
                                color: Color(0xFFFFC700),
                                fontFamily: "Goldplay",
                                fontSize: 28,
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


Row buildShopName(){
  return   Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.3  ,
                  
                  child: TextField(
                    
                    onTap: () {},
                    controller: _shopName,
                    decoration: InputDecoration(
                      fillColor: Color(0xffF2F2F2),
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 18,
                      ),
                      hintText: "Shop Name",
                      hintStyle: TextStyle(
                          fontFamily: "GoldplayBold",
                          fontSize: 16,
                          color: Color(0xFFBDBDBD),
                          fontWeight: FontWeight.w500),
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            30.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
}


  @override
  Widget build(BuildContext context) {

 
    return Scaffold(
      backgroundColor: Colors.white,
      // bottomNavigationBar: BottomNavigation(),
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Basic Information",
                  style: TextStyle(
                      fontFamily: "Goldplay",
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 180.0,
                    height: 170.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: kTealColor),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add,
                        color: kTealColor,
                        size: 50,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
          buildShopName(),
            SizedBox(
              height: 25,
            ),
        ShopDescription(),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Operating Hours",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Goldplay",
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                )
              ],
            ),
            SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 60,
                    width: 350,
                    child: OperatingHours(
                      state: "Opening Time",
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 60,
                    width: 350,
                    child: OperatingHours(
                      state: "Closing time",
                      
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 80,
                  width: 300,
                  child: ListTile(
                    title: Text(
                      "Set custom operating hours",
                      softWrap: true,
                      style: TextStyle(
                          fontFamily: "GoldplayBold",
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    leading: Checkbox(
                      activeColor: Colors.black,
                      value: _setOperatingHours,
                      onChanged: (value) {
                        setState(() {
                          _setOperatingHours = value;
                        });
                      },
                    ),
                  ),
                ),
              
              ],
            ),
              Container(child: buildDaysOfWeek()),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            RoundedButton(
              label: "SUBMIT",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: "GoldplayBold",
              onPressed: () {},
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            // Row(children: [],)
          ],
        ),
      ),
    );
  }

  Widget buildDaysOfWeek() {
    List<String> daysOfWeek = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    List<Widget> condensedOperatingHours = [];

    for (String day in daysOfWeek) {
      condensedOperatingHours.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: CondensedOperatingHours(
                day: day,
              ),
            ),
           
          ],
        ),
      );
    }

    return Column(
      children: condensedOperatingHours,
    );
  }
  
  


}
