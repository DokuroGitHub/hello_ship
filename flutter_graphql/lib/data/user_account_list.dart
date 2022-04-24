import '../models/user_account.dart';

class UserAccountList {
  List<UserAccount> list = [];

  int _id = 1;

  UserAccountList() {
    for (int i = 1; i < 5; i++) {
      add(UserAccount(
        userId: 'user_${_id++}',
        email: 'user_$i@gmail.com',
        password: 'pass',
        role: 'role_user',
      ));
    }
    list.elementAt(0).role = 'role_admin';
    list.elementAt(1).role = 'role_shipper';
  }

  UserAccount? add(UserAccount userAccount) {
    list.add(userAccount);
    return userAccount;
  }

  removeUserAccount(String userId) {
    list.removeWhere((item) => item.userId == userId);
  }

  List<UserAccount> get adminList =>
      list.where((item) => item.role == 'role_admin').toList();
}

UserAccountList userAccountList = UserAccountList();
