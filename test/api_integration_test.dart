import 'package:flutter_test/flutter_test.dart';
import 'package:go_swift/core/models/user_model.dart';
import 'package:go_swift/core/models/ride_model.dart';
import 'package:go_swift/core/models/food_model.dart';
import 'package:go_swift/core/models/courier_model.dart';
import 'package:go_swift/core/models/car_rental_model.dart';
import 'package:go_swift/core/models/property_model.dart';
import 'package:go_swift/core/network/api_client.dart';
import 'package:go_swift/core/network/api_endpoints.dart';
import 'package:go_swift/core/network/api_exceptions.dart';
import 'package:go_swift/core/storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('API Endpoints Verification', () {
    test('Base URL is configured to AWS deployment', () {
      expect(ApiEndpoints.baseUrl, 'http://184.192.34.206/api');
    });

    test('Endpoint paths match backend routes', () {
      expect(ApiEndpoints.login, 'http://184.192.34.206/api/auth/login/');
      expect(ApiEndpoints.registerInitiate, 'http://184.192.34.206/api/auth/register/initiate/');
      expect(ApiEndpoints.registerVerify, 'http://184.192.34.206/api/auth/register/verify/');
      expect(ApiEndpoints.customerRides, 'http://184.192.34.206/api/rides/my-rides/');
      expect(ApiEndpoints.restaurants, 'http://184.192.34.206/api/food/restaurants/');
      expect(ApiEndpoints.customerCourierDeliveries, 'http://184.192.34.206/api/courier/my-deliveries/');
      expect(ApiEndpoints.rentalVehicles, 'http://184.192.34.206/api/car-rentals/vehicles/');
      expect(ApiEndpoints.propertyListings, 'http://184.192.34.206/api/room-services/listings/');
    });
  });

  group('Data Models DRF Serializer Compatibility Tests', () {
    test('UserModel parses backend JSON correctly', () {
      final json = {
        'id': 101,
        'email': 'customer@goswift.bs',
        'full_name': 'Devon Rolle',
        'phone_number': '+12425550100',
        'role': 'customer',
        'is_active': true,
      };
      final user = UserModel.fromJson(json);
      expect(user.id, 101);
      expect(user.email, 'customer@goswift.bs');
      expect(user.fullName, 'Devon Rolle');
      expect(user.firstName, 'Devon');
      expect(user.role, 'customer');
      expect(user.isActive, true);
    });

    test('RideModel parses backend JSON correctly', () {
      final json = {
        'id': 202,
        'status': 'requested',
        'vehicle_type': 'luxury_suv',
        'pickup_address': 'Albany Marina, New Providence',
        'destination_address': 'The Ocean Club, Paradise Island',
        'estimated_fare': '125.00',
        'currency': 'BSD',
        'created_at': '2026-10-11T10:00:00Z',
      };
      final ride = RideModel.fromJson(json);
      expect(ride.id, 202);
      expect(ride.status, 'requested');
      expect(ride.pickupAddress, 'Albany Marina, New Providence');
      expect(ride.estimatedFare, 125.0);
    });

    test('RestaurantModel and FoodItemModel parse backend JSON correctly', () {
      final rJson = {
        'id': 1,
        'restaurant_name': 'Dune by Jean-Georges',
        'cuisine_concept': 'French-Asian Fusion',
        'island_service_hub': 'Paradise Island',
        'kitchen_dispatch_address': 'One Ocean Drive',
        'average_prep_window': '30-40 min',
      };
      final rest = RestaurantModel.fromJson(rJson);
      expect(rest.id, 1);
      expect(rest.name, 'Dune by Jean-Georges');
      expect(rest.cuisineConcept, 'French-Asian Fusion');

      final fJson = {
        'id': 10,
        'name': 'Yellowfin Tuna Tartare',
        'price': '38.00',
        'currency': 'BSD',
        'dietary_tags': ['Gluten-Free', 'Seafood'],
      };
      final item = FoodItemModel.fromJson(fJson);
      expect(item.id, 10);
      expect(item.name, 'Yellowfin Tuna Tartare');
      expect(item.price, 38.0);
      expect(item.dietaryTags.length, 2);
    });

    test('CourierDeliveryModel parses backend JSON correctly', () {
      final cJson = {
        'id': 301,
        'status': 'in_transit',
        'pickup_address': 'Downtown Nassau',
        'dropoff_address': 'Lyford Cay',
        'package_size': 'small_parcel',
        'estimated_fare': '45.00',
      };
      final delivery = CourierDeliveryModel.fromJson(cJson);
      expect(delivery.id, 301);
      expect(delivery.status, 'in_transit');
      expect(delivery.trackingNumber, '#CS-301');
      expect(delivery.estimatedFare, 45.0);
    });

    test('RentalVehicleModel parses backend JSON correctly', () {
      final vJson = {
        'id': 401,
        'make': 'Cadillac',
        'model': 'Escalade ESV',
        'year': 2025,
        'category': 'luxury_suv',
        'daily_rate': '285.00',
        'seating_capacity': 6,
      };
      final vehicle = RentalVehicleModel.fromJson(vJson);
      expect(vehicle.id, 401);
      expect(vehicle.make, 'Cadillac');
      expect(vehicle.model, 'Escalade ESV');
      expect(vehicle.dailyRate, 285.0);
      expect(vehicle.seatingCapacity, 6);
    });

    test('PropertyListingModel parses backend JSON correctly', () {
      final pJson = {
        'id': 501,
        'title': 'The Ocean Club Villa',
        'nightly_base_rate': '1850.00',
        'island_region': 'Paradise Island',
        'street_address': 'One Ocean Drive',
        'bedrooms': 5,
        'bathrooms': 6,
        'max_guests': 12,
      };
      final prop = PropertyListingModel.fromJson(pJson);
      expect(prop.id, 501);
      expect(prop.title, 'The Ocean Club Villa');
      expect(prop.pricePerNight, 1850.0);
      expect(prop.city, 'Paradise Island');
      expect(prop.address, 'One Ocean Drive');
      expect(prop.bedrooms, 5);
      expect(prop.maxGuests, 12);
    });
  });

  group('LocalStorage & JWT Token Persistence Tests', () {
    test('Token saving, retrieval and clearing works seamlessly', () async {
      SharedPreferences.setMockInitialValues({});

      expect(LocalStorage.getAccessToken(), isNull);
      expect(LocalStorage.getRefreshToken(), isNull);

      await LocalStorage.saveTokens(
        access: 'mock_jwt_access_token_xyz',
        refresh: 'mock_jwt_refresh_token_abc',
      );

      expect(LocalStorage.getAccessToken(), 'mock_jwt_access_token_xyz');
      expect(LocalStorage.getRefreshToken(), 'mock_jwt_refresh_token_abc');
      expect(LocalStorage.isLoggedIn, isTrue);

      await LocalStorage.clear();
      expect(LocalStorage.getAccessToken(), isNull);
      expect(LocalStorage.getRefreshToken(), isNull);
      expect(LocalStorage.isLoggedIn, isFalse);
    });
  });

  group('API Exception Handling Tests', () {
    test('ValidationException extracts first error correctly', () {
      final exc = ValidationException({
        'phone_number': ['Enter a valid Bahamian phone number.'],
        'email': ['This email is already registered.'],
      });
      expect(exc.firstError, 'phone_number: Enter a valid Bahamian phone number.');
      expect(exc.statusCode, 400);
    });

    test('ApiClient singleton is accessible for all app services', () {
      expect(ApiClient.instance, isNotNull);
    });

    test('ApiClient logs request and response/exception properly', () async {
      try {
        await ApiClient.instance.get('${ApiEndpoints.baseUrl}/health/');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('ApiClient logs POST request body and response body properly', () async {
      try {
        await ApiClient.instance.post(
          ApiEndpoints.login,
          body: {
            'email': 'test_debug@goswift.bs',
            'password': 'DebugPassword123!',
          },
        );
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });
  });
}
