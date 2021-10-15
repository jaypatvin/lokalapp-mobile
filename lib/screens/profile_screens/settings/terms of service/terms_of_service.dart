import 'package:flutter/material.dart';
import '../components/appbar.dart';

class TermsOfService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: AppBarSettings(
            onPressed: () {
              Navigator.pop(context);
            },
            text: "Terms of Service",
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [Center(child: Text("terms"))],
        ),
      ),
    );
  }
}
