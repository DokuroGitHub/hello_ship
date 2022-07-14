import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/data/user_query.dart';
import 'package:dokuro_flutter/models/constants/report_status.dart';
import 'package:dokuro_flutter/models/unblock_request.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

class UnblockRequestController {
  final UnblockRequest initialUnblockRequest;
  final Key? initialKey;
  final Function(UnblockRequest updated)? onUpdateCallback;
  final Function? onRefreshCallBack;

  UnblockRequestController(
    this.initialUnblockRequest, {
    this.initialKey,
    this.onUpdateCallback,
    this.onRefreshCallBack,
  });

  final _client = Get.find<DbService>().client!;
  final User currentUser = Get.find<AuthController>().authedUser.value!;

  Rx<Status> status = Status.ready.obs;
  // unblockRequest
  Rx<UnblockRequest> unblockRequest = UnblockRequest().obs;

  // chips
  RxBool chipUnblockUser = false.obs;

  void initPlz() {
    debugPrint(
        '$runtimeType, id: ${initialUnblockRequest.id}, key: $initialKey');
    unblockRequest.value = initialUnblockRequest;
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
    if (chipUnblockUser.value) {
      await _updateUserByIdBlockedUntil();
    }
    final updated = await _updateUnblockRequestByIdStatusCheckedByCheckedAt();
    if (updated == null) {
      Get.snackbar(
        'Failed:',
        'Could not update',
        duration: const Duration(seconds: 2),
      );
    } else {
      unblockRequest.update((val) {
        val?.status = updated.status;
        val?.checkedBy = updated.checkedBy;
        val?.checkedAt = updated.checkedAt;
      });
      //onRefreshCallBack?.call();
      onUpdateCallback?.call(unblockRequest.value);
      debugPrint('-------------unblockRequest.value: ${unblockRequest.value}');
      Get.back();
      Get.snackbar(
        'Success:',
        'Updated successfully',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<User?> _updateUserByIdBlockedUntil() async {
    try {
      var result = await _client.mutate(
        MutationOptions(
          document: gql(UserQuery.updateUserByIdBlockedUntil),
          variables: {
            'id': unblockRequest.value.createdBy,
            'blockedUntil': null,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_updateUserByIdBlockedUntil: ${result.exception}');
        return null;
      }
      final map = result.data?['updateUser']?['user'];
      debugPrint('_updateUserByIdBlockedUntil, map: $map');
      return convertMapToUser(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<UnblockRequest?>
      _updateUnblockRequestByIdStatusCheckedByCheckedAt() async {
    try {
      var result = await _client.mutate(
        MutationOptions(
          document:
              gql(UserQuery.updateUnblockRequestByIdStatusCheckedByCheckedAt),
          variables: {
            'id': unblockRequest.value.id,
            'status': ReportStatus.checked,
            'checkedBy': currentUser.id,
            'checkedAt': DateTime.now().toIso8601String(),
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_updateUnblockRequestByIdStatusCheckedByCheckedAt: ${result.exception}');
        return null;
      }
      final map = result.data?['updateUnblockRequest']?['unblockRequest'];
      debugPrint(
          '_updateUnblockRequestByIdStatusCheckedByCheckedAt, map: $map');
      return convertMapToUnblockRequest(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }
}
