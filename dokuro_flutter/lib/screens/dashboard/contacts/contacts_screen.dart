import 'package:dokuro_flutter/controllers/dashboard/contacts_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final contactsController = ContactsController();

  @override
  void initState() {
    contactsController.initPlz();
    super.initState();
  }

  @override
  dispose() {
    contactsController.disposePlz();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ContactsScreen');
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        controller: contactsController.scrollController,
        child: Column(
          children: [
            _contacts(),
            Obx(() => _more()),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      title:
          Text('Liên hệ', style: Theme.of(context).appBarTheme.titleTextStyle),
      actions: [if (1 == 2)
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
          color: Theme.of(context).appBarTheme.titleTextStyle?.color,
        ),
      ],
    );
  }

  Widget _contacts() {
    debugPrint('_contacts');
    return Obx(() => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return contactsController.contactItems[index];
          },
          itemCount: contactsController.contactItems.length,
        ));
  }

  Widget _more() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      contactsController.contactItems.length !=
              contactsController.contactsTotalCount.value
          ? TextButton(
              onPressed: () {
                contactsController.fetchUsersByFirstAfter();
              },
              child: const Text('Xem thêm'),
            )
          : const SizedBox(),
      Text(
          '${contactsController.contactItems.length}/${contactsController.contactsTotalCount.value}'),
    ]);
  }
}
