import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_graphql/data/user_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AccountController extends GetxController {
  late RxBool isMe;
  late RxBool showShipperInfo;
  late Rxn<User> user;

  Future<void> fetchUser(String? userId) async {
    try {
      if (userId == null) {
        isMe.value = true;
        user.value = await authService.getCurrentUser();
      } else {
        user.value =
            userList.list.firstWhere((element) => element.id == userId);
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await authService.signOut();
    } catch (e) {
      //TODO: show dialog
      unawaited(showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context).logoutFailed),
          content: Text(AppLocalizations.of(context).logoutFailed),
          actions: <Widget>[
            ElevatedButton(
              child: Text(AppLocalizations.of(context).ok),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ));
    }
  }

  Future<void> confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context).logout),
            content: Text(AppLocalizations.of(context).logoutAreYouSure),
            actions: <Widget>[
              ElevatedButton(
                child: Text(AppLocalizations.of(context).cancel),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              ElevatedButton(
                child: Text(AppLocalizations.of(context).ok),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ??
        false;
    if (didRequestSignOut == true) {
      await _signOut(context);
    }
  }

  Future<void> showFeedBacksPage(
      BuildContext context, User user, String myUserId2) async {
    //await FeedBacksPage.showPlz(context, user, myUserId2);
  }

  @override
  void onInit() {
    isMe = true.obs;
    user = Rxn<User>();

    super.onInit();
  }
}
