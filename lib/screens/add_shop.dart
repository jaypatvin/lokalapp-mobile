import 'package:flutter/material.dart';
import 'package:lokalapp/widgets/condensed_operating_hours.dart';
import 'package:lokalapp/widgets/operating_hours.dart';
import 'package:lokalapp/widgets/rounded_button.dart';
import '../utils/themes.dart';
import '../widgets/rounded_text_field.dart';
import 'package:dropdown_date_picker/dropdown_date_picker.dart';

class AddShop extends StatefulWidget {
  @override
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  TextEditingController _shopName = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool _setOperatingHours = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
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
      ),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
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
                          fontFamily: "Goldplay",
                          fontSize: 16,
                          color: Color(0xFFBDBDBD),
                          fontWeight: FontWeight.w600),
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
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Color(0xffE0E0E0),
                  child: Card(
                    child: TextField(
                      controller: _descriptionController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 18, bottom: 11, top: 30, right: 15),
                          hintText: "Shop Description",
                          hintStyle: TextStyle(
                              color: Color(0xFFBDBDBD),
                              fontFamily: "Goldplay",
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
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
            Row(
              children: [Container()],
            ),
            SizedBox(
              height: 20,
            ),
            OperatingHours(
              state: "Opening Time",
            ),
            OperatingHours(
              state: "Closing Time",
            ),
            ListTile(
              title: Text(
                "Set custom operating hours",
              ),
              leading: Checkbox(
                activeColor: Colors.lightBlueAccent,
                value: _setOperatingHours,
                onChanged: (value) {
                  setState(() {
                    _setOperatingHours = value;
                  });
                },
              ),
            ),
            buildDaysOfWeek(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            RoundedButton(
              label: "SUBMIT",
              onPressed: () {},
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CondensedOperatingHours(
              day: day,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
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
