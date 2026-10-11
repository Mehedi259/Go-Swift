import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_swift/app.dart';
import 'package:go_swift/core/models/user_model.dart';
import 'package:go_swift/core/storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorage.init();
  });

  testWidgets('Splash screen routes to /choose-account when not logged in', (WidgetTester tester) async {
    await tester.pumpWidget(const GoSwiftApp());
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('GO '), findsOneWidget);
    expect(find.text('SWIFT'), findsOneWidget);

    // Advance beyond splash animation & navigation timer
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Should have navigated to ChooseAccountTypeScreen
    expect(find.text('Choose Your Portal'), findsOneWidget);
  });

  testWidgets('Splash screen routes directly to /customer/hub when logged in', (WidgetTester tester) async {
    // Pre-populate authenticated session
    await LocalStorage.saveTokens(access: 'mock_jwt_access_token');
    await LocalStorage.saveUser(
      UserModel(
        id: 1,
        email: 'customer@goswift.bs',
        fullName: 'Marcus Vance',
        role: 'customer',
      ),
    );

    await tester.pumpWidget(const GoSwiftApp());
    expect(find.byType(MaterialApp), findsOneWidget);

    // Advance beyond splash animation & navigation timer
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Should have navigated directly to CustomerHubScreen
    expect(find.text('Choose Your Portal'), findsNothing);
    expect(find.textContaining('Welcome back'), findsOneWidget);
  });
}
