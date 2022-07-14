import 'dart:async';

import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/models/constants/participant_role.dart';
import 'package:dokuro_flutter/models/conversation.dart';
import 'package:dokuro_flutter/models/participant.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:dokuro_flutter/data/conversation_query.dart';
import 'package:dokuro_flutter/models/message.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

class MessagesController extends GetxController {
  final Conversation initialConversation;
  final Function(Conversation conversation)? onUpdateCallBack;
  final Function? onDeleteCallBack;
  final Function? onRefetchCallBack;
  MessagesController(
    this.initialConversation, {
    this.onUpdateCallBack,
    this.onDeleteCallBack,
    this.onRefetchCallBack,
  });

  Rx<Status> status = Status.loading.obs;
  final scrollController = ScrollController();
  final User currentUser = Get.find<AuthController>().authedUser.value!;
  final dbService = Get.find<DbService>();

  var focusNode = FocusNode();
  var inputController = TextEditingController();
  Rx<int> limit = 15.obs;
  Rx<bool> loadingMore = false.obs;
  Rx<Conversation> conversation = Conversation().obs;
  Rx<Participants> participants = Participants().obs;
  Rx<Messages> messages = Messages().obs;

  TextEditingController titleTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();

  bool canIView() {
    return true;
  }

  bool canIEdit() {
    final p = participants.value.nodes
        .firstWhereOrNull((e) => e.userId == currentUser.id);
    final check1 = p?.role == ParticipantRole.roleAdmin;
    if (check1) {
      return true;
    }
    final check2 = p?.role == ParticipantRole.roleMod;
    if (check2) {
      return true;
    }
    final check3 = p?.role == ParticipantRole.roleMember;
    if (check3) {
      return true;
    }
    return false;
  }

  bool canIDelete() {
    final p = participants.value.nodes
        .firstWhereOrNull((e) => e.userId == currentUser.id);
    final check1 = p?.role == ParticipantRole.roleAdmin;
    if (check1) {
      return true;
    }
    final check2 = p?.role == ParticipantRole.roleMod;
    if (check2) {
      return true;
    }
    return false;
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
            const Icon(Icons.notes),
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

  void onDeleteTap() async {
    Get.dialog(
      SimpleDialog(
        titlePadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, .0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Confirm:'),
          ],
        ),
        children: [
          // r u sure
          Row(children: const [
            SizedBox(width: 5),
            Flexible(child: Text('Are you sure to delete this?')),
          ]),
          const SizedBox(height: 10),
          // action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // cancel
              Flexible(
                child: ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              // ok
              Flexible(
                child: TextButton(
                  onPressed: onDeleteSubmitTap,
                  child: const Text('Yes, delete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onEditTap() {
    titleTEC.text = initialConversation.title;
    descriptionTEC.text = initialConversation.description;

    Get.dialog(
      SimpleDialog(
        titlePadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, .0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        title:
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text('Edit:'),
        ]),
        children: [
          // title
          Row(children: [
            const SizedBox(width: 5),
            const Flexible(child: Text('Title: ')),
            Expanded(
              flex: 4,
              child: TextField(
                controller: titleTEC,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  constraints: const BoxConstraints(maxHeight: 35),
                  contentPadding: const EdgeInsets.only(
                      left: 10.0, top: 10, right: 0, bottom: 10),
                  hintText: 'Aa',
                  filled: true,
                  fillColor: Theme.of(Get.context!).bannerTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            const Flexible(child: Text('vnđ')),
          ]),
          const SizedBox(height: 5),
          // description
          Row(children: [
            const SizedBox(width: 5),
            const Flexible(child: Text('Description: ')),
            Expanded(
              flex: 4,
              child: TextField(
                controller: descriptionTEC,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 10.0, top: 10, right: 10, bottom: 10),
                  hintText: 'Description',
                  filled: true,
                  fillColor: Theme.of(Get.context!).bannerTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onEditingComplete: onEditSubmitTap,
              ),
            ),
            const SizedBox(width: 5),
          ]),
          const SizedBox(height: 5),
          // action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // cancel
              Flexible(
                child: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Cancel'),
                ),
              ),
              // ok
              Flexible(
                child: ElevatedButton(
                  onPressed: onEditSubmitTap,
                  child: const Text('Ok'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Participant? participantByUserId(String userId) {
    return participants.value.nodes
        .firstWhereOrNull((element) => element.userId == userId);
  }

  String nameByUserId(String userId) {
    final item = participantByUserId(userId);
    if (item != null) {
      if (item.nickname.isNotEmpty) {
        return item.nickname;
      }
      if (item.user != null && item.user!.name.isNotEmpty) {
        return item.user!.name;
      }
    }
    return '';
  }

  Future<void> fetchConversationById() async {
    try {
      final item = await dbService.conversationById(
        conversation.value.id,
      );
      if (item == null) {
        debugPrint('fetchConversationById, item null');
      } else {
        conversation.value = item;
        if (conversation.value.participants != null) {
          participants.value = conversation.value.participants!;
        }
        if (conversation.value.messages != null) {
          messages.value = conversation.value.messages!;
        }
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }

  Future<void> fetchMessagesByConversationId() async {
    try {
      final item = await dbService.messagesByConversationId(
        conversation.value.id,
      );
      if (item == null) {
        debugPrint('fetchMessagesByConversationId, item null');
      } else {
        messages.value = item;
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }

  Future<void> sendMessage() async {
    status.value = Status.loading;
    try {
      focusNode.unfocus();
      Message message = Message(
        conversationId: conversation.value.id,
        createdBy: currentUser.id,
        text: inputController.text,
        replyTo: 0,
      );
      debugPrint('message: $message');
      var created = await dbService.createMessageByConversationIdCreatedByText(
        message.conversationId,
        message.createdBy,
        message.text.isNotEmpty ? message.text : null,
        message.replyTo != 0 ? message.replyTo : null,
      );
      // success
      inputController.text = '';
      debugPrint('created: $created');
      //fetchMessagesByConversationId();
    } catch (e) {
      debugPrint('e: $e');
    }
    status.value = Status.ready;
  }

  Future<void> onDeleteSubmitTap() async {
    final deleted = await dbService.updateConversationByIdDeletedByDeletedAt(
      initialConversation.id,
      currentUser.id,
    );
    if (deleted == null) {
      Get.snackbar(
        'Failed:',
        'Could not delete conversation',
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.close(2);
      onDeleteCallBack?.call();
      Get.snackbar(
        'Success:',
        'Deleted conversation',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> onEditSubmitTap() async {
    final updated =
        await dbService.updateConversationByIdTitleDescriptionEditedByEditedAt(
      initialConversation.id,
      titleTEC.value.text.isNotEmpty ? titleTEC.value.text : null,
      descriptionTEC.value.text.isNotEmpty ? descriptionTEC.value.text : null,
      currentUser.id,
    );
    if (updated == null) {
      Get.snackbar(
        'Failed:',
        'Could not update conversation',
        duration: const Duration(seconds: 2),
      );
    } else {
      initialConversation.title = updated.title;
      initialConversation.description = updated.description;
      initialConversation.editedBy = updated.editedBy;
      initialConversation.editedAt = updated.editedAt;
      onUpdateCallBack?.call(updated);
      Get.back();
      Get.snackbar(
        'Success:',
        'Updated conversation',
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _subscriptionMessagesByConversationId() {
    debugPrint('subscriptionMessagesByConversationId');
    if (dbService.client == null) {
      return;
    }
    try {
      var subscription = dbService.client!.subscribe(
        SubscriptionOptions(
          document: gql(ConversationQuery.subscriptionMessagesByConversationId),
          variables: {
            "conversationId": conversation.value.id,
          },
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
        final map = result.data?['messagesByConversationId'];
        debugPrint('data: ${result.data}');
        if (map != null) {
          final item = convertMapToMessages(map);
          if (item == null) {
            debugPrint('_subscriptionMessagesByConversationId, item null');
          } else {
            messages.value = item;
          }
        }
      });
    } catch (e) {
      debugPrint('e: $e');
    }
  }

  void initPlz() {
    debugPrint('MessagesController');
    ever(status, (_) {
      debugPrint('status: $status');
    });
    conversation.value = initialConversation;
    if (initialConversation.participants != null) {
      participants.value = initialConversation.participants!;
    }
    if (initialConversation.messages != null) {
      messages.value = initialConversation.messages!;
    }
    fetchConversationById();
    _subscriptionMessagesByConversationId();
    status.value = Status.ready;
  }

  @override
  void onInit() {
    super.onInit();

    initPlz();
  }
}
