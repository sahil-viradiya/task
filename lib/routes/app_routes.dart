import 'package:flutter/Material.dart';

import '../repository/check_internet.dart';
import '../views/home/home_screen.dart';
import '../views/splash_view/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';
  static const String homeScreen = '/home_screen';
  static const String noInternet = '/check_internate';

  static Map<String, WidgetBuilder> get routes => {
    ///PARENT
    splashScreen: SplashScreen.builder,
    homeScreen: HomePage.builder,
    noInternet: NoInternetScreen.builder,
  };
}
