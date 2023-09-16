import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();
  static const showTimerKey = 'showTimer';
  static const defaultShowTimerValue = false;

  StorageService();

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> writeShowTimerValue(bool value) async {
    log('Setting timer to $value');
    await write(showTimerKey, value.toString());
  }

  Future<bool> readShowTimerValue() async {
    String? value = await read(showTimerKey);
    return value == null ? defaultShowTimerValue : value == 'true';
  }
}
