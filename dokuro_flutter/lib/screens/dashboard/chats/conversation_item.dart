import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/controllers/dashboard/chats/conversation_item_controller.dart';
import 'package:dokuro_flutter/helpers/string_helper.dart';
import 'package:dokuro_flutter/models/conversation.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:dokuro_flutter/screens/dashboard/messages/messages_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationItem extends StatefulWidget {
  final Conversation initialConversation;
  final Function()? onTapCallBack;
  final Function? onDeleteCallBack;
  const ConversationItem(
    this.initialConversation, {
    Key? initialKey,
    this.onTapCallBack,
    this.onDeleteCallBack,
  }) : super(key: initialKey);

  @override
  State<ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  late final conversationItemController = ConversationItemController(
    widget.initialConversation,
    initialKey: widget.key,
    onTapCallBack: widget.onTapCallBack,
  );

  @override
  void initState() {
    conversationItemController.initPlz();
    super.initState();
  }

  @override
  dispose() {
    conversationItemController.disposePlz();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        'ConversationItem, id: ${widget.initialConversation.id}, key: ${widget.key}');
    return GestureDetector(
      onTap: () {
        Get.to(
          () => MessagesScreen(
            widget.initialConversation,
            onUpdateCallBack: (updated) {},
            onDeleteCallBack: () {
              widget.onDeleteCallBack?.call();
            },
            onRefetchCallBack: () {},
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Theme.of(context).focusColor),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Obx(() => conversationItemController.status.value == Status.ready
                  ? Row(
                      children: [
                        _conversationPhoto(conversationItemController),
                        const SizedBox(width: 10),
                        // conversation + datetime + name + message
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    conversationItemController
                                        .conversationTitlePlz(),
                                    style: const TextStyle(
                                        color: Colors.blue, fontSize: 20),
                                  )),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Text(
                                      conversationItemController
                                                  .initialConversation
                                                  .lastMessage !=
                                              null
                                          ? '${conversationItemController.initialConversation.lastMessage?.userByCreatedBy?.name}: ${conversationItemController.initialConversation.lastMessage?.text} · '
                                          : 'Hãy là người đầu tiên tạo tin nhắn',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (conversationItemController
                                          .initialConversation.lastMessage !=
                                      null)
                                    Flexible(
                                      child: Text(stringHelper
                                          .dateTimeToDurationStringShort(
                                              conversationItemController
                                                  .initialConversation
                                                  .lastMessage
                                                  ?.createdAt)),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _conversationPhoto(
      ConversationItemController conversationItemController) {
    if (conversationItemController
            .initialConversation.participants?.nodes.isEmpty ??
        true) {
      return const UserAvatar(avatarUrl: '');
    }
    if (conversationItemController.initialConversation.photoUrl.isNotEmpty) {
      return UserAvatar(
        avatarUrl: conversationItemController.initialConversation.photoUrl,
        lastSeen: conversationItemController
            .initialConversation.lastMessage?.createdAt,
      );
    } else {
      if (conversationItemController
              .initialConversation.participants?.nodes.length ==
          1) {
        return UserAvatar(
          avatarUrl: conversationItemController
              .initialConversation.participants?.nodes.first.user?.avatarUrl,
          lastSeen: conversationItemController
              .initialConversation.participants?.nodes.first.user?.lastSeen,
        );
      } else if (conversationItemController
              .initialConversation.participants?.nodes.length ==
          2) {
        final user = conversationItemController
            .initialConversation.participants?.nodes
            .firstWhere((element) =>
                element.userId != conversationItemController.currentUser.id)
            .user;
        return UserAvatar(
          avatarUrl: user?.avatarUrl,
          lastSeen: user?.lastSeen,
        );
      } else {
        final participants = conversationItemController
            .initialConversation.participants?.nodes
            .where((element) =>
                element.userId != conversationItemController.currentUser.id)
            .toList();
        return UserAvatar(
          avatarUrl: participants?[0].user?.avatarUrl,
          avatarUrl2: participants?[1].user?.avatarUrl,
          lastSeen: conversationItemController
              .initialConversation.lastMessage?.createdAt,
        );
      }
    }
  }
}
