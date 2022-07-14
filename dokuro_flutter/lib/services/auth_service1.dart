import 'dart:convert';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:dokuro_flutter/controllers/dashboard_controller.dart';
import 'package:dokuro_flutter/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dokuro_flutter/services/get_storage/get_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AuthService1 {
  Future<void> signOut() async {
    getStorageService.clearToken();
    final dashboardController = Get.find<DashboardController>();
    dashboardController.disposePlz();
    final authController = Get.find<AuthController>();
    authController.disposePlz();
  }

  Future sendPasswordResetEmail(String email) async {}

  Future signInWithGoogle() async {}

  Future<Map<String, dynamic>?> login(String username, String password) async {
    dynamic result;
    Map credentials = {
      "username": username,
      "password": password,
    };
    try {
      http.Response response = await http.post(
        Uri.http(
            '$serverDomain:$portHttp', "auth/login_with_email_password_auth0"),
        headers: {"content-type": "application/json"},
        body: jsonEncode(credentials),
      );
      debugPrint('body: ${response.body}');
      result = jsonDecode(response.body);
    } catch (e) {
      debugPrint('login, e: $e');
    }
    return result;
  }

  Future<Map<String, dynamic>?> signup(String username, String password) async {
    dynamic result;
    Map credentials = {
      "username": username,
      "password": password,
    };
    try {
      http.Response response = await http.post(
        Uri.http('$serverDomain:$portHttp', "auth/login"),
        headers: {"content-type": "application/json"},
        body: jsonEncode(credentials),
      );
      result = jsonDecode(response.body);
    } catch (e) {
      debugPrint('login, e: $e');
    }
    return result;
  }

  Future<void> loginPlz() async {
    final Uri url = Uri.parse('http://$serverDomain:$portHttp/auth/login');
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }
}

AuthService1 authService2 = AuthService1();
