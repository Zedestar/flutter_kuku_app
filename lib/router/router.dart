import 'package:flutter/material.dart';
import 'package:kuku_app/constants/constant.dart';
import 'package:kuku_app/pages/authentication_page.dart';
import 'package:kuku_app/pages/general_post_details_view.dart';
import 'package:kuku_app/pages/help_and_support_page.dart';
import 'package:kuku_app/pages/home_page.dart';
import 'package:kuku_app/pages/knowledge_post.dart';
import 'package:kuku_app/pages/onboarding_page.dart';
import 'package:kuku_app/pages/private_room_page.dart';
import 'package:kuku_app/pages/profile_page.dart';
import 'package:kuku_app/pages/registering_vet_page.dart';
import 'package:kuku_app/pages/sample_page.dart';
import 'package:kuku_app/pages/splash_page.dart';
import 'package:kuku_app/pages/the_room_page.dart';
import 'package:kuku_app/pages/vet_information.dart';
import 'package:kuku_app/widgets/app_bar.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash-screen':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
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
      case '/the_room':
        final roomId = settings.arguments as int;
        return MaterialPageRoute(builder: (_) => TheRoomPage(roomId: roomId));
      case '/vet-registration-page':
        return MaterialPageRoute(builder: (_) => const VetRegistrationPage());
      case '/private-room':
        final roomId = settings.arguments as int;
        return MaterialPageRoute(
            builder: (_) => PrivateRoomPage(roomId: roomId));
      case '/vetInfo-page':
        final args = settings.arguments as Map<String, dynamic>;
        final vetId = args['vetId'] as int;
        final vetName = args['vetName'] as String;
        return MaterialPageRoute(
            builder: (_) => VetInfoPage(vetId: vetId, vetName: vetName));
      case '/generalPostDetailsView':
        final post = settings.arguments as dynamic;
        return MaterialPageRoute(
          builder: (_) => GeneralPostDetailsView(post: post),
        );
      default:
        return _errorPage();
    }
  }

  static Route<dynamic> _errorPage() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: theAppBar(_, "Try again later"),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "The service is temporary unavailable",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      _,
                      MaterialPageRoute(
                        builder: (_) => const HomePage(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kcolor,
                  ),
                  child: Text("Go Home"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
