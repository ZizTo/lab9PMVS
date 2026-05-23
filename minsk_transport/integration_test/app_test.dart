import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:minsk_transport/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end app test', () {
    testWidgets('login with correct password opens app', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'student@bsu.by',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        '123456',
      );
      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(Scaffold), findsWidgets);
      expect(find.byType(NavigationBar), findsWidgets);
    });

    testWidgets('wrong password keeps user on login screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'student@bsu.by',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        '111111',
      );
      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('login_error_text')), findsOneWidget);
    });

    testWidgets('after login user can open settings tab', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'student@bsu.by',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        '123456',
      );
      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final settingsFinder = find.byIcon(Icons.settings);
      expect(settingsFinder, findsWidgets);

      await tester.tap(settingsFinder.last);
      await tester.pumpAndSettle();

      expect(find.textContaining('1.0.0'), findsOneWidget);
    });
  });
}