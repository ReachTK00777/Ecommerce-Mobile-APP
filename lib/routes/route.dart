import 'package:mobileapp/login_page/login_page.dart';
import 'package:mobileapp/views/homepage/homepage.dart';
import 'package:mobileapp/views/main_page/main_page.dart';
import 'package:mobileapp/views/product_detail/product_detail.dart';
import 'package:mobileapp/views/splash_page/splash_page.dart';

var route = {
  "/splash": (context) => SplashPage(),
  "/home": (context) => HomePage(),
  "/main": (context) => MainPage(),
  "/login": (context) => LoginPage(),
};
