import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lokalapp/models/lokal_user.dart';
import 'package:lokalapp/providers/user.dart';
import 'package:lokalapp/screens/chat/chat_view.dart';
import 'package:lokalapp/utils/themes.dart';
import 'package:lokalapp/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class Chat extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  Widget get buildSearchTextField => Container(
        padding: const EdgeInsets.all(12),
        height: 70,
        child: TextField(
          enabled: false,
          controller: _searchController,
          decoration: InputDecoration(
            isDense: true, // Added this
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: const BorderRadius.all(
                const Radius.circular(25.0),
              ),
            ),
            fillColor: Color(0xffF2F2F2),
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xffBDBDBD),
              size: 20,
            ),
            hintText: 'Search Chats',
            labelStyle: TextStyle(fontSize: 20),
            hintStyle: TextStyle(color: Color(0xffBDBDBD)),
          ),
        ),
      );

  buildCircleAvatar(String imgUrl) {
    return CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: imgUrl.isNotEmpty ? Image.network(imgUrl) : null,
        ));
  }

  dynamic time = DateFormat.jm().format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<CurrentUser>(context, listen: false);
    return Scaffold(
      appBar: customAppBar(
          titleText: "",
          addIcon: false,
          backgroundColor: kYellowColor,
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 20),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Text(
                "Chats",
                style: TextStyle(
                    fontFamily: "GoldplayBold",
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          buildLeading: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            buildSearchTextField,
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChatView()));
                  },
                  child: ListTile(
                    leading: buildCircleAvatar(user.profilePhoto ?? ""),
                    title: Text(user.firstName + " " + user.lastName),
                    subtitle: Text("Lokal ph is the best"),
                    trailing: Text('$time'),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
