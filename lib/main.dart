import 'package:flutter/material.dart';
import 'package:kuku_app/router/router.dart';
import 'package:kuku_app/theme/app_theme_and_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theAppTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: "/splash-screen",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
