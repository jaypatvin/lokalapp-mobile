import 'package:flutter/material.dart';
import 'package:lokalapp/screens/profile_screens/settings/components/appbar.dart';

class HelpCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: AppBarSettings(
            onPressed: () {
              Navigator.pop(context);
            },
            text: "Help Center",
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [Center(child: Text("help center"))],
        ),
      ),
    );
  }
}
