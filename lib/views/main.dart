import 'package:flutter/material.dart';
import 'package:mobileapp/routes/route.dart';
import 'package:mobileapp/views/main_page/main_page.dart';
import 'homepage/homepage.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/splash",
      routes: route,
    );
  }
}
