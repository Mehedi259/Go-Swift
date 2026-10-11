class ApiEndpoints {
  // Base API URL on live AWS server
  static const String baseUrl = 'http://184.192.34.206/api';

  // ---------------- AUTH ----------------
  static const String registerInitiate = '$baseUrl/auth/register/initiate/';
  static const String registerVerify = '$baseUrl/auth/register/verify/';
  static const String login = '$baseUrl/auth/login/';
  static const String adminLogin = '$baseUrl/auth/admin/login/';
  static const String logout = '$baseUrl/auth/logout/';
  static const String refreshToken = '$baseUrl/auth/refresh/';
  static const String forgetPassInitiate = '$baseUrl/auth/forget-pass/initiate/';
  static const String forgetPassVerify = '$baseUrl/auth/forget-pass/verify/';
  static const String forgetPassComplete = '$baseUrl/auth/forget-pass/complete/';

  // ---------------- USER & PROFILE ----------------
  static const String me = '$baseUrl/users/me/';
  static const String updateProfile = '$baseUrl/users/me/update/';
  static const String changePassword = '$baseUrl/users/change-password/';
  static const String favorites = '$baseUrl/users/favorites/';
  static const String favoritesToggle = '$baseUrl/users/favorites/toggle/';

  // ---------------- RIDES ----------------
  static const String rideFareEstimate = '$baseUrl/rides/fare-estimate/';
  static const String customerRides = '$baseUrl/rides/my-rides/';
  static String customerRideDetail(int id) => '$baseUrl/rides/my-rides/$id/';
  static String customerRideCancel(int id) => '$baseUrl/rides/my-rides/$id/cancel/';
  static String customerRideReview(int id) => '$baseUrl/rides/my-rides/$id/review/';

  // Driver Rides
  static const String driverAvailableRides = '$baseUrl/rides/provider/available/';
  static const String driverRideHistory = '$baseUrl/rides/provider/history/';
  static String driverRideAccept(int id) => '$baseUrl/rides/provider/rides/$id/accept/';
  static String driverRideArrived(int id) => '$baseUrl/rides/provider/rides/$id/arrived/';
  static String driverRideStart(int id) => '$baseUrl/rides/provider/rides/$id/start/';
  static String driverRideComplete(int id) => '$baseUrl/rides/provider/rides/$id/complete/';
  static String driverRideLocation(int id) => '$baseUrl/rides/provider/rides/$id/location/';

  // ---------------- FOOD & RESTAURANTS ----------------
  static const String restaurants = '$baseUrl/food/restaurants/';
  static String restaurantDetail(int id) => '$baseUrl/food/restaurants/$id/';
  static String restaurantMenu(int id) => '$baseUrl/food/restaurants/$id/menu/';
  static const String customerFoodOrders = '$baseUrl/food/my-orders/';
  static String customerFoodOrderDetail(int id) => '$baseUrl/food/my-orders/$id/';
  static String customerFoodOrderCancel(int id) => '$baseUrl/food/my-orders/$id/cancel/';
  static String customerFoodItemReview(int itemPk) => '$baseUrl/food/my-order-items/$itemPk/review/';

  // Restaurant Provider
  static const String restaurantProviderCategories = '$baseUrl/food/provider/categories/';
  static const String restaurantProviderItems = '$baseUrl/food/provider/items/';
  static String restaurantProviderItemDetail(int id) => '$baseUrl/food/provider/items/$id/';
  static const String restaurantProviderOrders = '$baseUrl/food/provider/orders/';
  static String restaurantProviderOrderDetail(int id) => '$baseUrl/food/provider/orders/$id/';
  static String restaurantProviderOrderStatus(int id) => '$baseUrl/food/provider/orders/$id/status/';

  // ---------------- COURIER ----------------
  static const String courierProviders = '$baseUrl/courier/providers/';
  static String courierProviderDetail(int id) => '$baseUrl/courier/providers/$id/';
  static const String courierFareEstimate = '$baseUrl/courier/fare-estimate/';
  static const String customerCourierDeliveries = '$baseUrl/courier/my-deliveries/';
  static String customerCourierDeliveryDetail(int id) => '$baseUrl/courier/my-deliveries/$id/';
  static String customerCourierDeliveryCancel(int id) => '$baseUrl/courier/my-deliveries/$id/cancel/';
  static String customerCourierDeliveryReview(int id) => '$baseUrl/courier/my-deliveries/$id/review/';

  // Courier Provider
  static const String courierProviderRequests = '$baseUrl/courier/provider/requests/';
  static const String courierProviderHistory = '$baseUrl/courier/provider/history/';
  static const String courierProviderStats = '$baseUrl/courier/provider/stats/';
  static const String courierProviderReviews = '$baseUrl/courier/provider/reviews/';
  static String courierProviderDeliveryDetail(int id) => '$baseUrl/courier/provider/deliveries/$id/';
  static String courierProviderAccept(int id) => '$baseUrl/courier/provider/deliveries/$id/accept/';
  static String courierProviderStatus(int id) => '$baseUrl/courier/provider/deliveries/$id/status/';
  static String courierProviderLocation(int id) => '$baseUrl/courier/provider/deliveries/$id/location/';

  // ---------------- CAR RENTALS ----------------
  static const String rentalVehicles = '$baseUrl/car-rentals/vehicles/';
  static String rentalVehicleDetail(int id) => '$baseUrl/car-rentals/vehicles/$id/';
  static const String carRentalQuote = '$baseUrl/car-rentals/quote/';
  static const String customerCarRentalBookings = '$baseUrl/car-rentals/my-bookings/';
  static String customerCarRentalBookingDetail(int id) => '$baseUrl/car-rentals/my-bookings/$id/';
  static String customerCarRentalBookingCancel(int id) => '$baseUrl/car-rentals/my-bookings/$id/cancel/';
  static String customerCarRentalReview(int id) => '$baseUrl/car-rentals/my-bookings/$id/review/';

  // Car Rental Provider
  static const String rentalProviderVehicles = '$baseUrl/car-rentals/provider/vehicles/';
  static String rentalProviderVehicleDetail(int id) => '$baseUrl/car-rentals/provider/vehicles/$id/';
  static const String rentalProviderBookings = '$baseUrl/car-rentals/provider/bookings/';
  static String rentalProviderBookingDetail(int id) => '$baseUrl/car-rentals/provider/bookings/$id/';
  static String rentalProviderBookingConfirm(int id) => '$baseUrl/car-rentals/provider/bookings/$id/confirm/';
  static String rentalProviderBookingDecline(int id) => '$baseUrl/car-rentals/provider/bookings/$id/decline/';
  static String rentalProviderBookingComplete(int id) => '$baseUrl/car-rentals/provider/bookings/$id/complete/';
  static const String rentalProviderStats = '$baseUrl/car-rentals/provider/stats/';

  // ---------------- ROOM SERVICES / PROPERTIES ----------------
  static const String propertyListings = '$baseUrl/room-services/listings/';
  static String propertyListingDetail(int id) => '$baseUrl/room-services/listings/$id/';
  static const String roomServiceQuote = '$baseUrl/room-services/quote/';
  static const String customerRoomBookings = '$baseUrl/room-services/my-bookings/';
  static String customerRoomBookingDetail(int id) => '$baseUrl/room-services/my-bookings/$id/';
  static String customerRoomBookingCancel(int id) => '$baseUrl/room-services/my-bookings/$id/cancel/';
  static String customerRoomBookingReview(int id) => '$baseUrl/room-services/my-bookings/$id/review/';

  // Property Provider
  static const String propertyProviderListings = '$baseUrl/room-services/provider/listings/';
  static String propertyProviderListingDetail(int id) => '$baseUrl/room-services/provider/listings/$id/';
  static const String propertyProviderBookings = '$baseUrl/room-services/provider/bookings/';
  static String propertyProviderBookingDetail(int id) => '$baseUrl/room-services/provider/bookings/$id/';
  static String propertyProviderBookingConfirm(int id) => '$baseUrl/room-services/provider/bookings/$id/confirm/';
  static String propertyProviderBookingDecline(int id) => '$baseUrl/room-services/provider/bookings/$id/decline/';
  static String propertyProviderBookingComplete(int id) => '$baseUrl/room-services/provider/bookings/$id/complete/';
  static const String propertyProviderStats = '$baseUrl/room-services/provider/stats/';

  // ---------------- PROVIDER APPLICATIONS ----------------
  static const String providerRideSubmit = '$baseUrl/providers/rides/me/submit/';
  static const String providerCourierSubmit = '$baseUrl/providers/courier/me/submit/';
  static const String providerRentalSubmit = '$baseUrl/providers/rentals/me/submit/';
  static const String providerRestaurantSubmit = '$baseUrl/providers/restaurants/me/submit/';
  static const String providerPropertySubmit = '$baseUrl/providers/properties/me/submit/';

  // ---------------- NOTIFICATIONS ----------------
  static const String notifications = '$baseUrl/notifications/';

  // ---------------- SUPPORTS ----------------
  static const String supportTicketsSubmit = '$baseUrl/supports/support-tickets/submit/';
  static const String mySupportTickets = '$baseUrl/supports/support-tickets/my-tickets/';
}
