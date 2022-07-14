import 'package:dokuro_flutter/helpers/string_helper.dart';
import 'package:dokuro_flutter/models/conversation.dart';
import 'package:dokuro_flutter/models/message.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_name.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/dashboard/messages_controller.dart';
import 'package:get/get.dart';

class MessagesScreen extends StatelessWidget {
  final Conversation initialConversation;
  final Function(Conversation conversation)? onUpdateCallBack;
  final Function? onDeleteCallBack;
  final Function? onRefetchCallBack;
  const MessagesScreen(
    this.initialConversation, {
    Key? key,
    this.onUpdateCallBack,
    this.onDeleteCallBack,
    this.onRefetchCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('ChatsScreen');
    final messagesController = Get.put(MessagesController(
      initialConversation,
      onUpdateCallBack: onUpdateCallBack,
      onDeleteCallBack: onDeleteCallBack,
      onRefetchCallBack: onRefetchCallBack,
    ));

    return Scaffold(
      appBar: _appBar(messagesController),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            // messages
            _messages(messagesController),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomSheet: _chatInputFieldWidget(messagesController),
    );
  }

  AppBar _appBar(MessagesController messagesController) {
    return AppBar(
      elevation: 0.0,
      title: Text('Tin nhắn',
          style: Theme.of(Get.context!).appBarTheme.titleTextStyle),
      actions: [
        _actions(messagesController),
      ],
    );
  }

  Widget _receivedMessageWidget(
      Message message, MessagesController messagesController) {
    return GestureDetector(
      onTap: () {
        debugPrint(
            'body, attachments.length: ${message.messageAttachments?.nodes.length}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 5),
        child: Column(
          children: [
            const SizedBox(width: 15),
            // createdAt
            Text(
              stringHelper.dateTimeToStringV5(message.createdAt),
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // sender avatar
                UserAvatar(
                    avatarUrl: messagesController
                        .participantByUserId(message.createdBy)
                        ?.user
                        ?.avatarUrl,
                    lastSeen: messagesController
                        .participantByUserId(message.createdBy)
                        ?.user
                        ?.lastSeen,
                    onTap: () {
                      debugPrint('tap photo, myUserId: ${message.createdBy}');
                    }),
                // message content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // nickname??name
                    UserName(
                      name: messagesController.nameByUserId(message.createdBy),
                    ),
                    // text
                    if (message.text.trim().isNotEmpty)
                      Container(
                        constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(Get.context!).size.width * .6),
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.50),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                        child: Text(message.text.replaceAll('\n', '\n')),
                      ),
                    // attachments
                    Container(
                        constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(Get.context!).size.width * .6),
                        child: const SizedBox(width: 20, height: 20)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sentMessageWidget(Message message) {
    return GestureDetector(
      onTap: () {
        debugPrint(
            'body, attachments.length: ${message.messageAttachments?.nodes.length}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 5),
        child: Column(
          children: [
            //T createdAt
            Text(stringHelper.dateTimeToStringV5(message.createdAt),
                overflow: TextOverflow.ellipsis),
            Row(
              // day ve ben phai
              mainAxisAlignment: MainAxisAlignment.end,
              // dua createdAt ve bottom
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(width: 15),
                // message content
                Column(
                    mainAxisSize: MainAxisSize.min,
                    // dua text vs attachments ve phai
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // text
                      if (message.text.trim().isNotEmpty)
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(Get.context!).size.width * .6),
                          padding: const EdgeInsets.all(15.0),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                            ),
                          ),
                          child: Text(message.text.replaceAll('\\n', '\n')),
                        ),
                      // attachments
                      Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(Get.context!).size.width * .6),
                          child: const SizedBox(width: 20, height: 20)),
                    ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageItem(Message message, MessagesController messagesController) {
    if (message.createdBy == messagesController.currentUser.id) {
      return _sentMessageWidget(message);
    }
    return _receivedMessageWidget(message, messagesController);
  }

  Widget _messages(MessagesController messagesController) {
    return Obx(() => Column(children: [
          ...messagesController.messages.value.nodes
              .map((e) => _messageItem(e, messagesController))
              .toList(),
        ]));
  }

  Widget _chatInputFieldWidget(MessagesController messagesController) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Theme.of(Get.context!).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 32,
                  color: const Color(0xFF087949).withOpacity(0.08),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  InkWell(
                    child: const Icon(
                      Icons.add_circle,
                      color: Colors.green,
                    ),
                    onTap: () {
                      //_showBottom = true;
                    },
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.mic, color: Colors.green),
                  const SizedBox(width: 2),
                  // input
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      //_attachedFiles(),
                      Row(
                        children: [
                          Icon(
                            Icons.sentiment_satisfied_alt_outlined,
                            color: Theme.of(Get.context!)
                                .textTheme
                                .bodyText1
                                ?.color
                                ?.withOpacity(0.64),
                          ),
                          const SizedBox(width: 6 / 4),
                          Expanded(
                            child: TextField(
                              focusNode: messagesController.focusNode,
                              controller: messagesController.inputController,
                              decoration: const InputDecoration(
                                hintText: "Type message",
                                border: InputBorder.none,
                              ),
                              autocorrect: false,
                              //onEditingComplete: _node.nextFocus,
                            ),
                          ),
                          Icon(
                            Icons.attach_file,
                            color: Theme.of(Get.context!)
                                .textTheme
                                .bodyText1
                                ?.color
                                ?.withOpacity(0.64),
                          ),
                          const SizedBox(width: 6 / 4),
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Theme.of(Get.context!)
                                .textTheme
                                .bodyText1
                                ?.color
                                ?.withOpacity(0.64),
                          ),
                        ],
                      ),
                    ]),
                  )),
                  const SizedBox(width: 2),
                  // send
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.green),
                    onPressed: messagesController.sendMessage,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _actions(MessagesController messagesController) {
    return PopupMenuButton<String>(
      tooltip: 'Actions',
      icon: Icon(
        Icons.more_horiz,
        color: Theme.of(Get.context!).appBarTheme.titleTextStyle?.color,
      ),
      onSelected: (selected) {
        if (selected == 'view') {
          messagesController.onViewTap();
        }
        if (selected == 'edit') {
          messagesController.onEditTap();
        }
        if (selected == 'delete') {
          messagesController.onDeleteTap();
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          if (messagesController.canIView())
            const PopupMenuItem<String>(
              value: 'view',
              child: Text('View'),
            ),
          if (messagesController.canIEdit())
            const PopupMenuItem<String>(
              value: 'edit',
              child: Text('Edit'),
            ),
          if (messagesController.canIDelete())
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete'),
            ),
        ];
      },
    );
  }
}
