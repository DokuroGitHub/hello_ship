import 'package:flutter/material.dart';

const String defaultPhotoURL =
    'https://yt3.ggpht.com/yti/APfAmoEUl_jqsKc0uhb1z2aakEsBQ7ISQllbZgOgA7lc=s88-c-k-c0x00ffffff-no-rj-mo';

class UserAvatar extends StatelessWidget {
  const UserAvatar(
      {Key? key,
      this.isOnline = false,
      this.avatarUrl,
      this.avatarUrl2,
      this.onTap,
      this.lastSeen})
      : super(key: key);

  final bool isOnline;
  final DateTime? lastSeen;
  final String? avatarUrl;
  final String? avatarUrl2;
  final VoidCallback? onTap;

  Widget _circleAvatar(String? photoURL, String? photoURL2) {
    NetworkImage? img;
    NetworkImage? img2;
    if (photoURL != null) {
      try {
        img = NetworkImage(photoURL.isNotEmpty ? photoURL : defaultPhotoURL);
      } catch (e) {
        debugPrint('e: $e');
      }
    }
    if (photoURL2 != null) {
      try {
        img2 = NetworkImage(photoURL2.isNotEmpty ? photoURL2 : defaultPhotoURL);
      } catch (e) {
        debugPrint('e: $e');
      }
    }
    if (img2 != null) {
      return SizedBox(
        width: 50,
        height: 50,
        child: Stack(children: [
          Positioned(
            right: 0,
            top: 0,
            child: CircleAvatar(
              backgroundImage: img,
              radius: 17.0,
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: CircleAvatar(
              backgroundImage: img2,
              radius: 17.0,
            ),
          ),
        ]),
      );
    }
    return CircleAvatar(
      backgroundImage: img,
      radius: 25.0,
    );
  }

  bool _checkIsOnlineByLastSeen() {
    if (lastSeen == null) {
      return false;
    }
    if (lastSeen!
            .compareTo(DateTime.now().subtract(const Duration(seconds: 30))) >
        0) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // tim myUser tu myUserId
    return GestureDetector(
      onTap: onTap,
      child: // avatar + dot isOnline
          Stack(children: [
        _circleAvatar(avatarUrl, avatarUrl2),
        if (isOnline || _checkIsOnlineByLastSeen())
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
                border:
                    Border.all(color: Theme.of(context).canvasColor, width: 2),
              ),
            ),
          ),
      ]),
    );
  }
}
