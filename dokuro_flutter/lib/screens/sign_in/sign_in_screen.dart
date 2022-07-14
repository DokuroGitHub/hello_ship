import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../constants/status.dart';
import '../../controllers/log_in/sign_in_controller.dart';
import '../../services/locale/locale_service.dart';
import '../../services/theme/theme_service.dart';
import '/constants/strings.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('SignInScreen');
    final signInController = Get.put(SignInController());

    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(AppLocalizations.of(context).signIn),
        actions: [
          // switch theme
          IconButton(
            icon: const Icon(Icons.lightbulb),
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
            onPressed: themeService.switchTheme,
          ),

          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).appBarTheme.titleTextStyle?.color,
            ),
            onSelected: localeService.changeLocale,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'vi',
                  child: Text(
                    'Tiếng Việt',
                    style: TextStyle(
                      color: localeService.languageCode == 'vi'
                          ? Colors.red
                          : Colors.blue,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'en',
                  child: Text(
                    'English',
                    style: TextStyle(
                      color: LocaleService().languageCode == 'en'
                          ? Colors.red
                          : Colors.blue,
                    ),
                  ),
                ),
                if (1 == 2)
                  PopupMenuItem<String>(
                    value: 'es',
                    child: Text(
                      'Espanol',
                      style: TextStyle(
                        color: LocaleService().languageCode == 'es'
                            ? Colors.red
                            : Colors.blue,
                      ),
                    ),
                  ),
              ];
            },
          ),
        ],
      ),
      body: _buildSignIn(context, signInController),
    );
  }

  Widget _buildHeader(SignInController signInController) {
    return Obx(() {
      if (signInController.status.value == Status.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      return const Text(
        Strings.signIn,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
      );
    });
  }

  Widget _buildSignIn(BuildContext context, SignInController signInController) {
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          width: min(constraints.maxWidth, 600),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 32.0),
              SizedBox(
                height: 50.0,
                child: _buildHeader(signInController),
              ),
              const SizedBox(height: 32.0),
              Obx(() => ElevatedButton(
                  onPressed: signInController.status.value == Status.loading
                      ? null
                      : () => signInController.showEmailPasswordSignInScreen(),
                  child: const Text(Strings.signInWithEmailPassword))),
              const SizedBox(height: 8),
              const Text(
                Strings.or,
                style: TextStyle(fontSize: 14.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Obx(() => ElevatedButton(
                  onPressed: signInController.status.value == Status.loading
                      ? null
                      : () => signInController.signInWithAuth0(),
                  child: const Text('Sign In With Auth0'))),
              const SizedBox(height: 8),
              // show welcome next time
              GestureDetector(
                onTap: () {
                  signInController.showWelcomeScreenNextTime();
                  Get.snackbar(
                    "Note:",
                    "Welcome screen will be showing!",
                    icon: const Icon(Icons.person, color: Colors.white),
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: const Text(
                  'show welcome screen',
                  style: TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
