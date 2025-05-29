import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:kuku_app/widgets/bottom_navigation_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("This is home Page"),
      ),
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
            itemTitle: "Detect Disease",
            itemIcon: Icons.medical_information,
          ),
          TheButtomNavigationItem(
            itemTitle: "Settings",
            itemIcon: Icons.settings_outlined,
          ),
        ],
      ),
    );
  }
}
