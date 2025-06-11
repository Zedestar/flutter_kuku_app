import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kuku_app/constants/constant.dart';
import 'package:kuku_app/pages/doctors_list_page.dart';
import 'package:kuku_app/pages/rooms_list_page.dart';
import 'package:kuku_app/widgets/app_bar.dart';

class GeneralChatPage extends StatefulWidget {
  const GeneralChatPage({super.key});

  @override
  State<GeneralChatPage> createState() => _GeneralChatPageState();
}

class _GeneralChatPageState extends State<GeneralChatPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: kcolor,
              centerTitle: true,
              // pinned: true,
              floating: true,
              snap: true,
              title: Text('post_page'.tr()),
              bottom: TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: 'Chatting rooms'),
                  Tab(text: 'Doctors list'),
                ],
              ),
            ),
          ],
          body: TabBarView(
            children: [
              RoomListPage(),
              DoctorsListPage(),
            ],
            //
          ),
        ),
      ),
    );
  }
}
