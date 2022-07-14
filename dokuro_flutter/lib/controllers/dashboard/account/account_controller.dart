import 'dart:async';

import 'package:dokuro_flutter/services/auth_service.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:dokuro_flutter/controllers/dashboard_controller.dart';
import 'package:dokuro_flutter/helpers/string_helper.dart';
import 'package:dokuro_flutter/models/feedback.dart';
import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/models/user_address.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/post/post_item.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountController {
  final authService = Get.find<AuthService>();
  final User? initialUser;
  AccountController(
    this.initialUser,
  );

  Rx<Status> status = Status.loading.obs;
  final scrollController = Get.find<DashboardController>().controller;
  User currentUser = Get.find<AuthController>().authedUser.value!;
  final dbService = Get.find<DbService>();
  bool _loadingMore = false;
  final int _limit = 2;

  RxBool showShipperInfo = false.obs;
  RxBool showBiosEdit = false.obs;
  RxBool doneBiosEdit = false.obs;
  Rx<User> user = User().obs;
  Rx<Feedbacks> feedbacks = Feedbacks().obs;
  Rx<TextEditingController> biosTEC = TextEditingController().obs;
  Rx<TextEditingController> nameTEC = TextEditingController().obs;
  Rx<TextEditingController> addressDetailsTEC = TextEditingController().obs;
  Rx<TextEditingController> addressStreetTEC = TextEditingController().obs;
  Rx<TextEditingController> addressDisctrictTEC = TextEditingController().obs;
  Rx<TextEditingController> addressCityTEC = TextEditingController().obs;
  Rx<TextEditingController> birthdateTEC = TextEditingController().obs;
  Rx<TextEditingController> avatarUrlTEC = TextEditingController().obs;
  Rx<TextEditingController> coverUrlTEC = TextEditingController().obs;

  // posts
  RxList<PostItem> postItems = RxList();
  Rx<PageInfo> postsPageInfo = PageInfo().obs;
  RxInt postsTotalCount = 0.obs;

  void _scrollListener() {
    if (scrollController.position.maxScrollExtent <= 0) {
      debugPrint(scrollController.position.extentBefore.toString());
    }

    if (scrollController.position.extentAfter < 100) {
      if (!_loadingMore) {
        _loadingMore = true;
        debugPrint('pageInfo: $postsPageInfo}');
        if (postsPageInfo.value.hasNextPage == true) {
          fetchPostsByUserIdCurrentUserIdFirstAfter();
        }
      }
    } else {
      _loadingMore = false;
    }
  }

  void resetPosts() {
    postItems.value = [];
    postsPageInfo.value = PageInfo();
    postsTotalCount.value = 0;
  }

  void initPlz() {
    if (initialUser != null) {
      user.value = initialUser!;
    } else {
      user.value = currentUser;
    }
    fetchUserByIdForAccountScreen();
    fetchPostsByUserIdCurrentUserIdFirstAfter();
    scrollController.addListener(_scrollListener);
  }

  void disposePlz() {
    scrollController.removeListener(_scrollListener);
  }

  Future<void> fetchUserByIdForAccountScreen() async {
    try {
      final userDesu = await dbService.userByIdForAccountScreen(currentUser.id);
      if (userDesu != null) {
        user.value = userDesu;
        if (user.value.feedbacks != null) {
          feedbacks.value = user.value.feedbacks!;
        }
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }

  Future<void> fetchPostsByUserIdCurrentUserIdFirstAfter() async {
    try {
      var morePosts = await dbService.postsByUserIdCurrentUserIdFirstAfter(
        user.value.id,
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
                resetPosts();
                fetchPostsByUserIdCurrentUserIdFirstAfter();
              },
            )));
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }

  void onUserEditTap() {
    biosTEC.value.text = user.value.bios;
    Get.dialog(
      SimpleDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        title: Row(children: [
          Expanded(
            child: Stack(alignment: AlignmentDirectional.topCenter, children: [
              Text(AppLocalizations.of(Get.context!).editProfileCap),
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
                    onPressed: _onEditCloseTap,
                  ),
                ),
              ),
            ]),
          )
        ]),
        children: [
          const Divider(thickness: 1.0),
          // avatarUrl
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(child: Text(AppLocalizations.of(Get.context!).avatarCap)),
            Flexible(
                child: TextButton(
                    onPressed: _onUserAvatarUrlEditTap,
                    child: Text(AppLocalizations.of(Get.context!).editCap))),
          ]),
          Column(children: [
            Obx(() => UserAvatar(
                  avatarUrl: user.value.avatarUrl,
                  lastSeen: user.value.lastSeen,
                )),
          ]),
          // coverUrl
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(child: Text(AppLocalizations.of(Get.context!).coverCap)),
            Flexible(
                child: TextButton(
                    onPressed: _onUserCoverUrlEditTap,
                    child: Text(AppLocalizations.of(Get.context!).editCap))),
          ]),
          Column(children: [
            Obx(() => Image(
                  image: NetworkImage(user.value.coverUrl),
                  errorBuilder: (_, __, ___) =>
                      Image.asset('assets/images/welcome_image.png'),
                )),
          ]),
          // bios
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(child: Text(AppLocalizations.of(Get.context!).biosCap)),
            Obx(
              () => Flexible(
                child: showBiosEdit.value
                    ? TextButton(
                        onPressed: () {
                          showBiosEdit.value = false;
                        },
                        child: Text(AppLocalizations.of(Get.context!).cancel),
                      )
                    : TextButton(
                        onPressed: () {
                          biosTEC.value.text = user.value.bios;
                          showBiosEdit.value = true;
                        },
                        child: Text(AppLocalizations.of(Get.context!).editCap),
                      ),
              ),
            ),
          ]),
          Obx(
            () => Column(children: [
              showBiosEdit.value
                  ? Column(children: [
                      // biosTF
                      TextField(
                        controller: biosTEC.value,
                        onChanged: (val) {
                          biosTEC.update((val) {});
                        },
                        enabled: !doneBiosEdit.value,
                        decoration: const InputDecoration(
                          hintText: 'Mô tả về bạn',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        ),
                        maxLength: 101,
                        maxLines: 3,
                      ),
                      //btn
                      Obx(
                        () => doneBiosEdit.value
                            ? Column(mainAxisSize: MainAxisSize.min, children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Flexible(child: Text('Đã lưu')),
                                          Flexible(child: Icon(Icons.check)),
                                        ]),
                                    Flexible(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showBiosEdit.value = false;
                                          doneBiosEdit.value = false;
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(Colors
                                                    .blueAccent.shade700)),
                                        child: const Text('Tiếp tục'),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(thickness: 1),
                              ])
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        showBiosEdit.value = false;
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(Colors
                                                  .grey
                                                  .withOpacity(0.3))),
                                      child: Text(
                                          AppLocalizations.of(Get.context!)
                                              .cancel),
                                    ),
                                    const SizedBox(width: 5),
                                    Obx(
                                      () => ElevatedButton(
                                        onPressed: biosTEC.value.text ==
                                                user.value.bios
                                            ? null
                                            : _onUserBiosEditSubmitTap,
                                        style: biosTEC.value.text ==
                                                user.value.bios
                                            ? ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.grey))
                                            : ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.blueAccent
                                                            .shade700)),
                                        child: Text(
                                            AppLocalizations.of(Get.context!)
                                                .saveCap),
                                      ),
                                    ),
                                  ]),
                      ),
                    ])
                  : Text(user.value.bios),
            ]),
          ),
          // Chỉnh sửa phần giới thiệu
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
                child: Text(
                    AppLocalizations.of(Get.context!).editIntroductionCap)),
            Flexible(
                child: TextButton(
                    onPressed: _onUserInforEditTap,
                    child: Text(AppLocalizations.of(Get.context!).editCap))),
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // name
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.account_circle_outlined),
              Flexible(
                  child: Obx(() => Text(
                      '${AppLocalizations.of(Get.context!).nameCap}: ${user.value.name}'))),
            ]),
            const SizedBox(height: 10),
            // userAddress
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.house),
              Flexible(
                child: Obx(() => Text(
                    '${AppLocalizations.of(Get.context!).addressCap}: ${stringHelper.addressToStringV3(userAddress: user.value.userAddress)}')),
              ),
            ]),
            const SizedBox(height: 10),
            // birthdate
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.cake),
              Flexible(
                child: Obx(() => Text(
                    '${AppLocalizations.of(Get.context!).birthdateCap}: ${stringHelper.dateTimeToStringV2(user.value.birthdate)}')),
              ),
            ]),
          ]),
          const SizedBox(height: 10),
          // btn
          Row(children: [
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                      Colors.blueAccent.withOpacity(0.2)),
                ),
                onPressed: Get.back,
                child: Text(
                  AppLocalizations.of(Get.context!).editIntroductionCap,
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            )
          ]),
        ],
      ),
    );
  }

  void _onUserAvatarUrlEditTap() {
    Get.dialog(
      SimpleDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        title: Row(children: [
          Expanded(
            child: Stack(alignment: AlignmentDirectional.center, children: [
              const Text('Cập nhật ảnh đại diện'),
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
          // chọn ảnh
          Row(children: [
            Expanded(
              child: InkWell(
                onTap: _onUserAvatarUrlSelectTap,
                child: Row(children: [
                  Ink(
                    width: 50,
                    height: 50,
                    decoration: ShapeDecoration(
                      color: Colors.grey.withOpacity(0.25),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.photo_library),
                  ),
                  const SizedBox(width: 5),
                  const Flexible(child: Text('Chọn ảnh')),
                ]),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          // tải ảnh lên
          Row(children: [
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Row(children: [
                  Ink(
                    width: 50,
                    height: 50,
                    decoration: ShapeDecoration(
                      color: Colors.grey.withOpacity(0.25),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.upload),
                  ),
                  const SizedBox(width: 5),
                  const Flexible(child: Text('Tải ảnh lên')),
                ]),
              ),
            ),
          ]),
          const Divider(thickness: 1),
          // gỡ
          Row(children: [
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Row(children: [
                  Ink(
                    width: 50,
                    height: 50,
                    decoration: ShapeDecoration(
                      color: Colors.grey.withOpacity(0.25),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.delete),
                  ),
                  const SizedBox(width: 5),
                  const Flexible(child: Text('Gỡ')),
                ]),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  void _onUserCoverUrlEditTap() {
    Get.dialog(
      SimpleDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        title: Row(children: [
          Expanded(
            child: Stack(alignment: AlignmentDirectional.center, children: [
              const Text('Cập nhật ảnh bìa'),
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
          // chọn ảnh
          Row(children: [
            Expanded(
              child: InkWell(
                onTap: _onUserCoverUrlSelectTap,
                child: Row(children: [
                  Ink(
                    width: 50,
                    height: 50,
                    decoration: ShapeDecoration(
                      color: Colors.grey.withOpacity(0.25),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.photo_library),
                  ),
                  const SizedBox(width: 5),
                  const Flexible(child: Text('Chọn ảnh')),
                ]),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          // tải ảnh lên
          Row(children: [
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Row(children: [
                  Ink(
                    width: 50,
                    height: 50,
                    decoration: ShapeDecoration(
                      color: Colors.grey.withOpacity(0.25),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.upload),
                  ),
                  const SizedBox(width: 5),
                  const Flexible(child: Text('Tải ảnh lên')),
                ]),
              ),
            ),
          ]),
          const Divider(thickness: 1),
          // gỡ
          Row(children: [
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Row(children: [
                  Ink(
                    width: 50,
                    height: 50,
                    decoration: ShapeDecoration(
                      color: Colors.grey.withOpacity(0.25),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.delete),
                  ),
                  const SizedBox(width: 5),
                  const Flexible(child: Text('Gỡ')),
                ]),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  void _onUserAvatarUrlSelectTap() {
    avatarUrlTEC.value.text = user.value.coverUrl;
    Get.dialog(SimpleDialog(children: [
      TextField(
        controller: avatarUrlTEC.value,
      ),
      ElevatedButton(
          onPressed: () async {
            final updated = await dbService.updateUserByIdAvatarUrl(
              user.value.id,
              avatarUrlTEC.value.text.isNotEmpty
                  ? avatarUrlTEC.value.text
                  : null,
            );
            if (updated == null) {
              Get.snackbar(
                'Failed:',
                'Could not update avatar image',
                duration: const Duration(seconds: 2),
              );
            } else {
              user.update((val) {
                val?.avatarUrl = updated.avatarUrl;
              });
              Get.close(2);
              Get.snackbar(
                'Success:',
                'Updated avatar image',
                duration: const Duration(seconds: 2),
              );
            }
          },
          child: const Text('Save')),
    ]));
  }

  void _onUserCoverUrlSelectTap() {
    coverUrlTEC.value.text = user.value.coverUrl;
    Get.dialog(SimpleDialog(children: [
      TextField(
        controller: coverUrlTEC.value,
      ),
      ElevatedButton(
          onPressed: () async {
            final updated = await dbService.updateUserByIdCoverUrl(
              user.value.id,
              coverUrlTEC.value.text.isNotEmpty ? coverUrlTEC.value.text : null,
            );
            if (updated == null) {
              Get.snackbar(
                'Failed:',
                'Could not update cover image',
                duration: const Duration(seconds: 2),
              );
            } else {
              user.update((val) {
                val?.coverUrl = updated.coverUrl;
              });
              Get.close(2);
              Get.snackbar(
                'Success:',
                'Updated cover image',
                duration: const Duration(seconds: 2),
              );
            }
          },
          child: const Text('Save')),
    ]));
  }

  void _onUserInforEditTap() {
    nameTEC.value.text = user.value.name;
    addressDetailsTEC.value.text = user.value.userAddress?.details ?? '';
    addressStreetTEC.value.text = user.value.userAddress?.street ?? '';
    addressDisctrictTEC.value.text = user.value.userAddress?.district ?? '';
    addressCityTEC.value.text = user.value.userAddress?.city ?? '';
    birthdateTEC.value.text =
        stringHelper.dateTimeToStringV0(user.value.birthdate);
    Get.dialog(
      SimpleDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        title: Row(children: [
          Expanded(
            child: Stack(alignment: AlignmentDirectional.topCenter, children: [
              Text(AppLocalizations.of(Get.context!).editIntroductionCap),
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
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ),
            ]),
          )
        ]),
        children: [
          const Divider(thickness: 1.0),
          // name
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.account_circle_outlined),
            Flexible(
                child: Text('${AppLocalizations.of(Get.context!).nameCap}:')),
          ]),
          TextField(
            controller: nameTEC.value,
            onChanged: (val) {
              nameTEC.update((val) {});
            },
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Tên hiển thị',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            maxLength: 50,
            maxLines: 1,
          ),
          // userAddress
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.house),
            Flexible(
              child: Text(AppLocalizations.of(Get.context!).addressCap),
            ),
          ]),
          const Text('Details: '),
          TextField(
            controller: addressDetailsTEC.value,
            onChanged: (val) {
              addressDetailsTEC.update((val) {});
            },
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Địa chỉ chi tiết',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            maxLength: 100,
            maxLines: 2,
          ),
          const Text('Street: '),
          TextField(
            controller: addressStreetTEC.value,
            onChanged: (val) {
              addressStreetTEC.update((val) {});
            },
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Đường',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            maxLength: 10,
            maxLines: 1,
          ),
          const Text('District:'),
          TextField(
            controller: addressDisctrictTEC.value,
            onChanged: (val) {
              addressDisctrictTEC.update((val) {});
            },
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Quận',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            maxLength: 10,
            maxLines: 1,
          ),
          const Text('City:'),
          TextField(
            controller: addressCityTEC.value,
            onChanged: (val) {
              addressCityTEC.update((val) {});
            },
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Tỉnh/thành phố',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            maxLength: 10,
            maxLines: 1,
          ),
          // birthdate
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.cake),
            Flexible(
                child: Obx(() => Text(
                    '${AppLocalizations.of(Get.context!).birthdateCap}: ${stringHelper.dateTimeToStringV2(stringHelper.stringToDateTimeV0(birthdateTEC.value.text))}'))),
          ]),
          TextField(
            controller: birthdateTEC.value,
            onChanged: (val) {
              birthdateTEC.update((val) {});
            },
            textInputAction: TextInputAction.next,
            onTap: () async {
              var dateTime = await Get.dialog<DateTime>(DatePickerDialog(
                initialDate: user.value.birthdate ?? DateTime.now(),
                firstDate: DateTime(0),
                lastDate: DateTime(3000),
              ));
              if (dateTime != null) {
                birthdateTEC.update((val) {
                  val?.text = stringHelper.dateTimeToStringV0(dateTime);
                });
              }
            },
            decoration: const InputDecoration(
              hintText: '30/12/2000',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            maxLength: 100,
            maxLines: 1,
          ),

          // saveCap
          Row(children: [
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                onPressed: _onUserIntroductionEditSubmitTap,
                child: Text(AppLocalizations.of(Get.context!).saveCap),
              ),
            )
          ]),
        ],
      ),
    );
  }

  Future<void> _onUserBiosEditSubmitTap() async {
    final updated = await dbService.updateUserByIdBios(
      user.value.id,
      biosTEC.value.text.isNotEmpty ? biosTEC.value.text : null,
    );
    if (updated == null) {
      Get.snackbar(
        'Failed:',
        'Could not update bios',
        duration: const Duration(seconds: 2),
      );
    } else {
      user.update((val) {
        val?.bios = updated.bios;
      });
      doneBiosEdit.value = true;
      Get.snackbar(
        'Success:',
        'Updated bios',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> _onUserIntroductionEditSubmitTap() async {
    final updated = await dbService.updateUserByIdNameBirthdate(
      user.value.id,
      nameTEC.value.text.isNotEmpty ? nameTEC.value.text : null,
      stringHelper.stringToDateTimeV0(birthdateTEC.value.text),
    );
    final updated2 = await dbService.updateUserAddressByUserId(UserAddress(
      userId: user.value.id,
      details: addressDetailsTEC.value.text,
      street: addressStreetTEC.value.text,
      district: addressDisctrictTEC.value.text,
      city: addressCityTEC.value.text,
    ));
    if (updated == null || updated2 == null) {
      Get.snackbar(
        'Failed:',
        'Could not update',
        duration: const Duration(seconds: 2),
      );
    } else {
      user.update((val) {
        val?.name = updated.name;
        val?.birthdate = updated.birthdate;
        val?.userAddress = updated2;
      });
      Get.back();
      Get.snackbar(
        'Success:',
        'Updated successfully',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> _onEditCloseTap() async {
    if (biosTEC.value.text == user.value.bios) {
      Get.back();
    } else {
      Get.dialog(SimpleDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        titlePadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        title: Row(children: [
          Expanded(
            child:
                Stack(alignment: AlignmentDirectional.centerStart, children: [
              const Text('Thay đổi chưa lưu'),
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
          // avatar + (name / location) + actions
          const Text('Hệ thống sẽ không lưu các thay đổi của bạn'),
          const SizedBox(height: 10),
          // actions
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Flexible(
              child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))))),
                onPressed: () => Get.close(1),
                child: const Text('Tiếp tục chỉnh sửa'),
              ),
            ),
            Flexible(
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))))),
                onPressed: () => Get.close(2),
                child: const Text('Bỏ'),
              ),
            ),
          ]),
        ],
      ));
    }
  }

  Future<void> confirmSignOut() async {
    final bool didRequestSignOut = await showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Text(AppLocalizations.of(context).logout),
            content: Text(AppLocalizations.of(context).logoutAreYouSure),
            actions: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                ElevatedButton(
                  child: Text(AppLocalizations.of(context).cancel),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text(AppLocalizations.of(context).ok),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ]),
            ],
          ),
        ) ??
        false;
    if (didRequestSignOut == true) {
      await _signOut();
    }
  }

  Future<void> _signOut() async {
    try {
      authService.signOut();
    } catch (e) {
      // show dialog
      debugPrint('$runtimeType _signOut e: $e');
      unawaited(showDialog(
        context: Get.context!,
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
}
