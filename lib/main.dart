import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/root/root.dart';
import 'package:lokalapp/screens/bottomNavigation.dart';
import 'package:lokalapp/screens/community.dart';
import 'package:lokalapp/screens/home.dart';
import 'package:lokalapp/screens/post.dart';
import 'package:lokalapp/screens/profile_registration.dart';
import 'package:lokalapp/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:lokalapp/states/currentUser.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'models/user.dart';

void main() async {
  final client = Client(APIKEY,
      baseURL: "https://api.stream-io-api.com/api/v1.0/", logLevel: Level.INFO);
  // await client.setUser(Users(userUids: ), token)

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
