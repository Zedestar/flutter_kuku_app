import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kuku_app/connection/connect_url.dart';
import 'package:kuku_app/provider/checking_logged_inuser_provider.dart';
import 'package:kuku_app/provider/theme_mode_provider.dart';
import 'package:kuku_app/router/router.dart';
import 'package:kuku_app/theme/app_theme_and_styles.dart';
import 'package:kuku_app/token/token_helper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initHiveForFlutter();

  final authLink = AuthLink(
    getToken: () async {
      final token = await SecureStorageHelper.getToken();
      return token != null ? 'JWT $token' : null;
    },
  );
  final HttpLink httpLink = HttpLink(AppConfig.graphqlApiUrl);

  final link = authLink.concat(httpLink);

  final client = GraphQLClient(
    link: link,
    cache: GraphQLCache(store: HiveStore()),
  );
  runApp(
    GraphQLProvider(
      client: ValueNotifier(client),
      child: EasyLocalization(
        supportedLocales: [
          Locale('en'),
          Locale('sw'),
        ],
        path: 'assets/languages',
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context) => DarkLightModeProvider()),
            ChangeNotifierProvider(create: (context) => CheckingUserPresence()),
          ],
          child: const MyApp(),
        ),
      ),
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
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: theAppTheme(context: context, modeChanger: modeChanger),
      debugShowCheckedModeBanner: false,
      initialRoute: "/splash-screen",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
