import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

const refreshToken = 'refreshToken';

class StorageService extends GetxService {
  late final GetStorage _box;

  Future<StorageService> initPlz() async {
    debugPrint('$runtimeType delays 2 sec');
    await GetStorage.init();
    _box = GetStorage();
    //await 2.delay();
    debugPrint('$runtimeType ready!');
    return this;
  }

  dynamic read(String key) => _box.read(key);
  Future<void> write(String key, dynamic value) => _box.write(key, value);
  Future<void> remove(String key) => _box.remove(key);

  dynamic get readRefreshToken => read(refreshToken);
  Future<void> writeRefreshToken(dynamic object) => write(refreshToken, object);
  Future<void> removeRefreshToken() => remove(refreshToken);
}
