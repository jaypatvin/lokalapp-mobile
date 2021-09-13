import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'providers/activities.dart';
import 'providers/cart.dart';
import 'providers/invite.dart';
import 'providers/post_requests/auth_body.dart';
import 'providers/post_requests/operating_hours_body.dart';
import 'providers/post_requests/product_body.dart';
import 'providers/post_requests/shop_body.dart';
import 'providers/products.dart';
import 'providers/schedule.dart';
import 'providers/shops.dart';
import 'providers/user.dart';
import 'providers/user_auth.dart';
import 'providers/users.dart';
import 'root/root.dart';
import 'screens/chat/chat_helpers.dart';
import 'services/local_image_service.dart';
import 'utils/shared_preference.dart';
import 'utils/themes.dart';
import 'utils/utility.dart';
import 'widgets/photo_picker_gallery/provider/custom_photo_provider.dart';

UserSharedPreferences _userSharedPreferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    // TODO: clean this up -> separate file
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
          update: (_, user, activities) => activities
            ..setCommunityId(user.communityId)
            ..setIdToken(user.idToken),
        ),
        ChangeNotifierProxyProvider<CurrentUser, Shops>(
          create: (_) => Shops(),
          update: (_, user, shops) => shops
            ..setCommunityId(user.communityId)
            ..setIdToken(user.idToken),
        ),
        ChangeNotifierProxyProvider<CurrentUser, Products>(
          create: (_) => Products(),
          update: (_, user, products) => products
            ..setCommunityId(user.communityId)
            ..setIdToken(user.idToken),
        ),

        ChangeNotifierProxyProvider<CurrentUser, Users>(
          create: (_) => Users(),
          update: (_, user, users) => users
            ..setCommunityId(user.communityId)
            ..setIdToken(user.idToken),
        ),

        ChangeNotifierProvider<ShoppingCart>(create: (_) => ShoppingCart()),
        ChangeNotifierProvider<Schedule>(create: (_) => Schedule()),

        // post body requests:
        ChangeNotifierProvider<AuthBody>(create: (_) => AuthBody()),
        ChangeNotifierProvider<ProductBody>(create: (_) => ProductBody()),
        ChangeNotifierProvider<ShopBody>(create: (_) => ShopBody()),
        ChangeNotifierProvider<OperatingHoursBody>(
            create: (_) => OperatingHoursBody()),
        ChangeNotifierProvider(create: (_) => CustomPickerDataProvider(max: 5)),

        // services:
        Provider<MediaUtility>(create: (_) => MediaUtility.instance),
        Provider<LocalImageService>(create: (_) => LocalImageService.instance),
        Provider<ChatHelpers>(create: (_) => ChatHelpers()),

        // for bottom nav bar
        ListenableProvider(create: (_) => PersistentTabController()),
      ],
      child: StreamBuilder<UserSharedPreferences>(
        stream: _userSharedPreferences.stream,
        builder: (context, snapshot) {
          return ScreenUtilInit(
            builder: () {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Lokal',
                theme: ThemeData(
                  fontFamily: "Goldplay",
                  textTheme: TextTheme(
                    headline1: TextStyle(
                      fontSize: 30.0.sp,
                      color: kNavyColor,
                      fontWeight: FontWeight.bold,
                    ),
                    headline6: TextStyle(
                      fontSize: 14.0.sp,
                      fontFamily: "Goldplay",
                      fontWeight: FontWeight.bold,
                      color: kTealColor,
                    ),
                    bodyText1: TextStyle(
                      fontSize: 16.0.sp,
                      color: kNavyColor,
                      fontWeight: FontWeight.w500,
                    ),
                    bodyText2: TextStyle(
                      color: kNavyColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  scaffoldBackgroundColor: Colors.white,
                ),
                home: Root(),
              );
            },
          );
        },
      ),
    );
  }
}
