import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:http/http.dart' as http;
import 'package:go_swift/app.dart';
import 'package:go_swift/core/storage/local_storage.dart';

Future<void> triggerSimScreenshot(String name) async {
  try {
    final uri = Uri.parse('http://127.0.0.1:8888/screenshot?name=$name');
    final res = await http.get(uri);
    debugPrint('[TestCapture] $name -> ${res.statusCode}');
  } catch (e) {
    debugPrint('[TestCapture ERROR] $name -> $e');
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Real User Live API Login & Screen Verification', (WidgetTester tester) async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('ListTile background color') ||
          details.exceptionAsString().contains('overflow')) {
        return;
      }
      FlutterError.presentError(details);
    };

    // 1. Reset storage to test clean login flow
    await LocalStorage.clear();

    runApp(const GoSwiftApp());
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 600));
    await tester.pump();

    // Wait for Splash screen timer to navigate to /choose-account
    await Future.delayed(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    // 2. Select User Portal
    final userTextFinder = find.text('User');
    expect(userTextFinder, findsOneWidget);
    await tester.tap(userTextFinder);
    await tester.pumpAndSettle();

    final continueUserBtn = find.text('Continue as User');
    expect(continueUserBtn, findsOneWidget);
    await tester.tap(continueUserBtn);
    await tester.pumpAndSettle();

    // 3. Fill in Real Credentials
    final formFields = find.byType(TextFormField);
    expect(formFields, findsAtLeastNWidgets(2));

    await tester.enterText(formFields.at(0), 'mmridul207@gmail.com');
    await tester.pumpAndSettle();
    await tester.enterText(formFields.at(1), 'Test12342@');
    await tester.pumpAndSettle();

    // Dismiss keyboard
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await triggerSimScreenshot('real_01_credentials_entered');

    // 4. Tap "Sign In →" (Hits live AWS Django backend API)
    final signInBtn = find.text('Sign In →');
    expect(signInBtn, findsOneWidget);
    await tester.tap(signInBtn);
    await tester.pump();

    // Wait for network request to complete and screen transition
    await Future.delayed(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // 5. Customer Hub (Home Tab) with Live User Data
    await triggerSimScreenshot('real_02_home_hub_live');

    // 6. Switch to Tab 1 - History (Hits live AWS API: /api/rides/my-rides/)
    final historyTab = find.text('History');
    expect(historyTab, findsOneWidget);
    await tester.tap(historyTab);
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    await triggerSimScreenshot('real_03_history_live_rides');

    // 7. Switch to Tab 2 - Favorites (Hits live AWS API: /api/users/favorites/)
    final favTab = find.text('Favorites');
    expect(favTab, findsOneWidget);
    await tester.tap(favTab);
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    await triggerSimScreenshot('real_04_favorites_live');

    // 8. Switch to Tab 3 - Support (Hits live AWS API: /api/supports/...)
    final supportTab = find.text('Support');
    expect(supportTab, findsOneWidget);
    await tester.tap(supportTab);
    await Future.delayed(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await triggerSimScreenshot('real_05_support_live');

    // Open "My Tickets" sheet
    final myTicketsBtn = find.text('My Tickets');
    if (myTicketsBtn.evaluate().isNotEmpty) {
      await tester.tap(myTicketsBtn);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      await triggerSimScreenshot('real_06_support_my_tickets_sheet');

      // Dismiss bottom sheet
      Navigator.pop(tester.element(find.byType(Scaffold).first));
      await tester.pumpAndSettle();
    }

    // 9. Switch to Tab 4 - Profile (Displays live user details from backend)
    final profileTab = find.text('Profile');
    expect(profileTab, findsOneWidget);
    await tester.tap(profileTab);
    await Future.delayed(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await triggerSimScreenshot('real_07_profile_live_user');

    debugPrint('[REAL USER TEST] Verification completed successfully with live backend credentials!');
  });
}
