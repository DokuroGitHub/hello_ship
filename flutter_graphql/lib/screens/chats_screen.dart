import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('ChatsScreen');

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Text(
              "ChatsScreen",
            ),
          ],
        ),
      ),
    );
  }
}
