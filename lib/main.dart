import 'package:flutter/material.dart';
import 'package:kuku_app/provider/theme_mode_provider.dart';
import 'package:kuku_app/router/router.dart';
import 'package:kuku_app/theme/app_theme_and_styles.dart';
import 'package:provider/provider.dart';

void main() {
// MultiProvider(providers: [], child: ,)

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DarkLightModeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final modeChanger =
        Provider.of<DarkLightModeProvider>(context).gettingThemeChanger;
    return MaterialApp(
      theme: theAppTheme(
        context: context,
        modeChanger: modeChanger,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/splash-screen",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
