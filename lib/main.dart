import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'providers/activities.dart';
import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/categories.dart';
import 'providers/chat_provider.dart';
import 'providers/invite.dart';
import 'providers/post_requests/auth_body.dart';
import 'providers/post_requests/operating_hours_body.dart';
import 'providers/post_requests/product_body.dart';
import 'providers/post_requests/shop_body.dart';
import 'providers/products.dart';
import 'providers/shops.dart';
import 'providers/subscriptions.dart';
import 'providers/users.dart';
import 'root/root.dart';
import 'services/api/api.dart';
import 'services/local_image_service.dart';
import 'utils/constants/assets.dart';
import 'utils/constants/themes.dart';
import 'utils/shared_preference.dart';
import 'utils/utility.dart';
import 'widgets/photo_picker_gallery/provider/custom_photo_provider.dart';
import 'widgets/screen_loader.dart';

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
  late final UserSharedPreferences _prefs;

  @override
  initState() {
    super.initState();
    _prefs = UserSharedPreferences();
    _prefs.init();
  }

  @override
  dispose() {
    _prefs.dispose();
    super.dispose();
  }

  List<SingleChildWidget> _getProviders() {
    final _api = API();
    return <SingleChildWidget>[
      //shared preference
      Provider<UserSharedPreferences>.value(value: _prefs),

      // auth:
      ChangeNotifierProvider<Auth>(create: (_) => Auth(_api)),
      ChangeNotifierProvider<API>.value(value: _api),

      // TODO: use in specific screen (MVVM pattern)
      // this is only used in a specific screen
      ChangeNotifierProvider<Invite>(create: (_) => Invite()),

      ChangeNotifierProxyProvider<Auth, Activities?>(
        create: (_) => Activities(),
        update: (_, auth, activities) => activities!
          ..setCommunityId(auth.user?.communityId)
          ..setIdToken(auth.idToken),
      ),

      // TODO: separate BL (MVVM pattern)
      ChangeNotifierProxyProvider<Auth, Shops?>(
        create: (_) => Shops(),
        update: (_, auth, shops) => shops!
          ..setCommunityId(auth.user?.communityId)
          ..setIdToken(auth.idToken),
      ),
      ChangeNotifierProxyProvider<Auth, Products?>(
        create: (_) => Products(),
        update: (_, auth, products) => products!
          ..setCommunityId(auth.user?.communityId)
          ..setIdToken(auth.idToken),
      ),
      ChangeNotifierProxyProvider<Auth, Users?>(
        create: (_) => Users(),
        update: (_, auth, users) => users!
          ..setCommunityId(auth.user?.communityId)
          ..setIdToken(auth.idToken),
      ),
      ChangeNotifierProvider<Categories>(create: (_) => Categories(_api)),

      // This is used in 3 Separate Screens (Tabs) - Home, Discover, and Profile
      ChangeNotifierProvider<ShoppingCart?>(create: (_) => ShoppingCart()),

      // post body requests:
      // TODO: use these in specific Screens (MVVM pattern)
      ChangeNotifierProvider<AuthBody>(
        create: (_) => AuthBody(),
        lazy: true,
      ),
      ChangeNotifierProvider<ProductBody>(
        create: (_) => ProductBody(),
        lazy: true,
      ),
      ChangeNotifierProvider<ShopBody>(
        create: (_) => ShopBody(),
        lazy: true,
      ),
      ChangeNotifierProvider<OperatingHoursBody>(
        create: (_) => OperatingHoursBody(),
        lazy: true,
      ),

      ChangeNotifierProvider(
        create: (_) => CustomPickerDataProvider(max: 5),
        lazy: true,
      ),

      // services:
      Provider<MediaUtility?>(create: (_) => MediaUtility.instance),
      Provider<LocalImageService?>(create: (_) => LocalImageService.instance),
      ProxyProvider<Auth, SubscriptionProvider?>(
        create: (_) => SubscriptionProvider(),
        update: (_, auth, subscription) =>
            subscription!..setIdToken(auth.idToken),
      ),
      ProxyProvider<Auth, ChatProvider?>(
        create: (_) => ChatProvider(),
        update: (_, auth, chat) => chat!..setIdToken(auth.idToken),
      ),

      // for bottom nav bar
      ListenableProvider(create: (_) => PersistentTabController()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _getProviders(),
      child: ScreenUtilInit(
        builder: () {
          return ScreenLoaderApp(
            globalLoadingBgBlur: 0,
            globalLoader: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Lottie.asset(kAnimationLoading),
              ),
            ),
            app: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Lokal',
              theme: ThemeData(
                primarySwatch: Colors.teal,
                primaryColor: const Color(0xFF09A49A),
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.teal,
                  accentColor: const Color(0xFFFF7A00),
                ),
                fontFamily: "Goldplay",
                textTheme: TextTheme(
                  headline1: TextStyle(
                    fontSize: 96.sp,
                    color: kNavyColor,
                    fontWeight: FontWeight.bold,
                  ),
                  headline2: TextStyle(
                    fontSize: 60.0.sp,
                    color: kNavyColor,
                    fontWeight: FontWeight.bold,
                  ),
                  headline3: TextStyle(
                    fontSize: 48.0.sp,
                    color: kNavyColor,
                    fontWeight: FontWeight.bold,
                  ),
                  headline4: TextStyle(
                    fontSize: 34.0.sp,
                    color: kNavyColor,
                    fontWeight: FontWeight.bold,
                  ),
                  headline5: TextStyle(
                    fontSize: 24.0.sp,
                    color: kNavyColor,
                    fontWeight: FontWeight.bold,
                  ),
                  headline6: TextStyle(
                    fontSize: 20.0.sp,
                    color: kNavyColor,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle1: TextStyle(
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.w600,
                    color: kNavyColor,
                  ),
                  subtitle2: TextStyle(
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.w600,
                    color: kNavyColor,
                  ),
                  bodyText1: TextStyle(
                    fontSize: 16.0.sp,
                    color: kNavyColor,
                    fontWeight: FontWeight.w500,
                  ),
                  bodyText2: TextStyle(
                    fontSize: 14.0.sp,
                    color: kNavyColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                scaffoldBackgroundColor: Colors.white,
              ),
              home: Root(),
            ),
          );
        },
      ),
    );
  }
}
