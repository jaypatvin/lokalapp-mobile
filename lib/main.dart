import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:oktoast/oktoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'providers/activities.dart';
import 'providers/auth.dart';
import 'providers/bank_codes.dart';
import 'providers/cart.dart';
import 'providers/categories.dart';
import 'providers/community.dart';
import 'providers/notifications.dart';
import 'providers/post_requests/auth_body.dart';
import 'providers/post_requests/operating_hours_body.dart';
import 'providers/post_requests/product_body.dart';
import 'providers/post_requests/shop_body.dart';
import 'providers/products.dart';
import 'providers/shops.dart';
import 'providers/users.dart';
import 'providers/wishlist.dart';
import 'root/root.dart';
import 'routers/app_router.dart';
import 'services/api/api.dart';
import 'services/bottom_nav_bar_hider.dart';
import 'services/database/database.dart';
import 'services/local_image_service.dart';
import 'utils/connectivity_status.dart';
import 'utils/constants/assets.dart';
import 'utils/constants/themes.dart';
import 'utils/media_utility.dart';
import 'utils/shared_preference.dart';
import 'widgets/overlays/screen_loader.dart';
import 'widgets/photo_picker_gallery/provider/custom_photo_provider.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(MyApp());
  }, (error, stackTrace) {
    if (error is SocketException) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
      );
      showToast(error.message);
      return;
    }
    // all uncaught errors are fatal!
    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      fatal: true,
    );
    if (kReleaseMode) exit(1);
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final UserSharedPreferences _prefs;
  late final AppRouter _router;
  late final PersistentTabController _tabController;
  late final API _api;
  late final PageController _profilePageController;
  late final Database _db;

  @override
  void initState() {
    super.initState();

    _prefs = UserSharedPreferences();
    _prefs.init();
    _tabController = PersistentTabController();
    _api = API();
    _db = Database();
    _profilePageController = PageController();
    _router = AppRouter(_tabController);
  }

  @override
  void dispose() {
    _prefs.dispose();
    _profilePageController.dispose();

    super.dispose();
  }

  List<SingleChildWidget> _getProviders() {
    return <SingleChildWidget>[
      //shared preference
      Provider<UserSharedPreferences>.value(value: _prefs),

      // router:
      Provider<AppRouter>.value(value: _router),

      // for bottom nav bar
      ListenableProvider.value(value: _tabController),
      ChangeNotifierProvider(create: (_) => BottomNavBarHider()),

      // auth:
      ChangeNotifierProvider<Auth>(create: (_) => Auth(_api, _db)),
      ChangeNotifierProvider<API>.value(value: _api),

      // database:
      Provider<Database>.value(value: _db),

      ChangeNotifierProxyProvider<Auth, CommunityProvider>(
        create: (_) => CommunityProvider(_api),
        update: (_, auth, comm) => comm!
          ..setCommunityId(
            auth.user?.communityId,
          ),
      ),

      ChangeNotifierProxyProvider<Auth, Activities?>(
        create: (_) => Activities(_api, _db),
        update: (_, auth, activities) => activities!
          ..setUserCredentials(
            userId: auth.user?.id,
            communityId: auth.user?.communityId,
          ),
      ),
      ChangeNotifierProxyProvider<Auth, Users?>(
        create: (_) => Users(_db.users),
        update: (_, auth, users) =>
            users!..setCommunityId(auth.user?.communityId),
      ),

      ChangeNotifierProxyProvider<Auth, Products?>(
        create: (_) => Products(_api, _db),
        update: (_, auth, products) =>
            products!..setCommunityId(auth.user?.communityId),
      ),

      ChangeNotifierProxyProvider<Auth, UserWishlist?>(
        create: (_) => UserWishlist(_api),
        update: (_, auth, wishlist) => wishlist!..onUserChanged(auth.user?.id),
      ),

      ChangeNotifierProxyProvider<Auth, Shops?>(
        create: (_) => Shops(_api, _db),
        update: (_, auth, shops) =>
            shops!..setCommunityId(auth.user?.communityId),
      ),

      ChangeNotifierProxyProvider<Auth, NotificationsProvider?>(
        create: (_) => NotificationsProvider(_db),
        update: (_, auth, notifications) =>
            notifications?..setUserId(auth.user?.id),
      ),

      ChangeNotifierProvider<Categories>(create: (_) => Categories(_db)),
      ChangeNotifierProvider<BankCodes>(create: (_) => BankCodes(_db)),

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
      ListenableProvider<PageController>.value(value: _profilePageController),
      Provider<MediaUtility?>(create: (_) => MediaUtility()),
      Provider<LocalImageService?>(
        create: (_) => LocalImageService(database: _db),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _getProviders(),
      child: OKToast(
        child: MediaQuery(
          data: MediaQueryData.fromWindow(window),
          child: ScreenUtilInit(
            builder: () {
              return ConnectivityStatus(
                child: ScreenLoaderApp(
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
                      fontFamily: 'Goldplay',
                      appBarTheme: AppBarTheme(
                        titleTextStyle: TextStyle(
                          fontFamily: 'Goldplay',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0.sp,
                        ),
                      ),
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
                          fontWeight: FontWeight.w600,
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
                    home: const Root(),
                    navigatorKey: _router.keyOf(AppRoute.root),
                    initialRoute: '/',
                    onGenerateRoute:
                        _router.navigatorOf(AppRoute.root).onGenerateRoute,
                    builder: (context, widget) {
                      Widget error =
                          const Text('Error in displaying the screen');
                      if (widget is Scaffold || widget is Navigator) {
                        error = Scaffold(body: Center(child: error));
                      }
                      ErrorWidget.builder = (errorDetails) => error;

                      return widget!;
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
