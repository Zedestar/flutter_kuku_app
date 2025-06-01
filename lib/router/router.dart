import 'package:flutter/material.dart';
import 'package:kuku_app/pages/authentication_page.dart';
import 'package:kuku_app/pages/help_and_support_page.dart';
import 'package:kuku_app/pages/home_page.dart';
import 'package:kuku_app/pages/knowledge_post.dart';
import 'package:kuku_app/pages/profile_page.dart';
import 'package:kuku_app/pages/sample_page.dart';
import 'package:kuku_app/pages/splash_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash-screen':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/home-page':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/profile-page':
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case '/help-and-support-page':
        return MaterialPageRoute(builder: (_) => const HelpAndSupportPage());
      case '/auth-page':
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case '/sample-page':
        return MaterialPageRoute(builder: (_) => const SamplePage());
      case '/knowledge-post-page':
        return MaterialPageRoute(builder: (_) => const KnowledgePostPage());
      default:
        return _errorPage();
    }
  }

  static Route<dynamic> _errorPage() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          body: Center(
            child: Text("There is no such page"),
          ),
        );
      },
    );
  }
}
