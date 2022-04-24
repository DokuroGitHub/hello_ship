import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShipmentsScreen extends StatelessWidget {
  const ShipmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('ShipmentsScreen');

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Text(
              "ShipmentsScreen",
            ),
          ],
        ),
      ),
    );
  }
}
