import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

import 'package:minsk_transport/providers/auth_provider.dart';

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

  late AuthNotifier notifier;

  setUp(() {
    SharedPreferencesStorePlatform.instance = InMemorySharedPreferencesStore();
    notifier = AuthNotifier();
  });

  test('login succeeds for valid email and password 123456', () async {
    final result = await notifier.login(
      email: 'student@bsu.by',
      password: '123456',
    );

    expect(result, true);
    expect(notifier.state.isLoggedIn, true);
    expect(notifier.state.email, 'student@bsu.by');
  });

  test('login fails for wrong password', () async {
    final result = await notifier.login(
      email: 'student@bsu.by',
      password: '654321',
    );

    expect(result, false);
    expect(notifier.state.isLoggedIn, false);
    expect(notifier.state.email, null);
  });

  test('login fails for invalid email', () async {
    final result = await notifier.login(
      email: 'student_bsu.by',
      password: '123456',
    );

    expect(result, false);
    expect(notifier.state.isLoggedIn, false);
  });

  test('restoreSession restores saved session', () async {
    await notifier.login(
      email: 'student@bsu.by',
      password: '123456',
    );

    final restored = AuthNotifier();
    await restored.restoreSession();

    expect(restored.state.isLoggedIn, true);
    expect(restored.state.email, 'student@bsu.by');
  });

  test('logout clears session', () async {
    await notifier.login(
      email: 'student@bsu.by',
      password: '123456',
    );

    await notifier.logout();

    expect(notifier.state.isLoggedIn, false);
    expect(notifier.state.email, null);
  });
}