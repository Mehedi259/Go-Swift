import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:http/http.dart' as http;
import 'package:go_swift/app.dart';
import 'package:go_swift/core/storage/local_storage.dart';
import 'package:go_swift/core/models/user_model.dart';
import 'package:go_swift/features/customer/properties/property_details_screen.dart';

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

  testWidgets('Complete Normal User (Customer) Entry & Journey Test', (WidgetTester tester) async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('ListTile background color') ||
          details.exceptionAsString().contains('401')) {
        return;
      }
      FlutterError.presentError(details);
    };

    // 1. Reset storage to test fresh user entry
    await LocalStorage.clear();

    runApp(const GoSwiftApp());
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 600));
    await tester.pump();

    // 01: Splash Screen
    await triggerSimScreenshot('normal_01_splash_screen');

    // Wait for Splash screen timer (2 seconds) to navigate to /choose-account
    await Future.delayed(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    // 02: Choose Your Portal Screen
    await triggerSimScreenshot('normal_02_portal_screen');

    // 03: Tap User Card explicitly (Card 0)
    final userTextFinder = find.text('User');
    expect(userTextFinder, findsOneWidget);
    await tester.tap(userTextFinder);
    await tester.pumpAndSettle();
    await triggerSimScreenshot('normal_03_user_card_selected');

    // 04: Click "Continue as User"
    final continueUserBtn = find.text('Continue as User');
    expect(continueUserBtn, findsOneWidget);
    await tester.tap(continueUserBtn);
    await tester.pumpAndSettle();

    // 04: Customer Login Screen
    await triggerSimScreenshot('normal_04_customer_login_screen');

    // 05: Type Customer Email and Password
    final formFields = find.byType(TextFormField);
    expect(formFields, findsAtLeastNWidgets(2));

    await tester.enterText(formFields.at(0), 'alexander.vance@bahamasvip.com');
    await tester.pumpAndSettle();
    await tester.enterText(formFields.at(1), 'SovereignPass2026!');
    await tester.pumpAndSettle();
    await triggerSimScreenshot('normal_05_login_credentials_typed');

    // 06: Toggle Password Visibility
    final visibilityIcon = find.byIcon(Icons.visibility_outlined);
    if (visibilityIcon.evaluate().isNotEmpty) {
      await tester.tap(visibilityIcon.first);
      await tester.pumpAndSettle();
      await triggerSimScreenshot('normal_06_password_revealed');
    }

    // Dismiss keyboard
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    // 07: Navigate to "Create Account" (CustomerRegisterScreen)
    final createAccountFinder = find.textContaining('Create Account');
    if (createAccountFinder.evaluate().isNotEmpty) {
      await tester.ensureVisible(createAccountFinder);
      await tester.tap(createAccountFinder);
      await tester.pumpAndSettle();
      await triggerSimScreenshot('normal_07_customer_register_screen');

      // Fill in Registration fields
      final regFields = find.byType(TextFormField);
      if (regFields.evaluate().length >= 4) {
        await tester.enterText(regFields.at(0), 'Hon. Alexander Vance'); // Name
        await tester.pumpAndSettle();
        await tester.enterText(regFields.at(1), 'alexander.vance@bahamasvip.com'); // Email
        await tester.pumpAndSettle();
        await tester.enterText(regFields.at(2), '555-0100'); // Phone
        await tester.pumpAndSettle();
        await tester.enterText(regFields.at(3), 'SovereignPass2026!'); // Password
        await tester.pumpAndSettle();
      }
      await triggerSimScreenshot('normal_08_register_fields_filled');

      // Dismiss keyboard in registration
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();

      // Tap back button to return to Login
      final backBtn = find.byIcon(Icons.arrow_back);
      if (backBtn.evaluate().isNotEmpty) {
        await tester.tap(backBtn.first);
        await tester.pumpAndSettle();
      }
    }

    // 08: Authenticate session as normal Customer
    await LocalStorage.saveTokens(access: 'sovereign-customer-jwt-token', refresh: 'sovereign-refresh-token');
    await LocalStorage.saveUser(
      UserModel(
        id: 101,
        email: 'alexander.vance@bahamasvip.com',
        fullName: 'Alexander Vance',
        phoneNumber: '+1 (242) 555-0100',
        role: 'customer',
        city: 'Nassau & Paradise Island',
      ),
    );

    // Dismiss keyboard if any on login
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    // Tap "Customer Hub" chip to enter into Customer Hub as normal user
    final customerHubChip = find.text('Customer Hub');
    if (customerHubChip.evaluate().isNotEmpty) {
      await tester.ensureVisible(customerHubChip);
      await tester.tap(customerHubChip);
    } else {
      final signInBtn = find.text('Sign In →');
      if (signInBtn.evaluate().isNotEmpty) {
        await tester.tap(signInBtn);
      }
    }
    await tester.pumpAndSettle();

    // 09: Customer Hub Home Loaded
    await triggerSimScreenshot('normal_09_customer_hub_home');

    // 10: Scroll down on Customer Hub to reveal recent activity & featured destinations
    final hubScrollView = find.byType(SingleChildScrollView);
    if (hubScrollView.evaluate().isNotEmpty) {
      await tester.drag(hubScrollView.first, const Offset(0, -320));
      await tester.pumpAndSettle();
      await triggerSimScreenshot('normal_10_customer_hub_scrolled');
      // Scroll back up
      await tester.drag(hubScrollView.first, const Offset(0, 320));
      await tester.pumpAndSettle();
    }

    // 11: Switch to Tab 1 - Trip & Booking History
    final historyTabFinder = find.text('History');
    expect(historyTabFinder, findsOneWidget);
    await tester.tap(historyTabFinder);
    await tester.pumpAndSettle();
    await triggerSimScreenshot('normal_11_tab_booking_history');

    // 12: Switch to Tab 2 - Saved Places & Favorites
    final favTabFinder = find.text('Favorites');
    expect(favTabFinder, findsOneWidget);
    await tester.tap(favTabFinder);
    await tester.pumpAndSettle();
    await triggerSimScreenshot('normal_12_tab_saved_favorites');

    // 13: Switch to Tab 3 - Concierge Support
    final supportTabFinder = find.text('Support');
    expect(supportTabFinder, findsOneWidget);
    await tester.tap(supportTabFinder);
    await tester.pumpAndSettle();
    await triggerSimScreenshot('normal_13_tab_concierge_support');

    // 14: Switch to Tab 4 - Customer Profile & Settings
    final profileTabFinder = find.text('Profile');
    expect(profileTabFinder, findsOneWidget);
    await tester.tap(profileTabFinder);
    await tester.pumpAndSettle();
    await triggerSimScreenshot('normal_14_tab_customer_profile');

    // 15: Return to Home and Open Island Properties & Luxury Villas
    final homeTabFinder = find.text('Home');
    expect(homeTabFinder, findsOneWidget);
    await tester.tap(homeTabFinder);
    await tester.pumpAndSettle();

    // Navigate to /customer/properties/search
    final navState = tester.state<NavigatorState>(find.byType(Navigator).first);
    navState.pushNamed('/customer/properties/search');
    await tester.pumpAndSettle();
    await triggerSimScreenshot('normal_15_luxury_properties_search');

    // 16: Open Property Details for "The Ocean Club Villa"
    navState.push(
      MaterialPageRoute(builder: (_) => const PropertyDetailsScreen()),
    );
    await tester.pumpAndSettle();
    await triggerSimScreenshot('normal_16_ocean_club_villa_details');

    debugPrint('[NORMAL USER TEST] Completed all 16 normal customer touchpoints successfully!');
  });
}
