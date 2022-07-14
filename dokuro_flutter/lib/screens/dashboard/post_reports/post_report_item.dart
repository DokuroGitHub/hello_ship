import 'package:dokuro_flutter/controllers/dashboard/post_reports/post_report_item_controller.dart';
import 'package:dokuro_flutter/helpers/string_helper.dart';
import 'package:dokuro_flutter/models/constants/report_status.dart';
import 'package:dokuro_flutter/models/constants/report_type.dart';
import 'package:dokuro_flutter/models/reported_user.dart';
import 'package:dokuro_flutter/screens/dashboard/post_reports/reported_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostReportItem extends StatelessWidget {
  final ReportedUser initialReportedUser;
  const PostReportItem(
    this.initialReportedUser, {
    Key? initialKey,
  }) : super(key: initialKey);

  @override
  Widget build(BuildContext context) {
    debugPrint('$runtimeType, id: ${initialReportedUser.id}, key: $key');
    final reportedUserItemController =
        ReportedUserItemController(initialReportedUser);
    reportedUserItemController.initPlz();

    return GestureDetector(
      onTap: () {
        Get.to(() => ReportedUserScreen(
              initialReportedUser,
              onUpdateCallback: (updated) {
                reportedUserItemController.reportedUser.update((val) {
                  val?.status = updated.status;
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
              _type(initialReportedUser.type),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Flexible(child: Text('id: ${initialReportedUser.id}')),
                        Flexible(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text('post id: ${initialReportedUser.postId}'),
                        )),
                      ]),
                      Text(stringHelper.dateTimeToDurationString(
                          initialReportedUser.createdAt)),
                    ],
                  ),
                ),
              ),
              Flexible(
                  child: Obx(() => _status(
                      reportedUserItemController.reportedUser.value.status))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _type(String type) {
    var color = Colors.grey;
    if (type == ReportType.content18) {
      color = Colors.red;
    } else if (type == ReportType.violence) {
      color = Colors.orange;
    } else if (type == ReportType.nationalSecret) {
      color = Colors.yellow;
    } else if (type == ReportType.others) {
      color = Colors.blue;
    }
    return Container(
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0), color: color),
      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      child: Center(child: Text(type)),
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
