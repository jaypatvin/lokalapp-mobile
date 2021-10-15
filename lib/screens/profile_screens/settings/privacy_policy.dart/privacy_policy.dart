import 'package:flutter/material.dart';
import '../components/appbar.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: AppBarSettings(
            onPressed: () {
              Navigator.pop(context);
            },
            text: "Privacy Policy",
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: Text(
                    "Bacon ipsum dolor amet spare ribs short loin bacon bresaola shank. Beef ribeye t-bone rump pork chop leberkas sirloin sausage. Flank boudin ground round, andouille shankle biltong strip steak chuck. Kielbasa ham hock boudin picanha meatloaf kevin strip steak. Alcatra turkey meatloaf salami, sausage biltong tenderloin landjaeger pastrami. Pork pork loin venison chislic. Cupim bresaola pork loin tri-tip spare ribs rump, ribeye t-bone beef ribs ham"))
          ],
        ),
      ),
    );
  }
}
