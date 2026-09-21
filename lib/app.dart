import 'package:flutter/material.dart';
import 'package:go_swift/features/splash/splash_screen.dart';
import 'package:go_swift/features/onboarding/choose_account_type_screen.dart';
import 'package:go_swift/features/auth/customer_login_screen.dart';
import 'package:go_swift/features/auth/customer_register_screen.dart';
import 'package:go_swift/features/auth/code_verification_screen.dart';
import 'package:go_swift/features/auth/service_category_screen.dart';
import 'package:go_swift/features/auth/driver_register_screen.dart';
import 'package:go_swift/features/auth/courier_register_screen.dart';
import 'package:go_swift/features/auth/rental_provider_register_screen.dart';
import 'package:go_swift/features/auth/restaurant_register_screen.dart';
import 'package:go_swift/features/auth/property_owner_register_screen.dart';
import 'package:go_swift/features/customer/hub/customer_hub_screen.dart';
import 'package:go_swift/features/customer/ride/ride_booking_screen.dart';
import 'package:go_swift/features/customer/ride/ride_waiting_screen.dart';
import 'package:go_swift/features/customer/ride/ride_driver_accepted_screen.dart';
import 'package:go_swift/features/customer/ride/active_ride_screen.dart';
import 'package:go_swift/features/customer/ride/ride_completed_screen.dart';
import 'package:go_swift/features/customer/ride/ride_rating_screen.dart';
import 'package:go_swift/features/customer/food/food_dining_screen.dart';
import 'package:go_swift/features/customer/food/restaurant_details_screen.dart';
import 'package:go_swift/features/customer/food/food_item_details_screen.dart';
import 'package:go_swift/features/customer/food/food_cart_screen.dart';
import 'package:go_swift/features/customer/food/food_checkout_screen.dart';
import 'package:go_swift/features/customer/food/food_order_status_screen.dart';
import 'package:go_swift/features/customer/courier/courier_request_screen.dart';
import 'package:go_swift/features/customer/courier/courier_delivery_status_screen.dart';
import 'package:go_swift/features/customer/courier/courier_rating_screen.dart';
import 'package:go_swift/features/customer/car_rental/car_rental_search_screen.dart';
import 'package:go_swift/features/customer/car_rental/vehicle_details_screen.dart';
import 'package:go_swift/features/customer/car_rental/car_rental_booking_screen.dart';
import 'package:go_swift/features/customer/car_rental/active_car_rental_screen.dart';
import 'package:go_swift/features/customer/properties/properties_search_screen.dart';
import 'package:go_swift/features/customer/properties/property_details_screen.dart';
import 'package:go_swift/features/customer/properties/property_booking_screen.dart';
import 'package:go_swift/features/customer/properties/property_rating_screen.dart';
import 'package:go_swift/features/customer/history/booking_history_screen.dart';
import 'package:go_swift/features/customer/history/cancelled_bookings_screen.dart';
import 'package:go_swift/features/customer/favorites/favorites_screen.dart';
import 'package:go_swift/features/customer/notifications/notifications_screen.dart';
import 'package:go_swift/features/customer/profile/customer_profile_screen.dart';
import 'package:go_swift/features/customer/profile/change_password_screen.dart';
import 'package:go_swift/features/customer/support/support_screen.dart';
import 'package:go_swift/features/provider/driver/driver_availability_screen.dart';
import 'package:go_swift/features/provider/driver/driver_ride_requests_screen.dart';
import 'package:go_swift/features/provider/driver/driver_active_ride_screen.dart';
import 'package:go_swift/features/provider/driver/driver_earnings_screen.dart';
import 'package:go_swift/features/provider/driver/driver_ride_history_screen.dart';
import 'package:go_swift/features/provider/driver/driver_profile_screen.dart';
import 'package:go_swift/features/provider/driver/driver_documents_screen.dart';
import 'package:go_swift/features/provider/driver/driver_ratings_screen.dart';
import 'package:go_swift/features/provider/courier/courier_availability_screen.dart';
import 'package:go_swift/features/provider/courier/courier_requests_screen.dart';
import 'package:go_swift/features/provider/courier/courier_active_delivery_screen.dart';
import 'package:go_swift/features/provider/courier/courier_history_screen.dart';
import 'package:go_swift/features/provider/courier/courier_profile_screen.dart';
import 'package:go_swift/features/provider/restaurant/menu_management_screen.dart';
import 'package:go_swift/features/provider/restaurant/orders_list_screen.dart';
import 'package:go_swift/features/provider/restaurant/order_management_screen.dart';
import 'package:go_swift/features/provider/restaurant/restaurant_profile_screen.dart';
import 'package:go_swift/features/provider/car_rental/vehicle_listings_screen.dart';
import 'package:go_swift/features/provider/car_rental/rental_booking_management_screen.dart';
import 'package:go_swift/features/provider/car_rental/active_rental_management_screen.dart';
import 'package:go_swift/features/provider/car_rental/rental_earnings_screen.dart';
import 'package:go_swift/features/provider/car_rental/rental_provider_profile_screen.dart';
import 'package:go_swift/features/provider/property_owner/property_listings_screen.dart';
import 'package:go_swift/features/provider/property_owner/create_listing_screen.dart';
import 'package:go_swift/features/provider/property_owner/booking_requests_screen.dart';
import 'package:go_swift/features/provider/property_owner/past_bookings_screen.dart';
import 'core/theme/app_theme.dart';

class GoSwiftApp extends StatelessWidget {
  const GoSwiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GO SWIFT Bahamas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: '/',
      routes: {
        '/': (c) => const SplashScreen(),
        '/choose-account': (c) => const ChooseAccountTypeScreen(),
        // Auth
        '/customer/login': (c) => const CustomerLoginScreen(),
        '/customer/register': (c) => const CustomerRegisterScreen(),
        '/verify-code': (c) => const CodeVerificationScreen(),
        '/provider/service-category': (c) => const ServiceCategoryScreen(),
        '/provider/driver/register': (c) => const DriverRegisterScreen(),
        '/provider/courier/register': (c) => const CourierRegisterScreen(),
        '/provider/rental/register': (c) => const RentalProviderRegisterScreen(),
        '/provider/restaurant/register': (c) => const RestaurantRegisterScreen(),
        '/provider/property/register': (c) => const PropertyOwnerRegisterScreen(),
        // Customer
        '/customer/hub': (c) => const CustomerHubScreen(),
        '/customer/ride/booking': (c) => const RideBookingScreen(),
        '/customer/ride/waiting': (c) => const RideWaitingScreen(),
        '/customer/ride/driver-accepted': (c) => const RideDriverAcceptedScreen(),
        '/customer/ride/active': (c) => const ActiveRideScreen(),
        '/customer/ride/completed': (c) => const RideCompletedScreen(),
        '/customer/ride/rating': (c) => const RideRatingScreen(),
        '/customer/food': (c) => const FoodDiningScreen(),
        '/customer/food/restaurant': (c) => const RestaurantDetailsScreen(),
        '/customer/food/item': (c) => const FoodItemDetailsScreen(),
        '/customer/food/cart': (c) => const FoodCartScreen(),
        '/customer/food/checkout': (c) => const FoodCheckoutScreen(),
        '/customer/food/order-status': (c) => const FoodOrderStatusScreen(),
        '/customer/courier/request': (c) => const CourierRequestScreen(),
        '/customer/courier/status': (c) => const CourierDeliveryStatusScreen(),
        '/customer/courier/rating': (c) => const CourierRatingScreen(),
        '/customer/car-rental/search': (c) => const CarRentalSearchScreen(),
        '/customer/car-rental/vehicle': (c) => const VehicleDetailsScreen(),
        '/customer/car-rental/booking': (c) => const CarRentalBookingScreen(),
        '/customer/car-rental/active': (c) => const ActiveCarRentalScreen(),
        '/customer/properties/search': (c) => const PropertiesSearchScreen(),
        '/customer/properties/details': (c) => const PropertyDetailsScreen(),
        '/customer/properties/booking': (c) => const PropertyBookingScreen(),
        '/customer/properties/rating': (c) => const PropertyRatingScreen(),
        '/customer/history': (c) => const BookingHistoryScreen(),
        '/customer/history/cancelled': (c) => const CancelledBookingsScreen(),
        '/customer/favorites': (c) => const FavoritesScreen(),
        '/customer/notifications': (c) => const NotificationsScreen(),
        '/customer/profile': (c) => const CustomerProfileScreen(),
        '/customer/profile/change-password': (c) => const ChangePasswordScreen(),
        '/customer/support': (c) => const SupportScreen(),
        // Provider - Driver
        '/provider/driver/hub': (c) => const DriverAvailabilityScreen(),
        '/provider/driver/requests': (c) => const DriverRideRequestsScreen(),
        '/provider/driver/active-ride': (c) => const DriverActiveRideScreen(),
        '/provider/driver/earnings': (c) => const DriverEarningsScreen(),
        '/provider/driver/history': (c) => const DriverRideHistoryScreen(),
        '/provider/driver/profile': (c) => const DriverProfileScreen(),
        '/provider/driver/documents': (c) => const DriverDocumentsScreen(),
        '/provider/driver/ratings': (c) => const DriverRatingsScreen(),
        // Provider - Courier
        '/provider/courier/hub': (c) => const CourierAvailabilityScreen(),
        '/provider/courier/requests': (c) => const CourierRequestsScreen(),
        '/provider/courier/active': (c) => const CourierActiveDeliveryScreen(),
        '/provider/courier/history': (c) => const CourierHistoryScreen(),
        '/provider/courier/profile': (c) => const CourierProfileScreen(),
        // Provider - Restaurant
        '/provider/restaurant/menu': (c) => const MenuManagementScreen(),
        '/provider/restaurant/orders': (c) => const OrdersListScreen(),
        '/provider/restaurant/order-detail': (c) => const OrderManagementScreen(),
        '/provider/restaurant/profile': (c) => const RestaurantProfileScreen(),
        // Provider - Car Rental
        '/provider/rental/vehicles': (c) => const VehicleListingsScreen(),
        '/provider/rental/bookings': (c) => const RentalBookingManagementScreen(),
        '/provider/rental/active': (c) => const ActiveRentalManagementScreen(),
        '/provider/rental/earnings': (c) => const RentalEarningsScreen(),
        '/provider/rental/profile': (c) => const RentalProviderProfileScreen(),
        // Provider - Property Owner
        '/provider/property/listings': (c) => const PropertyListingsScreen(),
        '/provider/property/create': (c) => const CreateListingScreen(),
        '/provider/property/requests': (c) => const BookingRequestsScreen(),
        '/provider/property/past-bookings': (c) => const PastBookingsScreen(),
      },
    );
  }
}
