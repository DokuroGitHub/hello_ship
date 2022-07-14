import 'package:dokuro_flutter/controllers/dashboard/blocked_controller.dart';
import 'package:dokuro_flutter/helpers/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlockedScreen extends StatelessWidget {
  const BlockedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('$runtimeType build');
    final blockedController = BlockedController();
    blockedController.initPlz();

    return Scaffold(
      appBar: _appbar(blockedController),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            const SizedBox(height: 100),
            const Text(
              'Chúng tôi đã tạm ngừng tài khoản của bạn',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            // blockedUntil
            Text(
              'Đến ${stringHelper.dateTimeToStringV5(blockedController.currentUser.blockedUntil)}'
                  .toUpperCase(),
              style: TextStyle(color: Colors.red.shade800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Tài khoản của bạn hoặc hoạt động trên đó vi phạm Tiêu chuẩn cộng đồng của chúng tôi.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            const Text(
              'Chúng tôi sẽ ẩn tài khoản của bạn với mọi người trên HelloShip và bạn cũng không thể sử dụng tài khoản của mình.',
              style: TextStyle(fontWeight: FontWeight.w100),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Divider(thickness: 2),
          const Text(
            'Nếu bạn cho rằng việc tạm ngừng tài khoản là nhẫm lẫn, chúng tôi có thể hướng dẫn bạn một số bước để phản đối quyết định này.',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: blockedController.onUnblockRequestCreateTap,
            child: Obx(() => Text(blockedController.unblockRequest.value.id != 0
                ? 'Chỉnh sửa yêu cầu'
                : 'Phản đối quyết định')),
          ),
          const SizedBox(height: 10),
        ]),
      ),
    );
  }

  AppBar _appbar(BlockedController blockedController) {
    return AppBar(
      title: const Text(
        'HelloShip',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
      actions: [
        // tro giup
        PopupMenuButton<String>(
          icon: const Text('Trợ giúp'),
          iconSize: 70,
          onSelected: (val) {
            if (val == 'view') {
              blockedController.viewAgreements();
            }
            if (val == 'logout') {
              blockedController.confirmSignOut();
            }
          },
          itemBuilder: (BuildContext context) {
            return const [
              PopupMenuItem<String>(
                value: 'view',
                child: Text('Xem điều khoản'),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                child: Text('Đăng xuất'),
              ),
            ];
          },
        ),
      ],
    );
  }
}
