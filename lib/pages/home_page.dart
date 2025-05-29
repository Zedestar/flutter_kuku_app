import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:kuku_app/pages/authentication_page.dart';
import 'package:kuku_app/pages/detect_disease_page.dart';
import 'package:kuku_app/pages/general_chatting_page.dart';
import 'package:kuku_app/pages/general_post_page.dart';
import 'package:kuku_app/pages/splash_page.dart';
import 'package:kuku_app/widgets/bottom_navigation_items.dart';
import 'package:provider/provider.dart';

import '../provider/theme_mode_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    GeneralPostPage(),
    GeneralChatPage(),
    PredictDiseaseScreen(),
    AuthPage(),
  ];

  void showSettingDialog(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text("Settings",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                ),
              ),
              Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.account_circle_outlined),
                    title: Text('Profile'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/profile-page');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text('Change to Kiswahili'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/profile-page');
                    },
                  ),
                  ListTile(
                    leading: Icon(Provider.of<DarkLightModeProvider>(context,
                                listen: false)
                            .gettingThemeChanger
                        ? Icons.dark_mode
                        : Icons.light_mode),
                    title: Text(
                      Provider.of<DarkLightModeProvider>(context, listen: false)
                              .gettingThemeChanger
                          ? 'Dark mode'
                          : 'Light mode',
                    ),
                    onTap: () {
                      Provider.of<DarkLightModeProvider>(context, listen: false)
                          .toggleTheme();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.share),
                    title: Text('ShareApp'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/share-page');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications_outlined),
                    title: Text('Notifications'),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, '/notifications-page');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.help_outline),
                    title: Text('Help & Support'),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, '/help-and-support-page');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/splash-screen');
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.lightBlueAccent,
        buttonBackgroundColor: Colors.lightBlue,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        height: 60,
        items: <Widget>[
          TheButtomNavigationItem(
            itemTitle: "Posts",
            itemIcon: Icons.article_outlined,
          ),
          TheButtomNavigationItem(
            itemTitle: "Chats",
            itemIcon: Icons.chat_outlined,
          ),
          TheButtomNavigationItem(
            itemTitle: "Detect Disease",
            itemIcon: Icons.medical_information_outlined,
          ),
          TheButtomNavigationItem(
            itemTitle: "My Samples",
            itemIcon: Icons.science,
          ),
          TheButtomNavigationItem(
            itemTitle: "Settings",
            itemIcon: Icons.settings_outlined,
          ),
        ],
        onTap: (value) {
          if (value == 4) {
            showSettingDialog(context);
          } else {
            setState(() {
              _selectedIndex = value;
            });
          }
        },
      ),
    );
  }
}
