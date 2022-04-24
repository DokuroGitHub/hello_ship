import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_graphql/data/user_list.dart';
import 'package:flutter_graphql/services/get_storage/get_storage_service.dart';

import '../controllers/auth_controller.dart';
import '../data/user_account_list.dart';
import '../models/user.dart';
import '../models/user_account.dart';

class AuthService {
  Future<User?> getCurrentUser() async {
    late User? user;
    try {
      final authController = Get.find<AuthController>();
      user = authController.authedUser.value;
    } catch (e) {
      debugPrint('e: $e');
    }
    return user;
  }

  Future<void> signOut() async {
    getStorageService.clearToken();
    final AuthController authController = Get.find<AuthController>();
    authController.authedUser.value = null;
  }

  User? signInWithToken({required String token}) {
    late User? user;
    try {
      //TODO: parse token to get userId
      const id = 'user_1';
      user = userList.list.firstWhere((element) => element.id == id);
    } catch (e) {
      debugPrint('tai khoan ko dung');
    }
    return user;
  }

  User? signInWithCredential(
      {required String email, required String password}) {
    User? user;
    try {
      debugPrint('email: $email, password: $password');
      debugPrint('userAccountList: ${userAccountList.list.map((e) => {
            'email': e.email,
            'password': e.password,
            'role': e.role,
          })}');
      final userAccount = userAccountList.list.firstWhere(
          (element) => element.email == email && element.password == password);
      user = userList.list
          .firstWhere((element) => element.id == userAccount.userId);
    } catch (e) {
      debugPrint('signInWithCredential not valid account');
    }
    return user;
  }

  User? createUserWithEmailAndPassword(
      {required String email, required String password}) {
    User? user;
    try {
      late bool isValidEmail;
      try {
        userList.list.firstWhere((element) => element.email == email);
        isValidEmail = false;
      } catch (_e) {
        isValidEmail = true;
      }
      if (!isValidEmail) {
        debugPrint('createUserWithEmailAndPassword, email already exists');
        return null;
      }
      user = userList.add(
          User(email: email, createdAt: DateTime.now(), role: 'role_user'));
      if (user != null) {
        final UserAccount? userAccount = userAccountList.add(UserAccount(
          userId: user.id,
          username: email,
          email: email,
          password: password,
          role: 'role_user',
        ));
        if (userAccount == null) {
          userList.list.remove(user);
          user = null;
        }
      }
    } catch (e) {
      debugPrint('e: $e');
    }
    return user;
  }

  Future sendPasswordResetEmail(String email) async {}

  Future signInWithGoogle() async {}
}

AuthService authService = AuthService();
