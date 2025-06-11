import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kuku_app/constants/constant.dart';
import 'package:kuku_app/pages/business_past_page.dart';
import 'package:kuku_app/pages/knowledge_post.dart';

class GeneralPostPage extends StatefulWidget {
  const GeneralPostPage({super.key});

  @override
  State<GeneralPostPage> createState() => _GeneralPostPageState();
}

class _GeneralPostPageState extends State<GeneralPostPage> {
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
                  Tab(text: 'knowledge_post'),
                  Tab(text: 'business_post'),
                ],
              ),
            ),
          ],
          body: TabBarView(
            children: [
              KnowledgePostPage(),
              BussinessPage(),
            ],
            //
          ),
        ),
      ),
    );
  }
}
