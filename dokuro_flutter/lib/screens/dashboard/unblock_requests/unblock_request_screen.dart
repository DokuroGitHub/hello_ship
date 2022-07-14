import 'package:dokuro_flutter/controllers/dashboard/unblock_requests/unblock_request_controller.dart';
import 'package:dokuro_flutter/helpers/string_helper.dart';
import 'package:dokuro_flutter/models/constants/report_status.dart';
import 'package:dokuro_flutter/models/unblock_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnblockRequestScreen extends StatefulWidget {
  final UnblockRequest initialUnblockRequest;
  final Function(UnblockRequest updated)? onUpdateCallback;
  final Function? onRefreshCallBack;
  const UnblockRequestScreen(
    this.initialUnblockRequest, {
    Key? initialKey,
    this.onUpdateCallback,
    this.onRefreshCallBack,
  }) : super(key: initialKey);

  @override
  State<UnblockRequestScreen> createState() => _UnblockRequestScreenState();
}

class _UnblockRequestScreenState extends State<UnblockRequestScreen> {
  late final unblockRequestController = UnblockRequestController(
    widget.initialUnblockRequest,
    onUpdateCallback: widget.onUpdateCallback,
  );

  @override
  void initState() {
    unblockRequestController.initPlz();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('$runtimeType build');
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Obx(() => _actions()),
            const SizedBox(height: 10),
            _id(),
            const SizedBox(height: 10),
            _createdBy(),
            const SizedBox(height: 10),
            _createdAt(),
            const SizedBox(height: 10),
            _editedAt(),
            const SizedBox(height: 10),
            _text(),
            const SizedBox(height: 10),
            _status(),
            const SizedBox(height: 10),
            _checkedBy(),
            const SizedBox(height: 10),
            _checkedAt(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0.0,
      title: Text('Chi tiết yêu cầu',
          style: Theme.of(Get.context!).appBarTheme.titleTextStyle),
      actions: [
        if (1 == 2)
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: Theme.of(Get.context!).appBarTheme.titleTextStyle?.color,
          ),
      ],
    );
  }

  Widget _actions() {
    if (unblockRequestController.unblockRequest.value.status ==
        ReportStatus.unchecked) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(spacing: 8, runSpacing: 8, children: [
                    const Text(
                      'Xử lý:',
                      style: TextStyle(color: Colors.blue),
                    ),
                    // chip
                    Obx(() => GestureDetector(
                          onTap: () {
                            unblockRequestController.chipUnblockUser.value =
                                !unblockRequestController.chipUnblockUser.value;
                          },
                          child: unblockRequestController.chipUnblockUser.value
                              ? const Chip(
                                  backgroundColor: Colors.blue,
                                  avatar: CircleAvatar(
                                    child: Icon(Icons.check_circle_outline,
                                        color: Colors.green),
                                  ),
                                  label: Text('Mở Khoá'),
                                )
                              : const Chip(
                                  backgroundColor: Colors.grey,
                                  avatar: CircleAvatar(
                                    child: Icon(Icons.radio_button_unchecked),
                                  ),
                                  label: Text('Mở Khoá user'),
                                ),
                        )),
                  ]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: unblockRequestController.onFinishTap,
            child: const Text('Hoàn tất'),
          ),
        ],
      );
    }
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.green,
        ),
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check),
            Text('Đã xử lý'),
          ],
        ));
  }

  Widget _id() {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.numbers),
      const SizedBox(width: 10),
      Flexible(
          child:
              Text('id: ${unblockRequestController.unblockRequest.value.id}')),
    ]);
  }

  Widget _createdBy() {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.person),
      const SizedBox(width: 10),
      Flexible(
          child: Text(
              'Reporter: ${unblockRequestController.unblockRequest.value.createdBy}')),
    ]);
  }

  Widget _createdAt() {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.date_range_outlined),
      const SizedBox(width: 10),
      Flexible(
          child: Text(
              'Created at: ${stringHelper.dateTimeToStringV2(unblockRequestController.unblockRequest.value.createdAt)}')),
    ]);
  }

  Widget _editedAt() {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.date_range_outlined),
      const SizedBox(width: 10),
      Flexible(
          child: Text(
              'Edited at: ${stringHelper.dateTimeToStringV2(unblockRequestController.unblockRequest.value.editedAt)}')),
    ]);
  }

  Widget _text() {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.edit),
      const SizedBox(width: 10),
      Flexible(
          child: Text(
              'text: ${unblockRequestController.unblockRequest.value.text}')),
    ]);
  }

  Widget _status() {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.timeline),
      const SizedBox(width: 10),
      Flexible(
          child: Obx(() => Text(
              'Status: ${unblockRequestController.unblockRequest.value.status}'))),
    ]);
  }

  Widget _checkedBy() {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.person),
      const SizedBox(width: 10),
      Flexible(
          child: Obx(() => Text(
              'Checked by: ${unblockRequestController.unblockRequest.value.checkedBy}'))),
    ]);
  }

  Widget _checkedAt() {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.date_range_outlined),
      const SizedBox(width: 10),
      Flexible(
          child: Obx(() => Text(
              'Checked at: ${stringHelper.dateTimeToStringV2(unblockRequestController.unblockRequest.value.checkedAt)}'))),
    ]);
  }
}
