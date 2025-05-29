import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:kuku_app/pages/authentication_page.dart';
import 'package:kuku_app/pages/detect_disease_page.dart';
import 'package:kuku_app/pages/general_chatting_page.dart';
import 'package:kuku_app/pages/general_post_page.dart';
import 'package:kuku_app/pages/splash_page.dart';
import 'package:kuku_app/widgets/bottom_navigation_items.dart';

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
      context: context,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.account_circle_outlined),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.pushNamed(context, '/profile-page');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notifications_outlined),
                  title: Text('Notifications'),
                  onTap: () {
                    Navigator.pushNamed(context, '/notifications-page');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text('Help & Support'),
                  onTap: () {
                    Navigator.pushNamed(context, '/help-page');
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
            ),
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
            itemTitle: "looking",
            itemIcon: Icons.medical_information,
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
