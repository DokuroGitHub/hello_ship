import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/models/post.dart';
import 'package:dokuro_flutter/models/reported_user.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:get/get.dart';

class ReportedUserController {
  final ReportedUser initialReportedUser;
  final Key? initialKey;
  final Function(ReportedUser updated)? onUpdateCallback;
  final Function? onRefreshCallBack;

  ReportedUserController(
    this.initialReportedUser, {
    this.initialKey,
    this.onUpdateCallback,
    this.onRefreshCallBack,
  });

  final dbService = Get.find<DbService>();
  final User currentUser = Get.find<AuthController>().authedUser.value!;

  Rx<Status> status = Status.ready.obs;
  // reportedUser
  Rx<ReportedUser> reportedUser = ReportedUser().obs;
  // post
  Rx<Post> post = Post().obs;
  // chips
  RxInt chipBlockUserByDays = 0.obs;
  RxBool chipDeletePost = false.obs;

  void initPlz() {
    debugPrint('$runtimeType, id: ${initialReportedUser.id}, key: $initialKey');
    reportedUser.value = initialReportedUser;
    fetchReportedUserById();
  }

  void disposePlz() {}

  Future<void> fetchReportedUserById() async {
    try {
      final item = await dbService.reportedUserById(
        reportedUser.value.id,
      );
      if (item != null) {
        reportedUser.value = item;
        if (reportedUser.value.postId != 0) {
          final item2 = await dbService.postByIdCurrentUserId(
            reportedUser.value.postId,
            currentUser.id,
          );
          if (item2 != null) {
            post.value = item2;
          }
        }
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }

  void onFinishTap() {
    Get.dialog(SimpleDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
      title: Row(children: [
        Expanded(
          child: Stack(alignment: AlignmentDirectional.center, children: [
            const Text('Confirm'),
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
        const Text('Are you sure?'),
        const SizedBox(height: 20),
        // actions
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // cancel
          ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))))),
              onPressed: Get.back,
              child: const Text('Cancel')),
          // ok
          TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))))),
              onPressed: onFinishSubmitTap,
              child: const Text('Ok')),
        ]),
      ],
    ));
  }

  Future<void> onFinishSubmitTap() async {
    if (chipBlockUserByDays.value != 0) {
      await dbService.updateUserByIdBlockedUntil(
        reportedUser.value.userId,
        DateTime.now().add(Duration(days: chipBlockUserByDays.value)),
      );
    }
    if (chipDeletePost.value) {
      final updated = await dbService.updatPostByIdDeletedByDelete(
        reportedUser.value.postId,
        currentUser.id,
      );
      if (updated != null) {
        post.update((val) {
          val?.deletedBy = updated.deletedBy;
          val?.deletedAt = updated.deletedAt;
        });
      }
    }
    final updated = await dbService.updateReportedUserByIdStatus(
      reportedUser.value.id,
    );
    if (updated == null) {
      Get.snackbar(
        'Failed:',
        'Could not update',
        duration: const Duration(seconds: 2),
      );
    } else {
      reportedUser.update((val) {
        val?.status = updated.status;
      });
      //onRefreshCallBack?.call();
      onUpdateCallback?.call(updated);
      Get.back();
      Get.snackbar(
        'Success:',
        'Updated successfully',
        duration: const Duration(seconds: 2),
      );
    }
  }
}
