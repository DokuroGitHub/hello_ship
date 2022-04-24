import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/sample_controller.dart';

class SampleScreen extends StatelessWidget {
  const SampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('SampleScreen');
    final sampleController = Get.find<SampleController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Text(
              "SampleScreen",
            ),
          ],
        ),
      ),
    );
  }
}
