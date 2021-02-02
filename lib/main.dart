import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/screens/addShopScreens/add_shop.dart';
import 'package:lokalapp/screens/profile.dart';
import 'root/root.dart';

import 'package:provider/provider.dart';
import 'states/current_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CurrentUser(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Root(),
      
      ),
    );
  }
}
