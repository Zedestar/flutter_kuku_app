import 'package:flutter/material.dart';
import 'package:kuku_app/token/token_helper.dart';

class CheckingUserPresence with ChangeNotifier {
  bool? _isUserLoggedIn = false;

  Future<void> checkingUserPresence() async {
    final token = await SecureStorageHelper.getToken();
    if (token != null && token.isNotEmpty) {
      _isUserLoggedIn = true;
      notifyListeners();
    }
  }

  bool isUserPresentFuctionChecking() {
    return _isUserLoggedIn ?? false;
  }
}
