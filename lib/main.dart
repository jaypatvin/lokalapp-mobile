import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/root/root.dart';
import 'package:lokalapp/screens/community.dart';
import 'package:lokalapp/screens/profile_registration.dart';
import 'package:lokalapp/states/currentUser.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentUser(),
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
