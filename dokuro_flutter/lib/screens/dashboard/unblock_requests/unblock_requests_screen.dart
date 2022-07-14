import 'package:dokuro_flutter/controllers/dashboard/unblock_requests/unblock_requests_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnblockRequestsScreen extends StatefulWidget {
  const UnblockRequestsScreen({Key? key}) : super(key: key);

  @override
  State<UnblockRequestsScreen> createState() => _UnblockRequestsScreenState();
}

class _UnblockRequestsScreenState extends State<UnblockRequestsScreen> {
  final unblockRequestsController = UnblockRequestsController();

  @override
  void initState() {
    unblockRequestsController.initPlz();
    super.initState();
  }

  @override
  dispose() {
    unblockRequestsController.disposePlz();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('$runtimeType build');
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        controller: unblockRequestsController.scrollController,
        child: Column(
          children: [
            _items(),
            Obx(() => _more()),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      title: Text('Yêu cầu mở khoá',
          style: Theme.of(context).appBarTheme.titleTextStyle),
      actions: [
        if (1 == 2)
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
          ),
      ],
    );
  }

  Widget _items() {
    debugPrint('_items');
    return Obx(() => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return unblockRequestsController.requestItems[index];
          },
          itemCount: unblockRequestsController.requestItems.length,
        ));
  }

  Widget _more() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      unblockRequestsController.requestItems.length !=
              unblockRequestsController.requestsTotalCount.value
          ? TextButton(
              onPressed: () {
                unblockRequestsController
                    .fetchUnblockRequestsByConditionFirstAfter();
              },
              child: const Text('Xem thêm'),
            )
          : const SizedBox(),
      Text(
          '${unblockRequestsController.requestItems.length}/${unblockRequestsController.requestsTotalCount.value}'),
    ]);
  }
}
