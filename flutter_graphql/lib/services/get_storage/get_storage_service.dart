import 'package:get_storage/get_storage.dart';

class GetStorageService {
  final _box = GetStorage();

  static const String isWelcomeCompletedKey = 'isWelcomeCompletedKey';
  static const String userEmailKey = "userEmailKey";
  static const String userPasswordKey = "userPasswordKey";

  //TODO: set
  Future<void> setIsWelcomeCompleted(bool isWelcomeCompleted) =>
      _box.write(isWelcomeCompletedKey, isWelcomeCompleted);

  Future<void> setToken(String token) async => _box.write('token', token);

  Future<void> clearToken() async => _box.remove('token');

  //TODO: get
  bool getIsWelcomeCompleted() =>
      _box.read<bool>(isWelcomeCompletedKey) ?? false;

  String? getUserEmail() => _box.read<String>(userEmailKey);

  String? getUserPassword() => _box.read<String>(userPasswordKey);

  String? get token => _box.read<String>('token');
}

GetStorageService getStorageService = GetStorageService();
