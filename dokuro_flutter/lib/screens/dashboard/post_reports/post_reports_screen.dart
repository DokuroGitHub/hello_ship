import 'package:dokuro_flutter/controllers/dashboard/post_reports/post_reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostReportsScreen extends StatefulWidget {
  const PostReportsScreen({Key? key}) : super(key: key);

  @override
  State<PostReportsScreen> createState() => _PostReportsScreenState();
}

class _PostReportsScreenState extends State<PostReportsScreen> {
  final postReportsController = PostReportsController();

  @override
  void initState() {
    postReportsController.initPlz();
    super.initState();
  }

  @override
  dispose() {
    postReportsController.disposePlz();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('$runtimeType build');
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        controller: postReportsController.scrollController,
        child: Column(
          children: [
            _reports(),
            Obx(() => _more()),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      title: Text('Báo cáo bài viết',
          style: Theme.of(context).appBarTheme.titleTextStyle),
      actions: [if (1 == 2)
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
          color: Theme.of(context).appBarTheme.titleTextStyle?.color,
        ),
      ],
    );
  }

  Widget _reports() {
    debugPrint('_reports');
    return Obx(() => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return postReportsController.reportItems[index];
          },
          itemCount: postReportsController.reportItems.length,
        ));
  }

  Widget _more() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      postReportsController.reportItems.length !=
              postReportsController.reportsTotalCount.value
          ? TextButton(
              onPressed: () {
                postReportsController.fetchReportedUsersByConditionFirstAfter();
              },
              child: const Text('Xem thêm'),
            )
          : const SizedBox(),
      Text(
          '${postReportsController.reportItems.length}/${postReportsController.reportsTotalCount.value}'),
    ]);
  }
}
