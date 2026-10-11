import '../models/ride_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class RideService {
  final ApiClient _api = ApiClient.instance;

  // --- CUSTOMER RIDES ---
  Future<FareEstimateModel> estimateFare({
    required double distanceKm,
    required int estimatedDurationMinutes,
    int passengerCount = 1,
  }) async {
    final response = await _api.post(
      ApiEndpoints.rideFareEstimate,
      body: {
        'distance_km': distanceKm,
        'estimated_duration_minutes': estimatedDurationMinutes,
        'requested_passenger_count': passengerCount,
      },
    );
    return FareEstimateModel.fromJson(response as Map<String, dynamic>);
  }

  Future<RideModel> createRide({
    required String pickupAddress,
    double? pickupLatitude,
    double? pickupLongitude,
    String? pickupNote,
    required String destinationAddress,
    double? destinationLatitude,
    double? destinationLongitude,
    int requestedPassengerCount = 1,
    String? requestedVehicleCategory,
    double? distanceKm,
    int? estimatedDurationMinutes,
    String? paymentMethodReference,
  }) async {
    final response = await _api.post(
      ApiEndpoints.customerRides,
      body: {
        'pickup_address': pickupAddress,
        if (pickupLatitude != null) 'pickup_latitude': pickupLatitude,
        if (pickupLongitude != null) 'pickup_longitude': pickupLongitude,
        if (pickupNote != null) 'pickup_note': pickupNote,
        'destination_address': destinationAddress,
        if (destinationLatitude != null) 'destination_latitude': destinationLatitude,
        if (destinationLongitude != null) 'destination_longitude': destinationLongitude,
        'requested_passenger_count': requestedPassengerCount,
        if (requestedVehicleCategory != null) 'requested_vehicle_category': requestedVehicleCategory,
        if (distanceKm != null) 'distance_km': distanceKm,
        if (estimatedDurationMinutes != null) 'estimated_duration_minutes': estimatedDurationMinutes,
        if (paymentMethodReference != null) 'payment_method_reference': paymentMethodReference,
      },
    );
    return RideModel.fromJson(response as Map<String, dynamic>);
  }

  Future<List<RideModel>> getMyRides() async {
    final response = await _api.get(ApiEndpoints.customerRides);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => RideModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<RideModel> getRideDetail(int id) async {
    final response = await _api.get(ApiEndpoints.customerRideDetail(id));
    return RideModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> cancelRide(int id, {required String reason}) async {
    await _api.post(
      ApiEndpoints.customerRideCancel(id),
      body: {'reason': reason},
    );
  }

  Future<void> reviewRide(
    int id, {
    required int rating,
    String? notes,
    List<String>? stoodOut,
    double? tipAmount,
  }) async {
    await _api.post(
      ApiEndpoints.customerRideReview(id),
      body: {
        'rating': rating,
        if (notes != null) 'notes': notes,
        if (stoodOut != null) 'stood_out': stoodOut,
        if (tipAmount != null) 'tip_amount': tipAmount,
      },
    );
  }

  // --- DRIVER ACTIONS ---
  Future<List<RideModel>> getAvailableRides() async {
    final response = await _api.get(ApiEndpoints.driverAvailableRides);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => RideModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<RideModel>> getDriverRideHistory() async {
    final response = await _api.get(ApiEndpoints.driverRideHistory);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => RideModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<RideModel> acceptRide(int id) async {
    final response = await _api.post(ApiEndpoints.driverRideAccept(id));
    return RideModel.fromJson(response as Map<String, dynamic>);
  }

  Future<RideModel> arrivedAtPickup(int id) async {
    final response = await _api.post(ApiEndpoints.driverRideArrived(id));
    return RideModel.fromJson(response as Map<String, dynamic>);
  }

  Future<RideModel> startRide(int id) async {
    final response = await _api.post(ApiEndpoints.driverRideStart(id));
    return RideModel.fromJson(response as Map<String, dynamic>);
  }

  Future<RideModel> completeRide(int id) async {
    final response = await _api.post(ApiEndpoints.driverRideComplete(id));
    return RideModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> updateDriverLocation(int id, {required double lat, required double lng}) async {
    await _api.post(
      ApiEndpoints.driverRideLocation(id),
      body: {'latitude': lat, 'longitude': lng},
    );
  }
}
