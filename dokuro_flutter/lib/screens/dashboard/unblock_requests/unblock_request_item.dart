import 'package:dokuro_flutter/controllers/dashboard/unblock_requests/unblock_request_item_controller.dart';
import 'package:dokuro_flutter/helpers/string_helper.dart';
import 'package:dokuro_flutter/models/constants/report_status.dart';
import 'package:dokuro_flutter/models/unblock_request.dart';
import 'package:dokuro_flutter/screens/dashboard/unblock_requests/unblock_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnblockRequestItem extends StatelessWidget {
  final UnblockRequest initialUnblockRequest;
  const UnblockRequestItem(
    this.initialUnblockRequest, {
    Key? initialKey,
  }) : super(key: initialKey);

  @override
  Widget build(BuildContext context) {
    debugPrint('$runtimeType, id: ${initialUnblockRequest.id}, key: $key');
    final unblockRequestItemController =
        UnblockRequestItemController(initialUnblockRequest);
    unblockRequestItemController.initPlz();

    return GestureDetector(
      onTap: () {
        Get.to(() => UnblockRequestScreen(
              initialUnblockRequest,
              onUpdateCallback: (updated) {
                unblockRequestItemController.unblockRequest.value = updated;
                unblockRequestItemController.unblockRequest.update((val) { 
                  val?.status = updated.status;
                  val?.checkedBy = updated.checkedBy;
                  val?.checkedAt = updated.checkedAt;
                });
              },
            ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Theme.of(context).cardColor),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // createdAt
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Flexible(
                            child: Text('id: ${initialUnblockRequest.id}')),
                      ]),
                      Text(stringHelper.dateTimeToDurationString(
                          initialUnblockRequest.createdAt)),
                    ],
                  ),
                ),
              ),
              // status
              Flexible(
                  child: Obx(() => _status(unblockRequestItemController
                      .unblockRequest.value.status))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _status(String status) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: status == ReportStatus.checked ? Colors.green : Colors.grey,
      ),
      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      child: Center(child: Text(status)),
    );
  }
}
