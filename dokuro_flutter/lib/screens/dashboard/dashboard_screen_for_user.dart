import 'package:dokuro_flutter/controllers/dashboard_controller.dart';
import 'package:dokuro_flutter/screens/dashboard/account/account_screen.dart';
import 'package:dokuro_flutter/screens/dashboard/chats/chats_screen.dart';
import 'package:dokuro_flutter/screens/dashboard/contacts/contacts_screen.dart';
import 'package:dokuro_flutter/screens/dashboard/posts/posts_screen.dart';
import 'package:dokuro_flutter/screens/dashboard/shipments/shipments_for_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class DashboardScreenForUser extends StatelessWidget {
  const DashboardScreenForUser({Key? key}) : super(key: key);

  final List<Widget> widgetOptions = const [
    // page 0
    PostsScreen(),
    // page 1
    ShipmentsForUserScreen(),
    // page 2
    ContactsScreen(),
    // page 3
    ChatsScreen(),
    // page 4
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint('$runtimeType build');
    final dashboardController = Get.find<DashboardController>();

    return Scaffold(
      body: AnimatedBuilder(
        animation: dashboardController.model,
        builder: (context, child) {
          return Obx(() => Stack(
                children: [
                  // content
                  widgetOptions[dashboardController.selectedIndex.value],
                  // _bottomNavBar
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: dashboardController.model.bottom,
                    child: _bottomNavBar(dashboardController),
                  ),
                ],
              ));
        },
      ),
    );
  }

  Widget _bottomNavBar(DashboardController dashboardController) {
    return SizedBox(
      height: dashboardController.bottomNavBarHeight,
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: const Icon(Icons.post_add),
              tooltip: 'Posts here',
              label: AppLocalizations.of(Get.context!).posts,
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: const Icon(Icons.delivery_dining),
              tooltip: 'Shipments here',
              label: AppLocalizations.of(Get.context!).shipments,
              backgroundColor: Colors.yellow),
          BottomNavigationBarItem(
            icon: const Icon(Icons.contacts),
            tooltip: 'Contacts here',
            label: AppLocalizations.of(Get.context!).contacts,
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat),
            tooltip: 'Chats here',
            label: AppLocalizations.of(Get.context!).chats,
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            tooltip: 'Profile here',
            label: AppLocalizations.of(Get.context!).account,
            backgroundColor: Colors.blue,
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: dashboardController.selectedIndex.value,
        selectedItemColor: Colors.black,
        //backgroundColor: Colors.blue,
        iconSize: 30,
        onTap: (index) {
          dashboardController.selectedIndex.value = index;
        },
        elevation: 5,
      ),
    );
  }
}
