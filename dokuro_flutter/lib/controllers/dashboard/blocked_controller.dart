import 'dart:async';

import 'package:dokuro_flutter/services/auth_service.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:dokuro_flutter/models/unblock_request.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BlockedController {
  BlockedController();
  final authService = Get.find<AuthService>();
  final dbService = Get.find<DbService>();
  final currentUser = Get.find<AuthController>().authedUser.value!;
  final TextEditingController textTEC = TextEditingController();

  Rx<UnblockRequest> unblockRequest = UnblockRequest().obs;

  void initPlz() {
    fetchUnblockRequestsByCreatedByStatus();
  }

  void viewAgreements() {
    Get.dialog(SimpleDialog(
      titlePadding: const EdgeInsets.all(5),
      contentPadding: const EdgeInsets.all(10),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Agreements',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      children: const [
        Text(
          'Agreement 1:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'Yêu tổ quốc, yêu đồng bào',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          'Agreement 2:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'Học tập tốt, lao động tốt',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          'Agreement 3:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'Đoàn kết tốt, kỉ luật tốt',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          'Agreement 4:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'Giữ gìn vệ sinh thật tốt',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          'Agreement 5:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'Khiêm tốt thật thà dũng cảm',
          style: TextStyle(fontSize: 18),
        ),
      ],
    ));
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
      await authService.signOut();
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

  void onUnblockRequestCreateTap() {
    if (unblockRequest.value.id != 0) {
      textTEC.text = unblockRequest.value.text;
    }
    Get.dialog(SimpleDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
      title: Row(children: [
        Expanded(
          child: Stack(alignment: AlignmentDirectional.center, children: [
            Text(unblockRequest.value.id != 0
                ? 'Chỉnh sửa yêu cầu'
                : 'Tạo yêu cầu mở khoá'),
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
          // name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserName(name: currentUser.name),
                const Text(''),
              ],
            ),
          ),
        ]),
        TextField(
          controller: textTEC,
          decoration: const InputDecoration(
            hintText: 'Ghi chú',
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
                  onPressed: _onUnblockRequestCreateSubmitTap,
                  child:
                      Text(unblockRequest.value.id != 0 ? 'Cập nhật' : 'Gửi'))),
        ]),
      ],
    ));
  }

  Future<void> _onUnblockRequestCreateSubmitTap() async {
    UnblockRequest? item;
    if (unblockRequest.value.id != 0) {
      item = await dbService.updateUnblockRequestByIdTextEditedAt(
        unblockRequest.value.id,
        textTEC.value.text.isNotEmpty ? textTEC.value.text : null,
      );
    } else {
      item = await dbService.createUnblockRequestByText(
        textTEC.value.text.isNotEmpty ? textTEC.value.text : null,
      );
    }
    if (item == null) {
      Get.snackbar(
        'Failed:',
        'Could not send request',
        duration: const Duration(seconds: 2),
      );
    } else {
      unblockRequest.value = item;
      textTEC.clear();
      Get.back();
      Get.snackbar(
        'Success:',
        'Sent request',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> fetchUnblockRequestsByCreatedByStatus() async {
    final items = await dbService.unblockRequestsByCreatedByStatus(
      currentUser.id,
    );
    if (items == null || items.nodes.isEmpty) {
    } else {
      unblockRequest.value = items.nodes.first;
    }
  }
}
