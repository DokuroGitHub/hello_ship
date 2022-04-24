import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('PostsScreen');

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Text(
              "PostsScreen",
            ),
          ],
        ),
      ),
    );
  }
}
