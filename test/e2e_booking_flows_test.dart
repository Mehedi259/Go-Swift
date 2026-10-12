import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_swift/app.dart';
import 'package:go_swift/core/models/car_rental_model.dart';
import 'package:go_swift/core/models/courier_model.dart';
import 'package:go_swift/core/models/food_model.dart';
import 'package:go_swift/core/models/ride_model.dart';
import 'package:go_swift/core/models/user_model.dart';
import 'package:go_swift/core/providers/auth_provider.dart';
import 'package:go_swift/core/storage/local_storage.dart';
import 'package:go_swift/core/widgets/gs_button.dart';
import 'package:go_swift/features/customer/car_rental/active_car_rental_screen.dart';
import 'package:go_swift/features/customer/car_rental/car_rental_booking_screen.dart';
import 'package:go_swift/features/customer/car_rental/car_rental_search_screen.dart';
import 'package:go_swift/features/customer/car_rental/vehicle_details_screen.dart';
import 'package:go_swift/features/customer/courier/courier_delivery_status_screen.dart';
import 'package:go_swift/features/customer/courier/courier_request_screen.dart';
import 'package:go_swift/features/customer/food/food_cart_screen.dart';
import 'package:go_swift/features/customer/food/food_dining_screen.dart';
import 'package:go_swift/features/customer/food/food_order_status_screen.dart';
import 'package:go_swift/features/customer/history/booking_history_screen.dart';
import 'package:go_swift/features/customer/hub/customer_hub_screen.dart';
import 'package:go_swift/features/customer/ride/active_ride_screen.dart';
import 'package:go_swift/features/customer/ride/ride_booking_screen.dart';
import 'package:go_swift/features/customer/ride/ride_completed_screen.dart';
import 'package:go_swift/features/customer/ride/ride_driver_accepted_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget createTestApp(Widget home, {Map<String, WidgetBuilder>? routes, Key? key}) {
  return MultiProvider(
    key: key ?? UniqueKey(),
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
    ],
    child: MaterialApp(
      home: home,
      routes: routes ?? {},
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorage.init();
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
  });

  group('E2E Flow 1: Sovereign Customer Hub & Navigation Portal', () {
    testWidgets('Customer Hub loads authenticated state with all service portals', (WidgetTester tester) async {
      await tester.pumpWidget(const GoSwiftApp());
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Customer Hub presence
      expect(find.byType(CustomerHubScreen), findsOneWidget);
      expect(find.textContaining('Welcome back'), findsOneWidget);
      expect(find.textContaining('VIP'), findsWidgets);

      // Verify all 5 core luxury service tiles are visible in grid
      expect(find.text('Ride'), findsWidgets);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Courier'), findsOneWidget);
      expect(find.text('Car Rental'), findsOneWidget);
      expect(find.text('Rooms / Properties'), findsOneWidget);
    });
  });

  group('E2E Flow 2: Complete Ride Creation & Booking Workflow', () {
    testWidgets('Full Ride Lifecycle: Booking -> Vehicle Selection -> Active -> Completed', (WidgetTester tester) async {
      // 1. Launch Ride Booking Screen with AuthProvider
      await tester.pumpWidget(
        createTestApp(
          const RideBookingScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RideBookingScreen), findsOneWidget);
      expect(find.text('PICKUP LOCATION'), findsOneWidget);
      expect(find.text('DESTINATION'), findsOneWidget);

      // Verify destination defaults
      expect(find.text('The Ocean Club, Four Seasons'), findsWidgets);

      // Verify vehicle selection options
      expect(find.text('Executive SUV'), findsOneWidget);
      expect(find.text('Luxury Sedan'), findsOneWidget);
      expect(find.text('VIP Sprinter'), findsOneWidget);

      // Switch vehicle to Luxury Sedan
      await tester.ensureVisible(find.text('Luxury Sedan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Luxury Sedan'));
      await tester.pumpAndSettle();

      // Switch vehicle to VIP Sprinter
      await tester.ensureVisible(find.text('VIP Sprinter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('VIP Sprinter'));
      await tester.pumpAndSettle();

      // Verify confirm booking button
      final confirmBtn = find.widgetWithText(GSButton, 'Confirm Booking →');
      expect(confirmBtn, findsOneWidget);

      // 2. Test Driver Accepted Screen with live RideModel
      final activeRide = RideModel(
        id: 8821,
        status: 'in_transit',
        pickupAddress: 'Lynden Pindling Int\'l Airport (NAS)',
        destinationAddress: 'The Ocean Club, Paradise Island',
        requestedVehicleCategory: 'executive_suv',
        estimatedFare: 118.50,
        finalFare: 118.50,
        distanceKm: 18.5,
        estimatedDurationMinutes: 22,
        driver: DriverProfileModel(
          id: 50,
          legalName: 'Captain Jean Dupont',
          licensePlate: 'BS-882-VIP',
          vehicleMake: 'Cadillac',
          vehicleModel: 'Escalade ESV',
          rating: 4.99,
        ),
      );

      await tester.pumpWidget(
        createTestApp(
          RideDriverAcceptedScreen(ride: activeRide),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RideDriverAcceptedScreen), findsOneWidget);
      expect(find.text('Captain Jean Dupont'), findsOneWidget);
      expect(find.text('BS-882-VIP'), findsOneWidget);

      // 3. Test Active Ride Screen
      await tester.pumpWidget(
        createTestApp(
          ActiveRideScreen(ride: activeRide),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ActiveRideScreen), findsOneWidget);
      expect(find.textContaining('#SW-8821'), findsWidgets);
      expect(find.text('Captain Jean Dupont'), findsOneWidget);
      expect(find.text('BS-882-VIP'), findsOneWidget);
      expect(find.text('18.5 km'), findsOneWidget);

      // 4. Test Ride Completed Screen
      await tester.pumpWidget(
        createTestApp(
          RideCompletedScreen(ride: activeRide),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RideCompletedScreen), findsOneWidget);
      expect(find.textContaining('#SW-8821'), findsWidgets);
      expect(find.text('TRIP #SW-8821'), findsOneWidget);
      expect(find.text('\$118.50'), findsOneWidget);
      expect(find.text('Settled Digital Payment'), findsOneWidget);
      expect(find.text('SETTLED'), findsOneWidget);
    });
  });

  group('E2E Flow 3: Complete Car Rental Fleet & Reservation Workflow', () {
    testWidgets('Full Rental Lifecycle: Search Fleet -> Vehicle Details -> Date Selection -> Active Rental', (WidgetTester tester) async {
      // 1. Search Screen
      await tester.pumpWidget(
        createTestApp(
          const CarRentalSearchScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CarRentalSearchScreen), findsOneWidget);
      expect(find.text('Reserve Your Vehicle'), findsOneWidget);
      expect(find.text('Cadillac Escalade ESV'), findsOneWidget);

      // 2. Vehicle Details Screen
      final sampleVehicle = RentalVehicleModel(
        id: 12,
        name: 'Porsche 911 Carrera Cabriolet',
        make: 'Porsche',
        model: '911 Carrera Cabriolet',
        year: 2025,
        category: 'exotic_convertible',
        dailyRate: 450.00,
        licensePlate: 'BS-911-PR',
        seatingCapacity: 2,
        transmission: 'automatic',
      );

      await tester.pumpWidget(
        createTestApp(
          VehicleDetailsScreen(vehicle: sampleVehicle),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(VehicleDetailsScreen), findsOneWidget);
      expect(find.text('Porsche 911 Carrera Cabriolet'), findsOneWidget);
      expect(find.text('EXOTIC CONVERTIBLE'), findsOneWidget);
      expect(find.textContaining('\$450'), findsWidgets);
      expect(find.text('Reserve Vehicle →'), findsOneWidget);

      // 3. Car Rental Booking Screen
      await tester.pumpWidget(
        createTestApp(
          CarRentalBookingScreen(vehicle: sampleVehicle),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CarRentalBookingScreen), findsOneWidget);
      expect(find.text('Porsche 911 Carrera Cabriolet'), findsOneWidget);
      expect(find.text('PRIMARY DRIVER INFORMATION'), findsOneWidget);
      expect(find.text('HANDOVER & DELIVERY OPTION'), findsOneWidget);

      // Tap delivery options
      expect(find.text('Hotel / Villa Concierge Delivery'), findsOneWidget);
      expect(find.text('Airport Delivery (NAS)'), findsOneWidget);
      await tester.ensureVisible(find.text('Airport Delivery (NAS)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Airport Delivery (NAS)'));
      await tester.pumpAndSettle();

      // Verify dynamic confirm button exists
      expect(find.byType(GSButton), findsOneWidget);

      // 4. Active Car Rental Screen Verification
      final activeBooking = CarRentalBookingModel(
        id: 405,
        bookingNumber: '#CR-405',
        status: 'active',
        startDate: '2026-10-15',
        endDate: '2026-10-19',
        totalDays: 4,
        totalPrice: 1800.00,
        vehicleName: 'Porsche 911 Carrera Cabriolet',
        licensePlate: 'BS-911-PR',
      );

      await tester.pumpWidget(
        createTestApp(
          ActiveCarRentalScreen(booking: activeBooking),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ActiveCarRentalScreen), findsOneWidget);
      expect(find.text('ACTIVE RENTAL • #CR-405'), findsOneWidget);
      expect(find.text('Porsche 911 Carrera Cabriolet'), findsOneWidget);
      expect(find.text('BS-911-PR'), findsWidgets);
      expect(find.text('\$1800.00'), findsOneWidget);
    });
  });

  group('E2E Flow 4: Fine Dining & Kitchen Order Workflow', () {
    testWidgets('Dining Order Lifecycle: Restaurants -> Cart -> Live Tracking', (WidgetTester tester) async {
      // 1. Food Dining Screen
      await tester.pumpWidget(
        createTestApp(
          const FoodDiningScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FoodDiningScreen), findsOneWidget);
      expect(find.text('Food & Dining'), findsOneWidget);

      // 2. Food Cart Screen
      await tester.pumpWidget(
        createTestApp(
          const FoodCartScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FoodCartScreen), findsOneWidget);
      expect(find.text('Your Dining Cart'), findsOneWidget);
      expect(find.text('Your Dining Cart is Empty'), findsOneWidget);

      // 3. Live Order Status Screen
      final liveOrder = FoodOrderModel(
        id: 924,
        orderNumber: '#GS-924',
        restaurantName: 'Nobu Atlantis',
        status: 'preparing',
        totalAmount: 245.50,
        deliveryAddress: 'Penthouse Suite 1402, The Cove Atlantis',
        items: [
          FoodOrderItemModel(id: 1, name: 'Black Cod Miso', price: 68.0, quantity: 2),
          FoodOrderItemModel(id: 2, name: 'Yellowtail Jalapeno', price: 34.0, quantity: 1),
        ],
      );

      await tester.pumpWidget(
        createTestApp(
          FoodOrderStatusScreen(order: liveOrder),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FoodOrderStatusScreen), findsOneWidget);
      expect(find.textContaining('#GS-924'), findsWidgets);
      expect(find.textContaining('NOBU ATLANTIS'), findsWidgets);
      expect(find.text('Penthouse Suite 1402, The Cove Atlantis'), findsOneWidget);
      expect(find.text('\$245.50'), findsOneWidget);
      expect(find.text('Chef Preparing'), findsOneWidget);
      expect(find.text('Assigned Chilled Dispatcher'), findsOneWidget);
    });
  });

  group('E2E Flow 5: Courier Dispatch & Parcel Tracking Workflow', () {
    testWidgets('Courier Lifecycle: Dispatch Form -> Active Tracking with Bonded Escort', (WidgetTester tester) async {
      // 1. Courier Request Screen
      await tester.pumpWidget(
        createTestApp(
          const CourierRequestScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CourierRequestScreen), findsOneWidget);
      expect(find.text('Request a Courier'), findsOneWidget);
      expect(find.text('Pickup Location'), findsOneWidget);
      expect(find.text('Delivery Destination'), findsOneWidget);
      expect(find.text('Package Type'), findsOneWidget);

      // 2. Courier Status Screen with Live Delivery Model
      final sampleDelivery = CourierDeliveryModel(
        id: 618,
        status: 'in_transit',
        pickupAddress: 'Albany Marina Terminal, Nassau',
        dropoffAddress: 'Lyford Cay Club, Bahamas',
        courierName: 'Captain Devon Butler',
        estimatedFare: 75.00,
      );

      await tester.pumpWidget(
        createTestApp(
          CourierDeliveryStatusScreen(delivery: sampleDelivery),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CourierDeliveryStatusScreen), findsOneWidget);
      expect(find.textContaining('#CS-618'), findsWidgets);
      expect(find.textContaining('IN TRANSIT'), findsWidgets);
      expect(find.text('Albany Marina Terminal, Nassau'), findsWidgets);
      expect(find.text('Lyford Cay Club, Bahamas'), findsWidgets);
      expect(find.text('Captain Devon Butler'), findsOneWidget);
    });
  });

  group('E2E Flow 6: Sovereign Multi-Service Booking History & Tabs', () {
    testWidgets('Booking History displays live categories, tabs, and filters', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          const BookingHistoryScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(BookingHistoryScreen), findsOneWidget);
      expect(find.text('History'), findsOneWidget);

      // Verify Tab items
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Past'), findsOneWidget);
      expect(find.text('Cancelled'), findsOneWidget);

      // Tap Past Tab
      await tester.tap(find.text('Past'));
      await tester.pumpAndSettle();

      // Tap Cancelled Tab
      await tester.tap(find.text('Cancelled'));
      await tester.pumpAndSettle();

      // Tap back to Active Tab
      await tester.tap(find.text('Active'));
      await tester.pumpAndSettle();
    });
  });
}
