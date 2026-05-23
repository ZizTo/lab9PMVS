import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minsk_transport/l10n/app_localizations.dart';
import 'package:minsk_transport/screens/login_screen.dart';

void main() {
  Widget createWidget() {
    return const ProviderScope(
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: LoginScreen(),
      ),
    );
  }

  testWidgets('login screen shows email, password and button', (tester) async {
    await tester.pumpWidget(createWidget());

    expect(find.byKey(const Key('login_email_field')), findsOneWidget);
    expect(find.byKey(const Key('login_password_field')), findsOneWidget);
    expect(find.byKey(const Key('login_submit_button')), findsOneWidget);
  });

  testWidgets('wrong password shows error', (tester) async {
    await tester.pumpWidget(createWidget());

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
}