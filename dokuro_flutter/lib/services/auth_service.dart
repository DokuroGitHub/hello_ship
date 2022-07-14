import 'dart:convert';

import 'package:colorize/colorize.dart';
import 'package:dokuro_flutter/config.dart';
import 'package:dokuro_flutter/controllers/dashboard_controller.dart';
import 'package:dokuro_flutter/helpers/helper.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:dokuro_flutter/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthService extends GetxService {
  final FlutterAppAuth appAuth = const FlutterAppAuth();
  final storageService = Get.find<StorageService>();
  final dbService = Get.find<DbService>();

  Rxn<User> currentUser = Rxn();
  Rxn<String> accessToken = Rxn();

  Future<AuthService> initPlz() async {
    debugPrint('$runtimeType delays 2 sec');
    //await 2.delay();
    ever(accessToken, (String? val) async {
      debugPrint('$runtimeType accessToken: $val');
      await storageService.writeRefreshToken(val);
      dbService.resetClient(accessToken.value);
      currentUser.value = await dbService.getCurrentUser();
    });
    debugPrint('$runtimeType ready!');
    return this;
  }

  Map<String, dynamic> parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map<String, dynamic>> getUserDetails(String accessToken) async {
    final response = await http.get(
      Auth0Config.AUTH0_USER_INFO_URI,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<Map<String, dynamic>?> signInWithEmailPassword(
      String username, String password) async {
    Map credentials = {
      "username": username,
      "password": password,
    };
    try {
      http.Response response = await http.post(
        HerokuConfig.LOGIN_WITH_EMAIL_PASSWORD_AUTH0_URI,
        headers: {"content-type": "application/json"},
        body: jsonEncode(credentials),
      );
      debugPrint('body: ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      debugPrint('login, e: $e');
    }
    return null;
  }

  Future<void> signInWithAuth0() async {
    try {
      final result = await authorizeAndExchangeCode();
      await signInResult(result);
    } catch (e) {
      debugPrint('${StackTrace.current}, e: $e');
    }
  }

  Future<AuthorizationTokenResponse?> authorizeAndExchangeCode() async {
    try {
      return await appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
        Auth0Config.AUTH0_NATIVE_CLIENT_ID,
        Auth0Config.AUTH0_REDIRECT_URI,
        issuer: Auth0Config.AUTH0_ISSUER,
        additionalParameters: {
          'audience': Auth0Config.AUTH0_AUDIENCE,
        },
        scopes: ['openid', 'email', 'profile', 'offline_access', 'api'],
        promptValues: ['login'],
      ));
    } catch (e) {
      debugPrint('${StackTrace.current}, e: $e');
    }
    return null;
  }

  Future<TokenResponse?> signInWithRefreshToken(String refreshToken) async {
    try {
      return await appAuth.token(TokenRequest(
        Auth0Config.AUTH0_NATIVE_CLIENT_ID,
        Auth0Config.AUTH0_REDIRECT_URI,
        issuer: Auth0Config.AUTH0_ISSUER,
        refreshToken: refreshToken,
      ));
    } catch (e) {
      debugPrint('${StackTrace.current}, e: $e');
    }
    return null;
  }

  Future<void> signInResult(TokenResponse? result) async {
    print.green('${StackTrace.current}, result: $result');
    try {
      final idTokenDesu = result?.idToken;
      final accessTokenDesu = result?.accessToken;
      final refreshTokenDesu = result?.refreshToken;
      final idTokenParsed =
          idTokenDesu != null ? parseIdToken(idTokenDesu) : null;
      final profile = accessTokenDesu != null
          ? await getUserDetails(accessTokenDesu)
          : null;
      print.blue('idTokenDesu: $idTokenDesu');
      print.styles(
        'accessTokenDesu: $accessTokenDesu',
        [Styles.GREEN],
      );
      print.yellow('refreshTokenDesu: $refreshTokenDesu');
      debugPrint('idTokenParsed: $idTokenParsed');
      print.blue('profile: $profile');
      accessToken.value = accessTokenDesu;
      final id = currentUser.value?.id;
      // update db
      if (id != null && id.isNotEmpty) {
        Get.snackbar(
          'Success',
          'Signed in',
        );
        final name = idTokenParsed?['name'];
        final picture = profile?['picture'];
        Get.dialog(SimpleDialog(
          title: const Text('Do u want to update profile?'),
          children: [
            Text('avatarUrl: $picture'),
            Text('name: $name'),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              TextButton(
                onPressed: () async {
                  Get.back();
                  final patch = {
                    'name': name,
                    'avatarUrl': picture,
                  };
                  await dbService.updateUserByIdPatch(id, patch);
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: Get.back,
                child: const Text('No'),
              ),
            ]),
          ],
        ));
      }
    } catch (e) {
      debugPrint('${StackTrace.current}, e: $e');
      Get.snackbar(
        'Failed',
        'Could not sign in',
      );
    }
  }

  Future<void> signOut() async {
    dbService.resetClient();
    await storageService.removeRefreshToken();
    currentUser.value = null;
    accessToken.value = null;
    final dashboardController = Get.find<DashboardController>();
    dashboardController.disposePlz();
    //await Get.deleteAll();
  }

  /// singIn = refreshToken
  void signInSilently() async {
    final storedRefreshToken = storageService.readRefreshToken;
    if (storedRefreshToken == null) return;
    try {
      final result = await signInWithRefreshToken(storedRefreshToken);
      await signInResult(result);
    } catch (e) {
      debugPrint('${StackTrace.current}, e: $e');
      signOut();
    }
  }
}
