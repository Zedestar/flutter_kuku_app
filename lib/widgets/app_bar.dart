import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kuku_app/constants/constant.dart';

AppBar theAppBar(BuildContext context, String appBarTitle) {
  return AppBar(
    backgroundColor: kcolor,
    centerTitle: true,
    title: Text(appBarTitle.tr()),
  );
}
