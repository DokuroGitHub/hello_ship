import 'dart:async';

import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/controllers/dashboard_controller.dart';
import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/post/post_item.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_name.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:get/get.dart';

class PostsController extends GetxController {
  final dbService = Get.find<DbService>();
  final int _limit = 2;
  final scrollController = Get.find<DashboardController>().controller;
  final User currentUser = Get.find<AuthController>().authedUser.value!;
  final TextEditingController postTextTEC = TextEditingController();

  bool _loadingMore = false;
  Rx<Status> status = Status.ready.obs;
  RxBool showFAB = false.obs;
  // chips
  RxBool chipShipment = false.obs;
  RxBool chipFinding = false.obs;
  RxBool chipSaving = false.obs;
  RxBool chipFast = false.obs;
  RxBool chipDelivery = false.obs;
  RxBool chipTransport = false.obs;

  // posts
  RxList<PostItem> postItems = RxList();
  Rx<PageInfo> postsPageInfo = PageInfo().obs;
  RxInt postsTotalCount = 0.obs;

  void reset() {
    postItems.value = [];
    postsPageInfo.value = PageInfo();
    postsTotalCount.value = 0;
  }

  void onPostCreateTap() {
    Get.dialog(SimpleDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
      title: Row(children: [
        Expanded(
          child: Stack(alignment: AlignmentDirectional.center, children: [
            const Text('Tạo bài viết'),
            Positioned(
              right: 0,
              top: 0,
              child: Ink(
                decoration: ShapeDecoration(
                  color: Colors.grey.withOpacity(0.25),
                  shape: const CircleBorder(),
                ),
                child: IconButton(
                  splashRadius: 20,
                  icon: const Icon(Icons.close),
                  onPressed: Get.back,
                ),
              ),
            ),
          ]),
        )
      ]),
      children: [
        const Divider(thickness: 1.0),
        Row(children: [
          // avatar
          SizedBox(
            width: 40,
            height: 40,
            child: UserAvatar(
              avatarUrl: currentUser.avatarUrl,
              lastSeen: currentUser.lastSeen,
            ),
          ),
          const SizedBox(width: 5),
          // name + location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserName(name: currentUser.name),
                1 == 2
                    ? TextButton.icon(
                        onPressed: () {},
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(0)),
                        ),
                        icon: const Icon(Icons.location_pin),
                        label: const Text('location'),
                      )
                    : const Text(''),
              ],
            ),
          ),
        ]),
        TextField(
          controller: postTextTEC,
          decoration: const InputDecoration(
            hintText: 'Bạn đang nghĩ gì?',
            border: InputBorder.none,
          ),
          maxLines: 5,
        ),
        Row(children: [
          Expanded(
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))))),
                  onPressed: onPostCreateSubmitTap,
                  child: const Text('Đăng'))),
        ]),
      ],
    ));
  }

  Future<void> onPostCreateSubmitTap() async {
    final created = await dbService.createPostByCreatedByText(
      currentUser.id,
      postTextTEC.value.text.isNotEmpty ? postTextTEC.value.text : null,
    );
    if (created == null) {
      Get.snackbar(
        'Failed:',
        'Could not create post',
        duration: const Duration(seconds: 2),
      );
    } else {
      final postItem = PostItem(
        created,
        initialKey: Key(created.id.toString()),
        onDeleteCallback: () {
          postItems.removeWhere((e) => e.key == Key(created.id.toString()));
          postsTotalCount.value--;
        },
        onRefreshCallBack: () {
          reset();
          fetchPostsByShipmentTransportDeliveryFindingSavingFastCurrentUserIdFirstAfter();
        },
      );
      postItems.insert(0, postItem);
      postsTotalCount.value++;
      postTextTEC.clear();
      Get.back();
      Get.snackbar(
        'Success:',
        'Created post',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void>
      fetchPostsByShipmentTransportDeliveryFindingSavingFastCurrentUserIdFirstAfter() async {
    try {
      var morePosts = await dbService
          .postsByShipmentTransportDeliveryFindingSavingFastCurrentUserIdFirstAfter(
        chipShipment.value,
        chipTransport.value,
        chipDelivery.value,
        chipFinding.value,
        chipSaving.value,
        chipFast.value,
        currentUser.id,
        _limit,
        postsPageInfo.value.endCursor,
      );
      if (morePosts != null) {
        postsTotalCount.value = morePosts.totalCount;
        postsPageInfo.value = morePosts.pageInfo ?? PageInfo();
        postItems.addAll(morePosts.nodes.map((e) => PostItem(
              e,
              initialKey: Key(e.id.toString()),
              onDeleteCallback: () {
                postItems.removeWhere(
                    (element) => element.key == Key(e.id.toString()));
                postsTotalCount.value--;
              },
              onRefreshCallBack: () {
                reset();
                fetchPostsByShipmentTransportDeliveryFindingSavingFastCurrentUserIdFirstAfter();
              },
            )));
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }

  void _scrollListener() {
    if (scrollController.position.maxScrollExtent <= 0) {
      debugPrint(scrollController.position.extentBefore.toString());
    }

    if (scrollController.position.extentAfter < 100) {
      if (!_loadingMore) {
        _loadingMore = true;
        debugPrint('pageInfo: $postsPageInfo}');
        if (postsPageInfo.value.hasNextPage == true) {
          fetchPostsByShipmentTransportDeliveryFindingSavingFastCurrentUserIdFirstAfter();
        }
      }
    } else {
      _loadingMore = false;
    }
  }

  void initPlz() {
    scrollController.addListener(_scrollListener);
    fetchPostsByShipmentTransportDeliveryFindingSavingFastCurrentUserIdFirstAfter();
  }

  void disposePlz() {
    scrollController.removeListener(_scrollListener);
  }

  @override
  void onInit() {
    initPlz();
    super.onInit();
  }

  @override
  void dispose() {
    disposePlz();
    super.dispose();
  }
}
