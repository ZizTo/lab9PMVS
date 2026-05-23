import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

import 'package:minsk_transport/providers/theme_provider.dart';

class InMemorySharedPreferencesStore extends SharedPreferencesStorePlatform {
  final Map<String, Object> _data = {};

  @override
  Future<bool> clear() async {
    _data.clear();
    return true;
  }

  @override
  Future<Map<String, Object>> getAll() async {
    return Map<String, Object>.from(_data);
  }

  @override
  Future<bool> remove(String key) async {
    _data.remove(key);
    return true;
  }

  @override
  Future<bool> setValue(String valueType, String key, Object value) async {
    _data[key] = value;
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ThemeModeNotifier notifier;

  setUp(() {
    SharedPreferencesStorePlatform.instance = InMemorySharedPreferencesStore();
    notifier = ThemeModeNotifier();
  });

  test('default theme mode is system', () {
    expect(notifier.state, ThemeMode.system);
  });

  test('setThemeMode changes theme to dark', () async {
    await notifier.setThemeMode(ThemeMode.dark);
    expect(notifier.state, ThemeMode.dark);
  });

  test('loadTheme restores saved light theme', () async {
    await notifier.setThemeMode(ThemeMode.light);

    final restored = ThemeModeNotifier();
    await restored.loadTheme();

    expect(restored.state, ThemeMode.light);
  });
}