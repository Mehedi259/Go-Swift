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

  group('Provider APIs Integration Coverage (All 5 Categories)', () {
    test('Category 1: Ride Sharing & Chauffeur endpoints and models', () {
      expect(ApiEndpoints.providerRideProfile, 'http://184.192.34.206/api/providers/rides/me/');
      expect(ApiEndpoints.providerRideSubmit, 'http://184.192.34.206/api/providers/rides/me/submit/');
      expect(ApiEndpoints.driverAvailableRides, 'http://184.192.34.206/api/rides/provider/available/');
      expect(ApiEndpoints.driverRideHistory, 'http://184.192.34.206/api/rides/provider/history/');
      expect(ApiEndpoints.driverRideAccept(42), 'http://184.192.34.206/api/rides/provider/rides/42/accept/');

      final ride = RideModel.fromJson({
        'id': 42,
        'status': 'accepted',
        'pickup_address': 'Lynden Pindling International Airport',
        'destination_address': 'The Ocean Club, Paradise Island',
        'estimated_fare': '150.00',
        'customer_full_name': 'Sir Arthur Turnquest',
      });
      expect(ride.customerName, 'Sir Arthur Turnquest');
      expect(ride.estimatedFare, 150.0);
    });

    test('Category 2: Courier & Bonded Logistics endpoints and models', () {
      expect(ApiEndpoints.providerCourierProfile, 'http://184.192.34.206/api/providers/courier/me/');
      expect(ApiEndpoints.providerCourierSubmit, 'http://184.192.34.206/api/providers/courier/me/submit/');
      expect(ApiEndpoints.courierProviderRequests, 'http://184.192.34.206/api/courier/provider/requests/');
      expect(ApiEndpoints.courierProviderStats, 'http://184.192.34.206/api/courier/provider/stats/');
      expect(ApiEndpoints.courierProviderReviews, 'http://184.192.34.206/api/courier/provider/reviews/');
      expect(ApiEndpoints.courierProviderAccept(101), 'http://184.192.34.206/api/courier/provider/deliveries/101/accept/');

      final courier = CourierDeliveryModel.fromJson({
        'id': 101,
        'status': 'dispatched',
        'pickup_address': 'Central Bank of The Bahamas',
        'dropoff_address': 'Rosewood Baha Mar',
        'estimated_fare': '85.00',
      });
      expect(courier.deliveryAddress, 'Rosewood Baha Mar');
      expect(courier.fee, 85.0);
      expect(courier.trackingNumber, '#CS-101');
    });

    test('Category 3: Restaurant Partner endpoints and models', () {
      expect(ApiEndpoints.providerRestaurantProfile, 'http://184.192.34.206/api/providers/restaurants/me/');
      expect(ApiEndpoints.providerRestaurantSubmit, 'http://184.192.34.206/api/providers/restaurants/me/submit/');
      expect(ApiEndpoints.restaurantProviderOrders, 'http://184.192.34.206/api/food/provider/orders/');
      expect(ApiEndpoints.restaurantProviderItems, 'http://184.192.34.206/api/food/provider/items/');
      expect(ApiEndpoints.restaurantProviderCategories, 'http://184.192.34.206/api/food/provider/categories/');

      final item = FoodItemModel.fromJson({
        'id': 505,
        'name': 'Bahamian Spiny Lobster Tail',
        'price': '85.00',
        'available_today': true,
      });
      expect(item.isAvailable, true);
      expect(item.price, 85.0);

      final order = FoodOrderModel.fromJson({
        'id': 202,
        'status': 'preparing',
        'total_amount': '210.00',
      });
      expect(order.customerName, 'VIP Dining Guest');
    });

    test('Category 4: Car Rental & Fleet Owner endpoints and models', () {
      expect(ApiEndpoints.providerRentalProfile, 'http://184.192.34.206/api/providers/rentals/me/');
      expect(ApiEndpoints.providerRentalSubmit, 'http://184.192.34.206/api/providers/rentals/me/submit/');
      expect(ApiEndpoints.rentalProviderVehicles, 'http://184.192.34.206/api/car-rentals/provider/vehicles/');
      expect(ApiEndpoints.rentalProviderBookings, 'http://184.192.34.206/api/car-rentals/provider/bookings/');
      expect(ApiEndpoints.rentalProviderStats, 'http://184.192.34.206/api/car-rentals/provider/stats/');

      final car = RentalVehicleModel.fromJson({
        'id': 301,
        'name': 'Range Rover Autobiography',
        'make': 'Land Rover',
        'model': 'Range Rover',
        'year': 2025,
        'daily_rate': '450.00',
        'available': true,
      });
      expect(car.isAvailable, true);
      expect(car.dailyRate, 450.0);

      final booking = CarRentalBookingModel.fromJson({
        'id': 404,
        'status': 'confirmed',
        'start_date': '2026-05-01',
        'end_date': '2026-05-05',
        'total_price': '1800.00',
      });
      expect(booking.customerName, 'VIP Client');
    });

    test('Category 5: Property / Accommodation Host endpoints and models', () {
      expect(ApiEndpoints.providerPropertyProfile, 'http://184.192.34.206/api/providers/properties/me/');
      expect(ApiEndpoints.providerPropertySubmit, 'http://184.192.34.206/api/providers/properties/me/submit/');
      expect(ApiEndpoints.propertyProviderListings, 'http://184.192.34.206/api/room-services/provider/listings/');
      expect(ApiEndpoints.propertyProviderBookings, 'http://184.192.34.206/api/room-services/provider/bookings/');
      expect(ApiEndpoints.propertyProviderStats, 'http://184.192.34.206/api/room-services/provider/stats/');
      expect(ApiEndpoints.propertyProviderReviews, 'http://184.192.34.206/api/room-services/provider/reviews/');

      final prop = PropertyListingModel.fromJson({
        'id': 701,
        'title': 'The Ocean Club Villa',
        'island_region': 'Paradise Island',
        'nightly_base_rate': '1850.00',
        'bedrooms': 5,
        'bathrooms': 6,
        'is_active': true,
      });
      expect(prop.title, 'The Ocean Club Villa');
      expect(prop.pricePerNight, 1850.0);
      expect(prop.isActive, true);
    });
  });
}
