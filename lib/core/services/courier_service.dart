import '../models/courier_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class CourierService {
  final ApiClient _api = ApiClient.instance;

  // --- FARE ESTIMATE ---
  Future<CourierFareEstimateModel> estimateFare({
    required double distanceKm,
    required int estimatedDurationMinutes,
    String packageSize = 'small_parcel',
    bool transitInsurance = false,
  }) async {
    final response = await _api.post(
      ApiEndpoints.courierFareEstimate,
      body: {
        'distance_km': distanceKm,
        'estimated_duration_minutes': estimatedDurationMinutes,
        'package_size': packageSize,
        'transit_insurance': transitInsurance,
      },
    );
    return CourierFareEstimateModel.fromJson(response as Map<String, dynamic>);
  }

  // --- CUSTOMER DELIVERIES ---
  Future<CourierDeliveryModel> createDelivery({
    int requestedCourierId = 1,
    required String pickupAddress,
    double pickupLatitude = 25.0772,
    double pickupLongitude = -77.3031,
    String? pickupNotes,
    String senderName = 'VIP Guest',
    String senderPhone = '+1 (242) 555-0100',
    required String dropoffAddress,
    double dropoffLatitude = 25.0478,
    double dropoffLongitude = -77.3554,
    String? dropoffNotes,
    String packageSize = 'small_parcel',
    String packageContentsDescription = 'Bonded parcels and documents',
    String recipientName = 'Recipient Concierge',
    String recipientPhone = '+1 (242) 555-0199',
    bool transitInsurance = false,
    bool fragileOrHighValue = false,
  }) async {
    final response = await _api.post(
      ApiEndpoints.customerCourierDeliveries,
      body: {
        'requested_courier_id': requestedCourierId,
        'pickup_address': pickupAddress,
        'pickup_latitude': pickupLatitude,
        'pickup_longitude': pickupLongitude,
        if (pickupNotes != null) 'pickup_instructions': pickupNotes,
        'sender_name': senderName,
        'sender_phone': senderPhone,
        'dropoff_address': dropoffAddress,
        'dropoff_latitude': dropoffLatitude,
        'dropoff_longitude': dropoffLongitude,
        if (dropoffNotes != null) 'delivery_instructions': dropoffNotes,
        'recipient_name': recipientName,
        'recipient_phone': recipientPhone,
        'package_size': packageSize,
        'package_contents_description': packageContentsDescription,
        'fragile_or_high_value': fragileOrHighValue,
        'transit_insurance': transitInsurance,
      },
    );
    return CourierDeliveryModel.fromJson(response as Map<String, dynamic>);
  }

  Future<List<CourierDeliveryModel>> getMyDeliveries() async {
    final response = await _api.get(ApiEndpoints.customerCourierDeliveries);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => CourierDeliveryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CourierDeliveryModel> getDeliveryDetail(int id) async {
    final response = await _api.get(ApiEndpoints.customerCourierDeliveryDetail(id));
    return CourierDeliveryModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> cancelDelivery(int id, {required String reason}) async {
    await _api.post(
      ApiEndpoints.customerCourierDeliveryCancel(id),
      body: {'reason': reason},
    );
  }

  // --- COURIER PROVIDER ---
  Future<List<CourierDeliveryModel>> getProviderRequests() async {
    final response = await _api.get(ApiEndpoints.courierProviderRequests);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => CourierDeliveryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<CourierDeliveryModel>> getProviderHistory() async {
    final response = await _api.get(ApiEndpoints.courierProviderHistory);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => CourierDeliveryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CourierDeliveryModel> acceptDelivery(int id) async {
    final response = await _api.post(ApiEndpoints.courierProviderAccept(id));
    return CourierDeliveryModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> updateDeliveryStatus(int id, {required String status}) async {
    await _api.post(
      ApiEndpoints.courierProviderStatus(id),
      body: {'status': status},
    );
  }
}
