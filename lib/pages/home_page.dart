import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kuku_app/provider/checking_logged_inuser_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:kuku_app/pages/detect_disease_page.dart';
import 'package:kuku_app/pages/general_chatting_page.dart';
import 'package:kuku_app/pages/general_post_page.dart';
import 'package:kuku_app/pages/sample_page.dart';
import 'package:kuku_app/token/token_helper.dart';
import 'package:kuku_app/widgets/bottom_navigation_items.dart';
import 'package:kuku_app/widgets/bottom_tiles_tiles.dart';
import 'package:provider/provider.dart';

import '../provider/theme_mode_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool? present = false;

  final List<Widget> _pages = [
    GeneralPostPage(),
    GeneralChatPage(),
    PredictDiseaseScreen(),
    SamplePage(),
  ];

  void showSettingDialog(BuildContext context, bool present) {
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
                  child: Text("settings".tr(),
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
                  BottomSheetTiles(
                    tileString: 'profile'.tr(),
                    tileIcon: Icons.account_circle_outlined,
                    theFunction: () {
                      Navigator.pushReplacementNamed(context, '/profile-page');
                    },
                  ),
                  BottomSheetTiles(
                    tileString: 'change_language'.tr(),
                    tileIcon: Icons.language_outlined,
                    theFunction: () {
                      Locale currentLocale = context.locale;
                      currentLocale.languageCode == 'en'
                          ? context.setLocale(Locale('sw'))
                          : context.setLocale(Locale('en'));
                    },
                  ),
                  BottomSheetTiles(
                    tileString: Provider.of<DarkLightModeProvider>(context,
                                listen: false)
                            .gettingThemeChanger
                        ? 'light_mode'.tr()
                        : 'dark_mode'.tr(),
                    tileIcon: Provider.of<DarkLightModeProvider>(context,
                                listen: false)
                            .gettingThemeChanger
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    theFunction: () {
                      Provider.of<DarkLightModeProvider>(context, listen: false)
                          .toggleTheme();
                    },
                  ),
                  BottomSheetTiles(
                    tileString: 'share_app'.tr(),
                    tileIcon: Icons.share_outlined,
                    theFunction: () {
                      // Navigator.pushReplacementNamed(context, '/share-page');
                      SharePlus.instance.share(
                        ShareParams(
                          title: "Install the Kuku ap now",
                          text: 'Check out kuku app: https://yourapp.com',
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.heart_broken),
                    title: Text('notifications'.tr()),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, '/vet-registration-page');
                    },
                  ),
                  BottomSheetTiles(
                    tileString: 'help_and_supprt'.tr(),
                    tileIcon: Icons.help_outline,
                    theFunction: () {
                      Navigator.pushReplacementNamed(
                          context, '/help-and-support-page');
                    },
                  ),
                  present
                      ? BottomSheetTiles(
                          tileString: 'logout'.tr(),
                          tileIcon: Icons.logout_outlined,
                          theFunction: () async {
                            // Navigator.pushReplacementNamed(context, '/auth-page');
                            await SecureStorageHelper.deleteToken();
                            Navigator.pushReplacementNamed(
                                context, "/auth-page");
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Notification"),
                                  content: Text("Logged out successful"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Okay"))
                                  ],
                                );
                              },
                            );
                          },
                        )
                      : BottomSheetTiles(
                          tileString: 'login',
                          tileIcon: Icons.login_outlined,
                          theFunction: () {
                            Navigator.pushNamed(context, '/auth-page');
                          },
                        )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void checkingIfUserHasLoggedIn() async {
    final token = await SecureStorageHelper.getToken();
    if (token != null && token.isNotEmpty) {
      setState(() {
        present = true;
      });
    }
  }

  @override
  void initState() {
    checkingIfUserHasLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final userPresense = Provider.of<CheckingUserPresence>(context);
    // final present = userPresense.isUserPresentFuctionChecking;
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.lightBlueAccent,
        buttonBackgroundColor: Colors.lightBlue,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        height: 63,
        items: <Widget>[
          TheButtomNavigationItem(
            itemTitle: 'posts'.tr(),
            itemIcon: Icons.article_outlined,
          ),
          TheButtomNavigationItem(
            itemTitle: 'chats'.tr(),
            itemIcon: Icons.chat_outlined,
          ),
          TheButtomNavigationItem(
            itemTitle: 'detect_disease'.tr(),
            itemIcon: Icons.medical_information_outlined,
          ),
          TheButtomNavigationItem(
            itemTitle: 'sample'.tr(),
            itemIcon: Icons.science,
          ),
          TheButtomNavigationItem(
            itemTitle: 'settings'.tr(),
            itemIcon: Icons.settings_outlined,
          ),
        ],
        onTap: (value) {
          if (value == 4) {
            showSettingDialog(context, present!);
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
