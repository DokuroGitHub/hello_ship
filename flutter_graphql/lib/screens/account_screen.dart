import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_graphql/controllers/account_controller.dart';
import 'package:flutter_graphql/services/theme/theme_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/strings.dart';
import '../controllers/dashboard/dashboard_controller_for_user.dart';
import '../controllers/dashboard_controller.dart';
import '../models/user.dart';
import '../services/locale/locale_service.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key, this.userId}) : super(key: key);

  final String? userId;

  AppBar _buildAppBar(
      AccountController accountController, BuildContext context) {
    return AppBar(
      title: const Text(Strings.accountPage),
      actions: <Widget>[
        if (accountController.isMe.value)
          Row(children: [
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
                    child: Text('Tiếng Việt',
                        style: TextStyle(
                            color: LocaleService().languageCode == 'vi'
                                ? Colors.red
                                : Colors.blue)),
                  ),
                  PopupMenuItem<String>(
                    value: 'en',
                    child: Text('English',
                        style: TextStyle(
                            color: LocaleService().languageCode == 'en'
                                ? Colors.red
                                : Colors.blue)),
                  ),
                  PopupMenuItem<String>(
                    value: 'es',
                    child: Text('Espanol',
                        style: TextStyle(
                            color: LocaleService().languageCode == 'es'
                                ? Colors.red
                                : Colors.blue)),
                  ),
                ];
              },
            ),
            const SizedBox(width: 10),
            TextButton(
              child: Text(AppLocalizations.of(context).logout,
                  style: Theme.of(context).textTheme.bodyText1),
              onPressed: () => accountController.confirmSignOut(context),
            ),
          ]),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: _buildUserInfo(accountController),
      ),
    );
  }

  Widget _buildUserInfo(AccountController accountController) {
    return Column(
      children: [
        // Avatar(
        //   photoUrl: user.photoURL,
        //   radius: 30,
        //   borderColor: Colors.black54,
        //   borderWidth: 2.0,
        // ),
        const SizedBox(height: 8),
        Obx(() => Text(
              accountController.user.value?.id ?? 'Không tìm thấy',
            )),
        const SizedBox(height: 8),
        Obx(() => Text(
              accountController.user.value?.email ??
                  'Người dùng chưa thiết lập gmail',
            )),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('AccountScreen');
    final dashboardController = Get.find<DashboardController>();
    final dashboardControllerForUser = Get.find<DashboardControllerForUser>();
    final accountController = Get.put(AccountController());
    accountController.fetchUser(userId);

    Scaffold(
      body: SingleChildScrollView(
        controller: dashboardController.controller,
        child: Column(
          children: [
            ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
              child: Image.asset('assets/images/welcome_image.png'),
            ),
            for (var i = 0; i < 100; i++) const Text("AccountScreen"),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: _buildAppBar(accountController, context),
      body: Column(children: [
        //TODO: fields
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            controller: dashboardController.controller,
            reverse: false,
            child: Column(
              children: [
                //TODO: address
                // _address(),
                // const SizedBox(height: 10),
                // //TODO: _birthDate
                // _birthDate(),
                // const SizedBox(height: 10),
                // //TODO: _createdAt
                // _createdAt(),
                // const SizedBox(height: 10),
                // //TODO: _email
                // _email(),
                // const SizedBox(height: 10),
                // //TODO: _isActive
                // _isActive(),
                // const SizedBox(height: 10),
                // //TODO: _isBlock
                // _isBlock(),
                // const SizedBox(height: 10),
                // //TODO: _lastSignInAt
                // _lastSignInAt(),
                // const SizedBox(height: 10),
                // //TODO: _name
                // _name(),
                // const SizedBox(height: 10),
                // //TODO: _phoneNumber
                // _phoneNumber(),
                // const SizedBox(height: 10),
                // //TODO: _role
                // _role(),
                // const SizedBox(height: 10),
                // //TODO: _selfIntroduction
                // _selfIntroduction(),
                // const SizedBox(height: 10),
                // //TODO: _shipperInfo
                // _shipperInfo(),
                // const SizedBox(height: 10),
                // //TODO: _feedback
                // _feedback(),

                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width),
                  child: Image.asset('assets/images/welcome_image.png'),
                ),
                for (var i = 0; i < 100; i++) const Text("AccountScreen"),
              ],
            ),
          ),
        )),
        //TODO: call, sms, chat
        if (!accountController.isMe.value)
          Row(children: [
            Row(children: const [Icon(Icons.call), Text('Gọi điện')]),
            Row(children: const [Icon(Icons.sms), Text('Gửi SMS')]),
            Row(children: const [Icon(Icons.chat), Text('Chat')]),
          ]),
      ]),
    );
  }
}
