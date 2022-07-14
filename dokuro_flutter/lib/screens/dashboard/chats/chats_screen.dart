import 'package:dokuro_flutter/controllers/dashboard/chats/chats_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final chatsController = ChatsController();

  @override
  void initState() {
    chatsController.initPlz();
    super.initState();
  }

  @override
  dispose() {
    chatsController.disposePlz();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ChatsScreen');
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _conversations(),
            Obx(() => _more()),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Ink(
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Colors.blueAccent),
          child: IconButton(
            onPressed: chatsController.onConversationCreateTap,
            icon: const Icon(Icons.post_add, color: Colors.white),
            tooltip: 'Tạo tin nhắn mới',
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      title: Text('Trò chuyện',
          style: Theme.of(Get.context!).appBarTheme.titleTextStyle),
      actions: [if (1 == 2)
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
          color: Theme.of(Get.context!).appBarTheme.titleTextStyle?.color,
        ),
      ],
    );
  }

  Widget _conversations() {
    debugPrint('_contacts');
    return Obx(() => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return chatsController.conversationItems[index];
          },
          itemCount: chatsController.conversationItems.length,
        ));
  }

  Widget _more() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      chatsController.conversationItems.length !=
              chatsController.conversationsTotalCount.value
          ? TextButton(
              onPressed: () {
                chatsController.fetchConversationsByFirstAfter();
              },
              child: const Text('Xem thêm'),
            )
          : const SizedBox(),
      Text(
          '${chatsController.conversationItems.length}/${chatsController.conversationsTotalCount.value}'),
    ]);
  }
}
