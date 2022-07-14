import 'dart:async';

import 'package:dokuro_flutter/controllers/dashboard_controller.dart';
import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/helpers/string_helper.dart';
import 'package:dokuro_flutter/models/constants/participant_role.dart';
import 'package:dokuro_flutter/models/message.dart';
import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/models/participant.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/screens/dashboard/chats/conversation_item.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_name.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:dokuro_flutter/models/conversation.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

class ChatsController {
  final currentUser = Get.find<AuthController>().authedUser.value!;
  final scrollController = Get.find<DashboardController>().controller;
  final dbService = Get.find<DbService>();
  final int _limit = 2;

  final messageTextFC = FocusNode();
  final messageTextTEC = TextEditingController();
  final messageToTEC = TextEditingController();

  Rx<Status> status = Status.loading.obs;
  bool _loadingMore = false;

  // new messages
  Rx<Users> users = Users().obs;
  RxList<User> usersList = RxList();
  Rx<Conversation> conversation = Conversation().obs;
  Rx<Messages> messages = Messages().obs;

  // conversationsByCurrentUser
  RxList<Conversation> conversationsByCurrentUser = RxList();
  // conversations
  RxList<ConversationItem> conversationItems = RxList();
  Rx<PageInfo> conversationsPageInfo = PageInfo().obs;
  RxInt conversationsTotalCount = 0.obs;

  void _scrollListener() {
    if (scrollController.position.maxScrollExtent <= 0) {
      debugPrint(scrollController.position.extentBefore.toString());
    }

    if (scrollController.position.extentAfter < 100) {
      if (!_loadingMore) {
        _loadingMore = true;
        debugPrint('conversationsPageInfo: $conversationsPageInfo}');
        if (conversationsPageInfo.value.hasNextPage == true) {
          fetchConversationsByFirstAfter();
        }
      }
    } else {
      _loadingMore = false;
    }
  }

  void initPlz() {
    scrollController.addListener(_scrollListener);
    fetchConversationsByCurrentUser();
    fetchConversationsByFirstAfter();
  }

  void disposePlz() {
    scrollController.removeListener(_scrollListener);
  }

  final Function _unOrdDeepEq = const DeepCollectionEquality.unordered().equals;

  Future<void> fetchConversationsByCurrentUser() async {
    try {
      var items = await dbService.conversationsByCurrentUser();
      if (items.isNotEmpty) {
        conversationsByCurrentUser.value = items;
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }

  Future<void> fetchConversationsByFirstAfter() async {
    try {
      var moreItems = await dbService.conversationsByCurrentUserFirstAfter(
        _limit,
        conversationsPageInfo.value.endCursor,
      );
      if (moreItems != null) {
        conversationsTotalCount.value = moreItems.totalCount;
        conversationsPageInfo.value = moreItems.pageInfo ?? PageInfo();
        conversationItems.addAll(moreItems.nodes.map((e) => ConversationItem(
              e,
              initialKey: Key(e.id),
              onTapCallBack: () {},
            )));
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }

  void onConversationCreateTap() {
    messageToTEC.text = '';
    messageTextTEC.text = '';

    Get.dialog(
      Obx(
        () => SimpleDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Tin nhắn mới'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  splashRadius: 15,
                  color: Colors.blue,
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
            children: [
              const SizedBox(height: 5),
              // Đến + userList + messageToTEC
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Đến
                const Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(top: 4, right: 6),
                    child: Text('Đến:'),
                  ),
                ),
                // usersList + messageToTEC
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // usersList
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 100),
                        child: SingleChildScrollView(
                          reverse: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...usersList.map(
                                (element) => Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.4),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              element.name,
                                              style: const TextStyle(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 18.0,
                                            width: 18.0,
                                            child: IconButton(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              color: Colors.blue,
                                              icon: const Icon(Icons.close,
                                                  size: 18.0),
                                              splashRadius: 12,
                                              onPressed: () {
                                                usersList.remove(element);
                                                _fetchConversationByUsersList();
                                              },
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // messageToTEC
                      TextField(
                        controller: messageToTEC,
                        onChanged: (val) {
                          _fetchUsersBySearch();
                        },
                        decoration: const InputDecoration(
                          hintText: 'Aa',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 5),
              const Divider(thickness: 1.0),
              // Gợi ý / users / tin nhan
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 200),
                child: Column(children: [
                  users.value.nodes.isNotEmpty
                      ? ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: SingleChildScrollView(
                            child: Obx(
                              () => Column(
                                children: [
                                  ...users.value.nodes.map(
                                    (e) => GestureDetector(
                                      onTap: () {
                                        final item = usersList.firstWhereOrNull(
                                            (element) => element.id == e.id);
                                        if (item == null) {
                                          usersList.add(e);
                                          messageToTEC.clear();
                                          users.value = Users();
                                          _fetchConversationByUsersList();
                                        }
                                      },
                                      child: Row(children: [
                                        SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: UserAvatar(
                                            avatarUrl: e.avatarUrl,
                                            lastSeen: e.lastSeen,
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0),
                                            child: UserName(name: e.name),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : usersList.isEmpty
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Expanded(
                                      child: Column(children: const [
                                    SizedBox(height: 5),
                                    Text(
                                      'Gợi ý',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    Divider(color: Colors.blue, thickness: 3),
                                  ])),
                                  const Spacer(),
                                ])
                          : Column(
                              children: [
                                SizedBox(
                                  height: 200,
                                  child: SingleChildScrollView(
                                    reverse: true,
                                    child: conversation.value.id.isNotEmpty
                                        ? Column(
                                            children: [
                                              Text(
                                                  'Tạo lúc ${stringHelper.dateTimeToStringV5(conversation.value.createdAt)}'),
                                              const SizedBox(height: 50),
                                              _buildMessages(),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              _conversationPhoto(),
                                              UserName(
                                                name:
                                                    _conversationTitleByUsersList(),
                                              ),
                                              const SizedBox(height: 100),
                                            ],
                                          ),
                                  ),
                                ),
                                // messageText
                                Row(children: [
                                  Expanded(
                                    child: TextField(
                                      controller: messageTextTEC,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        hintText: 'Aa',
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0))),
                                        isDense: true, // Added this
                                        contentPadding: EdgeInsets.all(15),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: _onMessageSendTap,
                                    icon: const Icon(Icons.send,
                                        color: Colors.blue),
                                  ),
                                ]),
                              ],
                            ),
                ]),
              ),
            ]),
      ),
      //barrierDismissible: false,
    );
  }

  Participant? participantByUserId(String userId) {
    return conversation.value.participants?.nodes
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

  String _conversationTitleByUsersList() {
    List<User> usersDesu = [];
    usersDesu.addAll(usersList);
    // remove me
    usersDesu.removeWhere((element) => element.id == currentUser.id);
    List<String> names = usersDesu.map((e) => e.name).toList();
    return stringHelper.conversationTitleByNames(names);
  }

  Widget _conversationPhoto() {
    if (usersList.isEmpty) {
      return const UserAvatar(avatarUrl: '');
    }
    if (usersList.length == 1) {
      return UserAvatar(
        avatarUrl: usersList.first.avatarUrl,
        lastSeen: usersList.first.lastSeen,
      );
    } else {
      return UserAvatar(
        avatarUrl: usersList[0].avatarUrl,
        avatarUrl2: usersList[1].avatarUrl,
        isOnline: true,
      );
    }
  }

  Widget _receivedMessageWidget(Message message) {
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
                    avatarUrl:
                        participantByUserId(message.createdBy)?.user?.avatarUrl,
                    lastSeen:
                        participantByUserId(message.createdBy)?.user?.lastSeen,
                    onTap: () {
                      debugPrint('tap photo, myUserId: ${message.createdBy}');
                    }),
                // message content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // nickname??name
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Flexible(
                            child: UserName(
                          name: nameByUserId(message.createdBy),
                        ))
                      ]),
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
                Expanded(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // dua text vs attachments ve phai
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // text
                        if (message.text.trim().isNotEmpty)
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(Get.context!).size.width *
                                        .6),
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
                                    MediaQuery.of(Get.context!).size.width *
                                        .6),
                            child: const SizedBox(width: 20, height: 20)),
                      ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageItem(Message message) {
    if (message.createdBy == currentUser.id) {
      return _sentMessageWidget(message);
    }
    return _receivedMessageWidget(message);
  }

  Widget _buildMessages() {
    return Obx(() => Column(children: [
          ...messages.value.nodes.map((e) => _messageItem(e)).toList(),
        ]));
  }

  Future<void> _onMessageSendTap() async {
    status.value = Status.loading;
    try {
      messageTextFC.unfocus();
      if (conversation.value.id.isEmpty) {
        // create
        Conversation? created;
        if (usersList.length == 1) {
          final conversationId = stringHelper.conversationIdBy2UserIds(
              currentUser.id, usersList.first.id);
          created = await dbService.createdConversationByIdCreatedBy(
            conversationId,
            currentUser.id,
          );
        } else {
          created = await dbService.createConversationByCreatedBy(
            currentUser.id,
          );
        }
        if (created != null) {
          conversation.value = created;
          for (var item in usersList) {
            final participantDesu = await dbService
                .createParticipantByConversationIdUserIdCreatedByRole(
              conversation.value.id,
              item.id,
              currentUser.id,
            );
            if (participantDesu == null) {
              debugPrint('ko tao dc participant');
            }
          }
          final participantDesu = await dbService
              .createParticipantByConversationIdUserIdCreatedByRole(
            conversation.value.id,
            currentUser.id,
            currentUser.id,
            role: ParticipantRole.roleAdmin,
          );
          if (participantDesu == null) {
            debugPrint('ko tao dc participant');
          }
        }
      }
      if (conversation.value.id.isEmpty) {
        debugPrint('ko tao dc conversation');
        return;
      }
      final created =
          await dbService.createMessageByConversationIdCreatedByText(
        conversation.value.id,
        currentUser.id,
        messageTextTEC.text.isNotEmpty ? messageTextTEC.text : null,
      );
      if (created != null) {
        messageTextTEC.clear();
        await _fetchMessagesByConversationId();
        await fetchConversationsByFirstAfter();
        // messages.update((val) {
        //   val?.nodes.add(created);
        // });
      }
      if (1 == 2) _fetchMessagesByConversationId();
    } catch (e) {
      debugPrint('e: $e');
    }
    status.value = Status.ready;
  }

  Future<void> _fetchUsersBySearch() async {
    try {
      if (messageToTEC.value.text.isNotEmpty) {
        var item = await dbService.usersBySearch(
          messageToTEC.value.text,
        );
        if (item != null) {
          item.nodes.removeWhere((element) => element.id == currentUser.id);
          users.value = item;
          return;
        }
      }
      users.value = Users();
    } catch (e) {
      debugPrint('e: $e');
    }
  }

  Future<void> _fetchConversationByUsersList() async {
    try {
      if (usersList.isEmpty) {
        conversation.value = Conversation();
        return;
      }
      List<String> userIds = [];
      userIds.addAll(usersList.map((e) => e.id));
      userIds.add(currentUser.id);
      debugPrint('userIds: $userIds');
      final existed = conversationsByCurrentUser.firstWhereOrNull((e) {
        final ids = e.participants?.nodes.map((e) => e.userId).toList();
        debugPrint('ids: $ids');
        return _unOrdDeepEq(ids, userIds);
      });
      if (existed != null) {
        final item = await dbService.conversationById(existed.id);
        if (item != null) {
          conversation.value = item;
          if (conversation.value.messages != null) {
            messages.value = conversation.value.messages!;
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('e: $e');
    }
    conversation.value = Conversation();
  }

  Future<void> _fetchMessagesByConversationId() async {
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
}
