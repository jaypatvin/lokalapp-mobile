import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';

class ProfileStoreName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var _user = context.read<Auth>().user!;
    return Consumer<Auth>(
      builder: (context, auth, child) {
        final user = auth.user!;
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
