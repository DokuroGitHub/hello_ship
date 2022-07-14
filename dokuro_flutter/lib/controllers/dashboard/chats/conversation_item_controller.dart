import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/models/conversation.dart';
import 'package:dokuro_flutter/models/participant.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:get/get.dart';

class ConversationItemController {
  final Conversation initialConversation;
  final Key? initialKey;
  final Function()? onTapCallBack;
  ConversationItemController(
    this.initialConversation, {
    this.initialKey,
    this.onTapCallBack,
  });

  final User currentUser = Get.find<AuthController>().authedUser.value!;

  Rx<Status> status = Status.ready.obs;

  void initPlz() {}

  void disposePlz() {}

  String conversationTitlePlz() {
    if (initialConversation.title.isNotEmpty) {
      return initialConversation.title;
    }
    String title = '';
    List<Participant> participants = [];
    participants.addAll(initialConversation.participants?.nodes ?? []);
    // remove me
    participants.removeWhere((element) => element.userId == currentUser.id);
    var participants1 = participants.take(2).toList();
    var participants2 = participants.skip(2).take(10).toList();
    if (participants2.isNotEmpty) {
      for (var e in participants2) {
        if (e.nickname.isNotEmpty) {
          title += '${e.nickname}, ';
        } else if (e.user?.name.isNotEmpty ?? false) {
          title += '${e.user!.name}, ';
        }
      }
    }
    if (participants1.length == 2) {
      title +=
          '${participants1[0].nickname.isNotEmpty ? participants1[0].nickname : participants1[0].user?.name ?? ''} and ${participants1[1].nickname.isNotEmpty ? participants1[1].nickname : participants1[1].user?.name ?? ''}';
    } else {
      if (participants1.length == 1) {
        title += participants1[0].nickname.isNotEmpty
            ? participants1[0].nickname
            : participants1[0].user?.name ?? '';
      }
    }
    debugPrint('title: $title');
    return title;
  }

  void onViewTap() {
    Get.dialog(
      SimpleDialog(
        titlePadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, .0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        title: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Stack(alignment: AlignmentDirectional.topCenter, children: [
              const Text('Conversation'),
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
          ),
        ]),
        children: [
          const Divider(thickness: 1.0),
          // title
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.title),
            Flexible(child: Text('Title: ${initialConversation.title}')),
          ]),
          const SizedBox(height: 5),
          // description
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.description),
            Flexible(
                child: Text('Description: ${initialConversation.description}')),
          ]),

          const Divider(thickness: 1.0),
          // action buttons
          Row(children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Đóng'),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
