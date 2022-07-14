import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:flutter/material.dart';

class ContactItem extends StatelessWidget {
  final User initialUser;
  final Function()? onTapCallBack;
  const ContactItem(
    this.initialUser, {
    Key? initialKey,
    this.onTapCallBack,
  }) : super(key: initialKey);

  @override
  Widget build(BuildContext context) {
    debugPrint('ContactItem, id: ${initialUser.id}, key: $key');
    return GestureDetector(
      onTap: onTapCallBack,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Theme.of(context).cardColor),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              UserAvatar(
                avatarUrl: initialUser.avatarUrl,
                lastSeen: initialUser.lastSeen,
              ),
              const SizedBox(width: 10.0),
              // name + rating + address
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(initialUser.name)),
                        Text(initialUser.phone),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                                initialUser.userAddress?.details ?? 'test'))
                      ],
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        _roleWidget(initialUser.role),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _roleWidget(String role) {
    if (role == 'role_admin') {
      return const Text('Admin', style: TextStyle(color: Colors.red));
    } else if (role == 'role_shipper') {
      return const Text('Shipper', style: TextStyle(color: Colors.green));
    } else if (role == 'role_user') {
      return const Text('Người dùng', style: TextStyle(color: Colors.blue));
    } else {
      return Container();
    }
  }
}
