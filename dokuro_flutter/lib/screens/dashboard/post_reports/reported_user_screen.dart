import 'package:dokuro_flutter/controllers/dashboard/post_reports/reported_user_controller.dart';
import 'package:dokuro_flutter/helpers/string_helper.dart';
import 'package:dokuro_flutter/models/constants/report_status.dart';
import 'package:dokuro_flutter/models/reported_user.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/post/post_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportedUserScreen extends StatelessWidget {
  final ReportedUser initialReportedUser;
  final Function(ReportedUser updated)? onUpdateCallback;
  final Function? onRefreshCallBack;
  const ReportedUserScreen(
    this.initialReportedUser, {
    Key? initialKey,
    this.onUpdateCallback,
    this.onRefreshCallBack,
  }) : super(key: initialKey);

  @override
  Widget build(BuildContext context) {
    debugPrint('$runtimeType build');
    final postReportController = ReportedUserController(
      initialReportedUser,
      onUpdateCallback: onUpdateCallback,
      onRefreshCallBack: onRefreshCallBack,
    );
    postReportController.initPlz();

    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Obx(() => _actions(postReportController)),
            const SizedBox(height: 10),
            _id(postReportController),
            const SizedBox(height: 10),
            _userId(postReportController),
            const SizedBox(height: 10),
            _createdBy(postReportController),
            const SizedBox(height: 10),
            _createdAt(postReportController),
            const SizedBox(height: 10),
            _text(postReportController),
            const SizedBox(height: 10),
            _postId(postReportController),
            const SizedBox(height: 10),
            _conversationId(postReportController),
            const SizedBox(height: 10),
            _type(postReportController),
            const SizedBox(height: 10),
            _status(postReportController),
            const SizedBox(height: 10),
            Obx(() => _postItem(postReportController)),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0.0,
      title: Text('Chi tiết báo cáo',
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

  Widget _actions(ReportedUserController postReportController) {
    if (postReportController.reportedUser.value.status ==
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
                    // chipBlockUser 30 days
                    Obx(() => GestureDetector(
                          onTap: () {
                            postReportController.chipBlockUserByDays.value =
                                postReportController
                                            .chipBlockUserByDays.value !=
                                        30
                                    ? 30
                                    : 0;
                          },
                          child: postReportController
                                      .chipBlockUserByDays.value ==
                                  30
                              ? const Chip(
                                  backgroundColor: Colors.blue,
                                  avatar: CircleAvatar(
                                    child: Icon(Icons.check_circle_outline,
                                        color: Colors.green),
                                  ),
                                  label: Text('Khoá user 30 ngày'),
                                )
                              : const Chip(
                                  backgroundColor: Colors.grey,
                                  avatar: CircleAvatar(
                                    child: Icon(Icons.radio_button_unchecked),
                                  ),
                                  label: Text('Khoá user 30 ngày'),
                                ),
                        )),
                    // chipBlockUser 365 days
                    Obx(() => GestureDetector(
                          onTap: () {
                            postReportController.chipBlockUserByDays.value =
                                postReportController
                                            .chipBlockUserByDays.value !=
                                        365
                                    ? 365
                                    : 0;
                          },
                          child: postReportController
                                      .chipBlockUserByDays.value ==
                                  365
                              ? const Chip(
                                  backgroundColor: Colors.blue,
                                  avatar: CircleAvatar(
                                    child: Icon(Icons.check_circle_outline,
                                        color: Colors.green),
                                  ),
                                  label: Text('Khoá user 365 ngày'),
                                )
                              : const Chip(
                                  backgroundColor: Colors.grey,
                                  avatar: CircleAvatar(
                                    child: Icon(Icons.radio_button_unchecked),
                                  ),
                                  label: Text('Khoá user 365 ngày'),
                                ),
                        )),
                    // chipBlockUser 365*100 days
                    Obx(() => GestureDetector(
                          onTap: () {
                            postReportController.chipBlockUserByDays.value =
                                postReportController
                                            .chipBlockUserByDays.value !=
                                        365 * 100
                                    ? 365 * 100
                                    : 0;
                          },
                          child: postReportController
                                      .chipBlockUserByDays.value ==
                                  365 * 100
                              ? const Chip(
                                  backgroundColor: Colors.blue,
                                  avatar: CircleAvatar(
                                    child: Icon(Icons.check_circle_outline,
                                        color: Colors.green),
                                  ),
                                  label: Text('Khoá user 100 năm'),
                                )
                              : const Chip(
                                  backgroundColor: Colors.grey,
                                  avatar: CircleAvatar(
                                    child: Icon(Icons.radio_button_unchecked),
                                  ),
                                  label: Text('Khoá user 100 năm'),
                                ),
                        )),
                    // chipDeletePost
                    Obx(() => GestureDetector(
                          onTap: () {
                            postReportController.chipDeletePost.value =
                                !postReportController.chipDeletePost.value;
                          },
                          child: postReportController.chipDeletePost.value
                              ? const Chip(
                                  backgroundColor: Colors.blue,
                                  avatar: CircleAvatar(
                                    child: Icon(Icons.check_circle_outline,
                                        color: Colors.green),
                                  ),
                                  label: Text('Xoá bài viết'),
                                )
                              : const Chip(
                                  backgroundColor: Colors.grey,
                                  avatar: CircleAvatar(
                                    child: Icon(Icons.radio_button_unchecked),
                                  ),
                                  label: Text('Xoá bài viết'),
                                ),
                        )),
                  ]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: postReportController.onFinishTap,
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

  Widget _id(ReportedUserController postReportController) {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.numbers),
      const SizedBox(width: 10),
      Flexible(
          child: Text('id: ${postReportController.reportedUser.value.id}')),
    ]);
  }

  Widget _userId(ReportedUserController postReportController) {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.report),
      const SizedBox(width: 10),
      Flexible(
          child: Text(
              'Reported user id: ${postReportController.reportedUser.value.userId}')),
    ]);
  }

  Widget _createdBy(ReportedUserController postReportController) {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.person),
      const SizedBox(width: 10),
      Flexible(
          child: Text(
              'Reporter: ${postReportController.reportedUser.value.createdBy}')),
    ]);
  }

  Widget _createdAt(ReportedUserController postReportController) {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.date_range_outlined),
      const SizedBox(width: 10),
      Flexible(
          child: Text(
              'Created at: ${stringHelper.dateTimeToStringV2(postReportController.reportedUser.value.createdAt)}')),
    ]);
  }

  Widget _text(ReportedUserController postReportController) {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.edit),
      const SizedBox(width: 10),
      Flexible(
          child: Text('text: ${postReportController.reportedUser.value.text}')),
    ]);
  }

  Widget _postId(ReportedUserController postReportController) {
    if (postReportController.reportedUser.value.postId == 0) {
      return const SizedBox();
    }
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.post_add),
      const SizedBox(width: 10),
      Flexible(
          child: Text(
              'Post id: ${postReportController.reportedUser.value.postId}')),
    ]);
  }

  Widget _conversationId(ReportedUserController postReportController) {
    if (postReportController.reportedUser.value.conversationId.isEmpty) {
      return const SizedBox();
    }
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.groups),
      const SizedBox(width: 10),
      Flexible(
          child: Text(
              'Conversation id: ${postReportController.reportedUser.value.conversationId}')),
    ]);
  }

  Widget _type(ReportedUserController postReportController) {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.category),
      const SizedBox(width: 10),
      Flexible(
          child: Text('Type: ${postReportController.reportedUser.value.type}')),
    ]);
  }

  Widget _status(ReportedUserController postReportController) {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.timeline),
      const SizedBox(width: 10),
      Flexible(
          child: Obx(() => Text(
              'Status: ${postReportController.reportedUser.value.status}'))),
    ]);
  }

  Widget _postItem(ReportedUserController postReportController) {
    if (postReportController.post.value.id == 0) {
      return const SizedBox();
    }
    if (postReportController.post.value.deletedAt != null) {
      return const Text('Bài viết đã bị xoá');
    }
    return PostItem(
      postReportController.post.value,
      initialKey: Key(postReportController.post.value.id.toString()),
    );
  }
}
