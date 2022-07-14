import 'package:flutter/material.dart';

class UserName extends StatelessWidget {
  const UserName({Key? key, this.name = '', this.onTap}) : super(key: key);
  final String? name;
  final VoidCallback? onTap;

  Widget _name({String? name}) {
    return Text(
      name ?? '',
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _name(name: name),
    );
  }
}
