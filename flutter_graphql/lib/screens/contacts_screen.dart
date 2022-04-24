import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('ContactsScreen');

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Text(
              "ContactsScreen",
            ),
          ],
        ),
      ),
    );
  }
}
