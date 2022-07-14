import 'dart:async';

import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/controllers/dashboard_controller.dart';
import 'package:dokuro_flutter/helpers/string_helper.dart';
import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/screens/dashboard/contacts/contact_item.dart';
import 'package:dokuro_flutter/screens/dashboard/messages/messages_screen.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:get/get.dart';

class ContactsController {
  final dbService = Get.find<DbService>();
  final int _limit = 2;
  final scrollController = Get.find<DashboardController>().controller;
  final User currentUser = Get.find<AuthController>().authedUser.value!;

  Rx<Status> status = Status.ready.obs;
  bool _loadingMore = false;

  // users
  RxList<ContactItem> contactItems = RxList();
  Rx<PageInfo> contactsPageInfo = PageInfo().obs;
  RxInt contactsTotalCount = 0.obs;

  void _scrollListener() {
    if (scrollController.position.maxScrollExtent <= 0) {
      debugPrint(scrollController.position.extentBefore.toString());
    }

    if (scrollController.position.extentAfter < 100) {
      if (!_loadingMore) {
        _loadingMore = true;
        debugPrint('contactsPageInfo: $contactsPageInfo}');
        if (contactsPageInfo.value.hasNextPage == true) {
          fetchUsersByFirstAfter();
        }
      }
    } else {
      _loadingMore = false;
    }
  }

  void initPlz() {
    scrollController.addListener(_scrollListener);
    fetchUsersByFirstAfter();
  }

  void disposePlz() {
    scrollController.removeListener(_scrollListener);
  }

  Future<void> onContactItemTap(User user) async {
    final conversationId =
        stringHelper.conversationIdBy2UserIds(user.id, currentUser.id);
    final item = await dbService.conversationById(conversationId);
    if (item == null) {
      // create
      final created = await dbService.createdConversationByIdCreatedBy(
        conversationId,
        currentUser.id,
      );
      if (created == null) {
        Get.snackbar(
          'Failed:',
          'Could not create conversation',
          duration: const Duration(seconds: 2),
        );
      } else {
        final created2 = await dbService
            .createParticipantByConversationIdUserIdCreatedByRole(
          created.id,
          currentUser.id,
          currentUser.id,
        );
        final created3 = await dbService
            .createParticipantByConversationIdUserIdCreatedByRole(
          created.id,
          user.id,
          currentUser.id,
        );
        if (created2 == null || created3 == null) {
          Get.snackbar(
            'Failed:',
            'Could not create participants',
            duration: const Duration(seconds: 2),
          );
        } else {
          // go to
          Get.to(() => MessagesScreen(created));
        }
      }
    } else {
      // go to
      Get.to(() => MessagesScreen(item));
    }
  }

  Future<void> fetchUsersByFirstAfter() async {
    try {
      var moreItems = await dbService.usersByFirstAfter(
        _limit,
        contactsPageInfo.value.endCursor,
      );
      if (moreItems != null) {
        contactsTotalCount.value = moreItems.totalCount;
        contactsPageInfo.value = moreItems.pageInfo ?? PageInfo();
        contactItems.addAll(moreItems.nodes.map((e) => ContactItem(
              e,
              initialKey: Key(e.id),
              onTapCallBack: () {
                onContactItemTap(e);
              },
            )));
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }

/*subscriptionUsersForContactsScreen
  void subscriptionUsersForContactsScreen() {
    status.value = Status.loading;
    debugPrint('subscriptionUsersForContactsScreen');
    try {
      var subscription = _client.subscribe(
        SubscriptionOptions(
          document: gql(UserQuery.subscriptionUsersForContactsScreen),
          variables: const {},
        ),
      );
      subscription.listen((result) {
        if (result.hasException) {
          debugPrint(result.exception.toString());
          return;
        }
        if (result.isLoading) {
          debugPrint('awaiting results');
          return;
        }
        final map = result.data?['users'];
        debugPrint('subscriptionUsersForContactsScreen, map: $map');
        final usersDesu = convertMapToUsers(map);
        if (usersDesu != null) {
          //users.value = usersDesu;

        }
      });
    } catch (e) {
      debugPrint('e: $e');
    }
    status.value = Status.ready;
  }
*/

}
