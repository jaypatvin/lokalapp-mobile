import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.locator.dart';
import 'app/app.router.dart';
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
import 'services/application_logger.dart';
import 'services/bottom_nav_bar_hider.dart';
import 'services/database/database.dart';
import 'services/device_info_provider.dart';
import 'services/local_image_service.dart';
import 'utils/connectivity_status.dart';
import 'utils/constants/assets.dart';
import 'utils/constants/themes.dart';
import 'utils/device_info.dart';
import 'utils/media_utility.dart';
import 'utils/shared_preference.dart';
import 'widgets/overlays/screen_loader.dart';
import 'widgets/photo_picker_gallery/provider/custom_photo_provider.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    setupLocator();
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
  late final DeviceInfoProvider _infoProvider;

  @override
  void initState() {
    super.initState();
    _prefs = UserSharedPreferences();
    _prefs.init();
    _infoProvider = DeviceInfoProvider();
  }

  @override
  void dispose() {
    _prefs.dispose();
    super.dispose();
  }

  List<SingleChildWidget> _getProviders() {
    return <SingleChildWidget>[
      //shared preference
      Provider<UserSharedPreferences>.value(value: _prefs),

      // for bottom nav bar
      ChangeNotifierProvider(create: (_) => BottomNavBarHider()),

      // auth:
      ChangeNotifierProvider<Auth>(create: (_) => Auth()),

      ChangeNotifierProxyProvider<Auth, CommunityProvider>(
        create: (_) => CommunityProvider(),
        update: (_, auth, comm) => comm!
          ..setCommunityId(
            auth.user?.communityId,
          ),
      ),

      ChangeNotifierProxyProvider<Auth, Activities?>(
        create: (_) => Activities(),
        update: (_, auth, activities) => activities!
          ..setUserCredentials(
            userId: auth.user?.id,
            communityId: auth.user?.communityId,
          ),
      ),
      ChangeNotifierProxyProvider<Auth, Users?>(
        create: (_) => Users(),
        update: (_, auth, users) =>
            users!..setCommunityId(auth.user?.communityId),
      ),

      ChangeNotifierProxyProvider<Auth, Products?>(
        create: (_) => Products(),
        update: (_, auth, products) =>
            products!..setCommunityId(auth.user?.communityId),
      ),

      ChangeNotifierProxyProvider<Auth, UserWishlist?>(
        create: (_) => UserWishlist(),
        update: (_, auth, wishlist) => wishlist!..onUserChanged(auth.user?.id),
      ),

      ChangeNotifierProxyProvider<Auth, Shops?>(
        create: (_) => Shops(),
        update: (_, auth, shops) =>
            shops!..setCommunityId(auth.user?.communityId),
      ),

      ChangeNotifierProxyProvider<Auth, NotificationsProvider?>(
        create: (_) => NotificationsProvider(),
        update: (_, auth, notifications) =>
            notifications?..setUserId(auth.user?.id),
      ),

      ChangeNotifierProvider<Categories>(create: (_) => Categories()),
      ChangeNotifierProvider<BankCodes>(create: (_) => BankCodes()),

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

      ChangeNotifierProvider<DeviceInfoProvider>.value(value: _infoProvider),

      // services:
      Provider<MediaUtility?>(create: (_) => MediaUtility()),
      Provider<LocalImageService?>(
        create: (_) => LocalImageService(database: locator<Database>()),
      ),

      ProxyProvider<Auth, ApplicationLogger>(
        create: (_) => ApplicationLogger(_infoProvider),
        update: (_, auth, logger) {
          logger?.communityId = auth.user?.communityId;
          return logger ?? ApplicationLogger(_infoProvider)
            ..communityId = auth.user?.communityId;
        },
        lazy: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _getProviders(),
      child: OKToast(
        child: DeviceInfo(
          child: ConnectivityStatus(
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
                  appBarTheme: const AppBarTheme(
                    titleTextStyle: TextStyle(
                      fontFamily: 'Goldplay',
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  textTheme: const TextTheme(
                    headline1: TextStyle(
                      fontSize: 96,
                      fontWeight: FontWeight.bold,
                      color: kNavyColor,
                    ),
                    headline2: TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      color: kNavyColor,
                    ),
                    headline3: TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold,
                      color: kNavyColor,
                    ),
                    headline4: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: kNavyColor,
                    ),
                    headline5: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: kNavyColor,
                    ),
                    headline6: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: kNavyColor,
                    ),
                    subtitle1: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: kNavyColor,
                    ),
                    subtitle2: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kNavyColor,
                    ),
                    bodyText1: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: kNavyColor,
                    ),
                    bodyText2: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: kNavyColor,
                    ),
                  ),
                  scaffoldBackgroundColor: Colors.white,
                ),
                home: const Root(),
                navigatorKey: StackedService.navigatorKey,
                initialRoute: Routes.root,
                onGenerateRoute: StackedRouter().onGenerateRoute,
                builder: (context, widget) {
                  Widget error = const Text('Error in displaying the screen');
                  if (widget is Scaffold || widget is Navigator) {
                    error = Scaffold(body: Center(child: error));
                  }
                  ErrorWidget.builder = (errorDetails) => error;

                  return widget!;

                  // The following removes the font scaling with device font size
                  // return MediaQuery(
                  //   data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  //   child: widget!,
                  // );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
