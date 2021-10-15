import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user.dart';

class ProfileStoreName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var _user = Provider.of<CurrentUser>(context, listen: false);
    return Consumer<CurrentUser>(
      builder: (context, user, child) {
        return Container(
          padding: EdgeInsets.all(17),
          child: Text(
            user.firstName! + " " + user.lastName!,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        );
      },
    );
  }
}
