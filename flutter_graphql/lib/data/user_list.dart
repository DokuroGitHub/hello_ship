import '../models/user.dart';

class UserList {
  List<User> list = [];

  int _id = 1;

  UserList() {
    for (int i = 1; i < 5; i++) {
      add(User(
        email: 'user_$i@gmail.com',
        createdAt: DateTime.now(),
        role: 'role_user',
      ));
    }
    list.elementAt(0).role = 'role_admin';
    list.elementAt(1).role = 'role_shipper';
  }

  User? add(User user) {
    user.id = user.id == '' ? 'user_${_id++}' : user.id;
    list.add(user);
    return user;
  }

  removeUserAccount(String id) {
    list.removeWhere((item) => item.id == id);
  }
}

UserList userList = UserList();
