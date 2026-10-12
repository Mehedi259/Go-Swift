import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:go_swift/core/models/car_rental_model.dart';
import 'package:go_swift/core/models/courier_model.dart';
import 'package:go_swift/core/models/food_model.dart';
import 'package:go_swift/core/models/ride_model.dart';
import 'package:go_swift/core/models/user_model.dart';
import 'package:go_swift/core/providers/auth_provider.dart';
import 'package:go_swift/core/storage/local_storage.dart';
import 'package:go_swift/core/theme/app_theme.dart';
import 'package:go_swift/features/onboarding/choose_account_type_screen.dart';
import 'package:go_swift/features/auth/service_category_screen.dart';
import 'package:go_swift/features/auth/driver_register_screen.dart';
import 'package:go_swift/features/provider/driver/driver_availability_screen.dart';
import 'package:go_swift/features/customer/hub/customer_hub_screen.dart';
import 'package:go_swift/features/customer/ride/ride_booking_screen.dart';
import 'package:go_swift/features/customer/ride/ride_driver_accepted_screen.dart';
import 'package:go_swift/features/customer/food/food_dining_screen.dart';
import 'package:go_swift/features/customer/food/restaurant_details_screen.dart';
import 'package:go_swift/features/customer/food/food_cart_screen.dart';
import 'package:go_swift/features/customer/food/food_order_status_screen.dart';
import 'package:go_swift/features/customer/car_rental/car_rental_search_screen.dart';
import 'package:go_swift/features/customer/car_rental/vehicle_details_screen.dart';
import 'package:go_swift/features/customer/car_rental/car_rental_booking_screen.dart';
import 'package:go_swift/features/customer/car_rental/active_car_rental_screen.dart';
import 'package:go_swift/features/customer/courier/courier_request_screen.dart';
import 'package:go_swift/features/customer/courier/courier_delivery_status_screen.dart';

Future<void> snap(String name, WidgetTester tester) async {
  await tester.pumpAndSettle();
  try {
    await http.get(Uri.parse('http://127.0.0.1:8888/screenshot?name=$name'));
  } catch (e) {
    debugPrint('[snap error]: $e');
  }
}

Widget testWrapper(Widget child, {Map<String, WidgetBuilder>? routes}) {
  final Map<String, WidgetBuilder> mergedRoutes = {
    '/customer/hub': (c) => const CustomerHubScreen(),
    '/provider/service-category': (c) => const ServiceCategoryScreen(),
    '/provider/driver/register': (c) => const DriverRegisterScreen(),
    '/provider/driver/hub': (c) => const DriverAvailabilityScreen(),
    '/customer/ride/booking': (c) => const RideBookingScreen(),
    '/customer/food': (c) => const FoodDiningScreen(),
    '/customer/food/restaurant': (c) => const RestaurantDetailsScreen(),
    '/customer/food/cart': (c) => const FoodCartScreen(),
    '/customer/food/order-status': (c) => const FoodOrderStatusScreen(),
    '/customer/car-rental/search': (c) => const CarRentalSearchScreen(),
    '/customer/car-rental/vehicle': (c) => const VehicleDetailsScreen(),
    '/customer/car-rental/booking': (c) => const CarRentalBookingScreen(),
    '/customer/car-rental/active': (c) => const ActiveCarRentalScreen(),
    '/customer/courier/request': (c) => const CourierRequestScreen(),
    '/customer/courier/status': (c) => const CourierDeliveryStatusScreen(),
    if (routes != null) ...routes,
  };

  return MultiProvider(
    key: UniqueKey(),
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: child,
      routes: mergedRoutes,
    ),
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Live Interactive App Journey Walkthrough', (tester) async {
    // =========================================================================
    // FLOW 1: PORTAL SELECTION & SERVICE PROVIDER ONBOARDING
    // =========================================================================
    await LocalStorage.init();
    await LocalStorage.clear();

    await tester.pumpWidget(
      testWrapper(
        const ChooseAccountTypeScreen(),
      ),
    );
    await tester.pumpAndSettle();
    await snap('01_choose_portal', tester);

    // Tap Service Provider card
    final providerCard = find.text('Service Provider');
    expect(providerCard, findsOneWidget);
    await tester.tap(providerCard);
    await tester.pumpAndSettle();
    await snap('02_provider_card_selected', tester);

    // Scroll down to bring 'Apply as Service Provider' into view
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();

    // Tap Apply as Service Provider
    final applyBtn = find.text('Apply as Service Provider');
    expect(applyBtn, findsOneWidget);
    await tester.tap(applyBtn);
    await tester.pumpAndSettle();
    await snap('03_service_category_menu', tester);

    // Tap Continue with selected category (Ride Sharing & Chauffeur)
    final continueCatBtn = find.textContaining('Continue with');
    expect(continueCatBtn, findsOneWidget);
    await tester.tap(continueCatBtn);
    await tester.pumpAndSettle();
    await snap('04_driver_registration_form', tester);

    // Enter phone and driver's license
    final textFields = find.byType(TextField);
    if (textFields.evaluate().length >= 2) {
      await tester.enterText(textFields.at(0), '555-0188');
      await tester.enterText(textFields.at(1), 'PSL-40291-NP');
      await tester.pumpAndSettle();
    }

    // Toggle Vehicle selection to Executive Sedan
    final execSedan = find.textContaining('Executive Sedan');
    if (execSedan.evaluate().isNotEmpty) {
      await tester.tap(execSedan.first);
      await tester.pumpAndSettle();
    }

    // Toggle Terms Checkbox
    final checkbox = find.byType(Checkbox);
    if (checkbox.evaluate().isNotEmpty) {
      await tester.tap(checkbox.first);
      await tester.pumpAndSettle();
    }
    await snap('05_driver_registration_inputs_filled', tester);

    // Submit Driver Profile
    final submitDriverBtn = find.textContaining('Continue to Driver Profile');
    if (submitDriverBtn.evaluate().isNotEmpty) {
      await tester.tap(submitDriverBtn.first);
      await tester.pump(const Duration(milliseconds: 500));
      await snap('06_driver_submission_progress', tester);
      await tester.pumpAndSettle();
    }

    // =========================================================================
    // FLOW 2: CUSTOMER HUB & ON-DEMAND CHAUFFEUR BOOKING
    // =========================================================================
    await LocalStorage.saveTokens(access: 'mock_jwt_access_token');
    await LocalStorage.saveUser(
      UserModel(
        id: 701,
        email: 'vip.client@goswift.bs',
        fullName: 'VIP Sovereign Client',
        phoneNumber: '+12425550999',
        role: 'customer',
        streetAddress: 'Albany Marina, New Providence',
        city: 'Nassau',
      ),
    );

    await tester.pumpWidget(
      testWrapper(
        const CustomerHubScreen(),
      ),
    );
    await tester.pumpAndSettle();
    await snap('07_customer_hub_overview', tester);

    // Tap Book Ride on Customer Hub
    final bookRideBtn = find.text('Book Ride').first;
    await tester.tap(bookRideBtn);
    await tester.pumpAndSettle();
    await snap('08_ride_booking_screen', tester);

    // Input Destination and Pickup
    final rideInputs = find.byType(TextField);
    if (rideInputs.evaluate().length >= 2) {
      await tester.enterText(rideInputs.at(0), "Lynden Pindling Int'l Airport (NAS)");
      await tester.enterText(rideInputs.at(1), "The Ocean Club, A Four Seasons Resort, Paradise Island");
      await tester.pumpAndSettle();
    }

    // Select Luxury Vehicle Class
    final sedanTile = find.textContaining('Luxury Sedan');
    if (sedanTile.evaluate().isNotEmpty) {
      await tester.tap(sedanTile.first);
      await tester.pumpAndSettle();
    }
    await snap('09_ride_booking_inputs_entered', tester);

    // Tap Confirm Booking
    final confirmRideBtn = find.textContaining('Confirm Booking');
    if (confirmRideBtn.evaluate().isNotEmpty) {
      await tester.tap(confirmRideBtn.first);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
    }

    // View Driver Accepted & Tracking Screen
    final mockRide = RideModel(
      id: 8842,
      pickupAddress: "Lynden Pindling Int'l Airport (NAS)",
      pickupLatitude: 25.0389,
      pickupLongitude: -77.4662,
      destinationAddress: "The Ocean Club, Paradise Island",
      destinationLatitude: 25.0786,
      destinationLongitude: -77.3072,
      status: 'accepted',
      estimatedFare: 85.0,
      requestedVehicleCategory: 'executive_suv',
      driver: DriverProfileModel(
        id: 304,
        legalName: 'Captain Devon Sands',
        rating: 4.98,
        vehicleMake: 'Cadillac',
        vehicleModel: 'Escalade ESV',
        licensePlate: 'NP-40291',
      ),
    );

    await tester.pumpWidget(
      testWrapper(
        RideDriverAcceptedScreen(ride: mockRide),
      ),
    );
    await tester.pumpAndSettle();
    await snap('10_ride_driver_matched_and_confirmed', tester);

    // =========================================================================
    // FLOW 3: FINE DINING & YACHT CULINARY CONCIERGE
    // =========================================================================
    await tester.pumpWidget(
      testWrapper(
        const FoodDiningScreen(),
      ),
    );
    await tester.pumpAndSettle();
    await snap('11_food_dining_restaurants', tester);

    // Open Restaurant Menu Details
    final mockRestaurant = RestaurantModel(
      id: 101,
      name: 'Dune by Jean-Georges',
      cuisineConcept: 'French-Asian Fusion & Oceanfront Grill',
      islandHub: 'New Providence',
      address: 'The Ocean Club, Paradise Island',
      rating: 4.95,
      averagePrepWindow: '25-35 min',
    );

    await tester.pumpWidget(
      testWrapper(
        RestaurantDetailsScreen(restaurant: mockRestaurant),
      ),
    );
    await tester.pumpAndSettle();
    await snap('12_restaurant_details_and_menu', tester);

    // Open Food Cart Screen with items and custom villa instructions
    final mockMenu = [
      FoodItemModel(
        id: 501,
        name: 'Bahamian Rock Lobster Tail',
        description: 'Charred key lime, garlic herb butter, island asparagus',
        price: 65.0,
      ),
      FoodItemModel(
        id: 502,
        name: 'Yellowtail Snapper En Papillote',
        description: 'Wild local herbs, scotch bonnet infused coconut broth',
        price: 48.0,
      ),
    ];

    await tester.pumpWidget(
      MultiProvider(
        key: UniqueKey(),
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          initialRoute: '/customer/food/cart',
          routes: {
            '/customer/food/cart': (c) => const FoodCartScreen(),
          },
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              settings: RouteSettings(
                name: '/customer/food/cart',
                arguments: {
                  'restaurant': mockRestaurant,
                  'cart': {501: 2, 502: 1},
                  'menu': mockMenu,
                },
              ),
              builder: (c) => const FoodCartScreen(),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Input instructions in Cart
    final noteInputs = find.byType(TextField);
    if (noteInputs.evaluate().isNotEmpty) {
      await tester.enterText(noteInputs.first, 'Deliver to Villa 4B dock slip; include extra chilled lime butter');
      await tester.pumpAndSettle();
    }
    await snap('13_food_cart_with_dietary_notes', tester);

    // Food Order Status Screen
    final mockOrder = FoodOrderModel(
      id: 9021,
      orderNumber: '#GS-9021',
      restaurantName: 'Dune by Jean-Georges',
      status: 'preparing',
      totalAmount: 210.80,
      deliveryAddress: 'Albany Marina, Slip 14',
      items: [
        FoodOrderItemModel(id: 1, name: 'Bahamian Rock Lobster Tail', price: 65.0, quantity: 2),
        FoodOrderItemModel(id: 2, name: 'Yellowtail Snapper En Papillote', price: 48.0, quantity: 1),
      ],
    );

    await tester.pumpWidget(
      testWrapper(
        FoodOrderStatusScreen(order: mockOrder),
      ),
    );
    await tester.pumpAndSettle();
    await snap('14_food_kitchen_order_status', tester);

    // =========================================================================
    // FLOW 4: LUXURY FLEET CAR RENTAL & ISLAND RESERVATION
    // =========================================================================
    await tester.pumpWidget(
      testWrapper(
        const CarRentalSearchScreen(),
      ),
    );
    await tester.pumpAndSettle();
    await snap('15_car_rental_fleet_search', tester);

    // Vehicle Details Screen
    final mockVehicle = RentalVehicleModel(
      id: 204,
      name: 'Mercedes-Benz G63 AMG',
      make: 'Mercedes-Benz',
      model: 'G63 AMG',
      year: 2025,
      category: 'luxury_suv',
      dailyRate: 450.0,
      licensePlate: 'NP-G63-VIP',
      seatingCapacity: 5,
      transmission: 'Automatic 9G-Tronic',
    );

    await tester.pumpWidget(
      testWrapper(
        VehicleDetailsScreen(vehicle: mockVehicle),
      ),
    );
    await tester.pumpAndSettle();
    await snap('16_vehicle_specs_and_rates', tester);

    // Car Rental Booking Form
    await tester.pumpWidget(
      testWrapper(
        CarRentalBookingScreen(vehicle: mockVehicle),
      ),
    );
    await tester.pumpAndSettle();

    final rentalInputs = find.byType(TextField);
    if (rentalInputs.evaluate().length >= 3) {
      await tester.enterText(rentalInputs.at(0), 'Hon. Devon Sands');
      await tester.enterText(rentalInputs.at(1), 'PSL-DL-BAH-2026');
      await tester.enterText(rentalInputs.at(2), '+1 (242) 555-0188');
      await tester.pumpAndSettle();
    }
    await snap('17_car_rental_booking_form_filled', tester);

    // Active Car Rental Digital Key Screen
    final mockBooking = CarRentalBookingModel(
      id: 3401,
      bookingNumber: 'GS-RENT-3401',
      startDate: '2026-10-15',
      endDate: '2026-10-18',
      totalDays: 3,
      totalPrice: 1350.0,
      status: 'active',
      vehicleName: 'Mercedes-Benz G63 AMG',
      licensePlate: 'NP-G63-VIP',
    );

    await tester.pumpWidget(
      testWrapper(
        ActiveCarRentalScreen(booking: mockBooking),
      ),
    );
    await tester.pumpAndSettle();
    await snap('18_car_rental_active_pass', tester);

    // =========================================================================
    // FLOW 5: SOVEREIGN COURIER & DIPLOMATIC ESCORT DISPATCH
    // =========================================================================
    await tester.pumpWidget(
      testWrapper(
        const CourierRequestScreen(),
      ),
    );
    await tester.pumpAndSettle();

    final courierInputs = find.byType(TextField);
    if (courierInputs.evaluate().length >= 4) {
      await tester.enterText(courierInputs.at(0), "Lynden Pindling Executive Jet Terminal");
      await tester.enterText(courierInputs.at(1), "Old Fort Bay Gated Estate, Villa 7");
      await tester.enterText(courierInputs.at(2), "Sir Arthur Bethel");
      await tester.enterText(courierInputs.at(3), "+1 (242) 555-0199");
      await tester.pumpAndSettle();
    }

    // Select package type
    final packageType = find.textContaining('Bonded Legal Document');
    if (packageType.evaluate().isNotEmpty) {
      await tester.tap(packageType.first);
      await tester.pumpAndSettle();
    }
    await snap('19_courier_request_form_filled', tester);

    // Courier Delivery Active Status Screen
    final mockDelivery = CourierDeliveryModel(
      id: 7720,
      status: 'in_transit',
      pickupAddress: 'Lynden Pindling Executive Jet Terminal',
      dropoffAddress: 'Old Fort Bay Gated Estate, Villa 7',
      courierName: 'Captain Devon Sands',
      estimatedFare: 65.0,
    );

    await tester.pumpWidget(
      testWrapper(
        CourierDeliveryStatusScreen(delivery: mockDelivery),
      ),
    );
    await tester.pumpAndSettle();
    await snap('20_courier_escort_tracking_active', tester);
  });
}
