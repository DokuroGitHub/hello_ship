import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter_graphql/screens/chats_screen.dart';
import 'package:flutter_graphql/screens/contacts_screen.dart';
import 'package:flutter_graphql/screens/posts_screen.dart';
import 'package:flutter_graphql/screens/shipments_screen.dart';

import '../controllers/dashboard/dashboard_controller_for_user.dart';
import '../controllers/dashboard_controller.dart';
import '../models/user.dart';
import 'account_screen.dart';

class DashboardScreenForUser extends StatelessWidget {
  const DashboardScreenForUser({Key? key}) : super(key: key);

  Widget _bottomNavBar(
      BuildContext context, DashboardController dashboardController) {
    return SizedBox(
      height: dashboardController.bottomNavBarHeight,
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: const Icon(Icons.post_add),
              tooltip: 'Posts here',
              label: AppLocalizations.of(context).posts,
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: const Icon(Icons.delivery_dining),
              tooltip: 'Shipments here',
              label: AppLocalizations.of(context).shipments,
              backgroundColor: Colors.yellow),
          BottomNavigationBarItem(
            icon: const Icon(Icons.contacts),
            tooltip: 'Contacts here',
            label: AppLocalizations.of(context).contacts,
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat),
            tooltip: 'Chats here',
            label: AppLocalizations.of(context).chats,
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            tooltip: 'Profile here',
            label: AppLocalizations.of(context).account,
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

  @override
  Widget build(BuildContext context) {
    debugPrint('DashboardScreenForUser');
    final dashboardControllerForUser = Get.put(DashboardControllerForUser());
    final dashboardController = Get.find<DashboardController>();

    //TODO: page 0
    ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      child: Image.asset('assets/images/welcome_image.png'),
    );

    final List<Widget> _widgetOptions = [
      //TODO: page 0
      const PostsScreen(),
      //TODO: page 1
      const ShipmentsScreen(),
      //TODO: page 2
      const ContactsScreen(),
      //TODO: page 3
      const ChatsScreen(),
      //TODO: page 4
      const AccountScreen(),
    ];

    return Scaffold(
      body: AnimatedBuilder(
        animation: dashboardController.model,
        builder: (context, child) {
          return Stack(
            children: [
              Obx(() =>
                  _widgetOptions[dashboardController.selectedIndex.value]),
              Obx(
                () => Positioned(
                  left: 0,
                  right: 0,
                  bottom: dashboardController.model.bottom,
                  child: _bottomNavBar(context, dashboardController),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
