import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter/services.dart';
import 'package:lokalapp/screens/bottom_navigation.dart';
import 'package:lokalapp/screens/chat/chat_helpers.dart';
import 'package:lokalapp/screens/home.dart';
import 'package:lokalapp/utils/shared_preference.dart';
=======
>>>>>>> 432af54534b97048824e29c54afd54e81c5d6f37
import 'package:provider/provider.dart';

import 'providers/activities.dart';
import 'providers/cart.dart';
import 'providers/invite.dart';
import 'providers/post_requests/auth_body.dart';
import 'providers/post_requests/operating_hours_body.dart';
import 'providers/post_requests/product_body.dart';
import 'providers/post_requests/shop_body.dart';
import 'providers/products.dart';
import 'providers/pull_up_cart_state.dart';
import 'providers/schedule.dart';
import 'providers/shops.dart';
import 'providers/user.dart';
import 'providers/user_auth.dart';
import 'providers/users.dart';
import 'root/root.dart';
import 'services/local_image_service.dart';
import 'utils/shared_preference.dart';
import 'utils/utility.dart';
import 'widgets/photo_picker_gallery/provider/custom_photo_provider.dart';

UserSharedPreferences _userSharedPreferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _userSharedPreferences = UserSharedPreferences();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    _userSharedPreferences = UserSharedPreferences();
    _userSharedPreferences.init();
    super.initState();
  }

  @override
  dispose() {
    _userSharedPreferences?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //shared preference
        Provider<UserSharedPreferences>.value(value: _userSharedPreferences),
        // auth:
        ChangeNotifierProvider<UserAuth>(create: (_) => UserAuth()),
        ChangeNotifierProvider<Invite>(create: (_) => Invite()),

        // states:
        ChangeNotifierProvider<CurrentUser>(create: (_) => CurrentUser()),
        ChangeNotifierProxyProvider<CurrentUser, Activities>(
          create: (_) => Activities(),
          update: (_, user, activities) =>
              activities..setCommunityId(user.communityId),
        ),
        ChangeNotifierProxyProvider<CurrentUser, Shops>(
          create: (_) => Shops(),
          update: (_, user, shops) => shops
            ..setCommunityId(user.communityId)
            ..fetch(user.idToken),
        ),
        ChangeNotifierProxyProvider<CurrentUser, Products>(
          create: (_) => Products(),
          update: (_, user, products) => products
            ..setCommunityId(user.communityId)
            ..fetch(user.idToken),
        ),
        ChangeNotifierProxyProvider<CurrentUser, Users>(
          create: (_) => Users(),
          update: (_, user, users) =>
              users..fetch(user.communityId, user.idToken),
        ),
        ChangeNotifierProvider<ShoppingCart>(create: (_) => ShoppingCart()),
        ChangeNotifierProvider<PullUpCartState>(
            create: (_) => PullUpCartState()),
        ChangeNotifierProvider<Schedule>(create: (_) => Schedule()),
        // post body requests:
        ChangeNotifierProvider<AuthBody>(create: (_) => AuthBody()),
        ChangeNotifierProvider<ProductBody>(create: (_) => ProductBody()),
        ChangeNotifierProvider<ShopBody>(create: (_) => ShopBody()),
        ChangeNotifierProvider<OperatingHoursBody>(
            create: (_) => OperatingHoursBody()),
<<<<<<< HEAD
//Chat
        ChangeNotifierProvider<ChatHelpers>(
          create: (_) => ChatHelpers(),
        ),
=======
        ChangeNotifierProvider(create: (_) => CustomPickerDataProvider(max: 5)),

>>>>>>> 432af54534b97048824e29c54afd54e81c5d6f37
        // services:
        Provider<MediaUtility>(create: (_) => MediaUtility.instance),
        Provider<LocalImageService>(create: (_) => LocalImageService.instance),
      ],
      child: StreamBuilder<UserSharedPreferences>(
          stream: _userSharedPreferences.stream,
          builder: (context, snapshot) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                // primarySwatch: kTealColor,
                textTheme: Theme.of(context).textTheme.apply(
                      fontFamily: 'GoldplayBold',
                    ),
              ),
              home: Root(),
            );
          }),
    );
  }
}
