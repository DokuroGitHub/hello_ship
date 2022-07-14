import 'package:dokuro_flutter/models/post.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/post/post_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostScreen extends StatelessWidget {
  final Post initialPost;
  final Function? onDeleteCallback;
  final Function? onRefreshCallBack;
  const PostScreen(
    this.initialPost, {
    Key? initialKey,
    this.onDeleteCallback,
    this.onRefreshCallBack,
  }) : super(key: initialKey);

  @override
  Widget build(BuildContext context) {
    debugPrint('$runtimeType build');
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PostItem(
              initialPost,
              initialKey: Key(initialPost.id.toString()),
              onDeleteCallback: onDeleteCallback,
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0.0,
      title: Text('Chi tiết',
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
}
