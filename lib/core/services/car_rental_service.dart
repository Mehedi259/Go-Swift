import 'dart:io';
import '../models/car_rental_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class CarRentalService {
  final ApiClient _api = ApiClient.instance;

  // --- VEHICLES ---
  Future<List<RentalVehicleModel>> getVehicles({String? category, String? search}) async {
    final params = <String, String>{};
    if (category != null && category.isNotEmpty) params['category'] = category;
    if (search != null && search.isNotEmpty) params['search'] = search;

    final response = await _api.get(ApiEndpoints.rentalVehicles, queryParams: params);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => RentalVehicleModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<RentalVehicleModel> getVehicleDetail(int id) async {
    final response = await _api.get(ApiEndpoints.rentalVehicleDetail(id));
    return RentalVehicleModel.fromJson(response as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> getQuote({
    required int vehicleId,
    required String startDate,
    required String endDate,
    bool includesInsurance = true,
  }) async {
    final response = await _api.post(
      ApiEndpoints.carRentalQuote,
      body: {
        'vehicle': vehicleId,
        'start_date': startDate,
        'end_date': endDate,
        'includes_insurance': includesInsurance,
      },
    );
    return response as Map<String, dynamic>;
  }

  // --- BOOKINGS ---
  Future<CarRentalBookingModel> createBooking({
    required int vehicleId,
    required String startDate,
    required String endDate,
    String pickupHandoverStation = 'Lynden Pindling International Airport (NAS)',
    String handoverTime = '10:00:00',
    bool deliverToVillaOrHotel = false,
    String? deliveryAddress,
    String? customerNote,
  }) async {
    final response = await _api.post(
      ApiEndpoints.customerCarRentalBookings,
      body: {
        'vehicle_id': vehicleId,
        'start_date': startDate,
        'end_date': endDate,
        'pickup_handover_station': pickupHandoverStation,
        'handover_time': handoverTime,
        'deliver_to_villa_or_hotel': deliverToVillaOrHotel,
        'delivery_address': ?deliveryAddress,
        'customer_note': ?customerNote,
      },
    );
    return CarRentalBookingModel.fromJson(response as Map<String, dynamic>);
  }

  Future<List<CarRentalBookingModel>> getMyBookings() async {
    final response = await _api.get(ApiEndpoints.customerCarRentalBookings);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => CarRentalBookingModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CarRentalBookingModel> getBookingDetail(int id) async {
    final response = await _api.get(ApiEndpoints.customerCarRentalBookingDetail(id));
    return CarRentalBookingModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> cancelBooking(int id, {required String reason}) async {
    await _api.post(
      ApiEndpoints.customerCarRentalBookingCancel(id),
      body: {'reason': reason},
    );
  }

  Future<Map<String, dynamic>> reviewBooking(
    int id, {
    required int rating,
    String? notes,
    List<String>? stoodOut,
  }) async {
    final response = await _api.post(
      ApiEndpoints.customerCarRentalReview(id),
      body: {
        'rating': rating,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
        if (stoodOut != null && stoodOut.isNotEmpty) 'stood_out': stoodOut,
      },
    );
    return response as Map<String, dynamic>;
  }

  // --- PROVIDER FLEET ---
  Future<List<RentalVehicleModel>> getFleetVehicles() async {
    final response = await _api.get(ApiEndpoints.rentalProviderVehicles);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => RentalVehicleModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<CarRentalBookingModel>> getFleetBookings() async {
    final response = await _api.get(ApiEndpoints.rentalProviderBookings);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => CarRentalBookingModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> confirmBooking(int id) async {
    await _api.post(ApiEndpoints.rentalProviderBookingConfirm(id));
  }

  Future<void> declineBooking(int id) async {
    await _api.post(ApiEndpoints.rentalProviderBookingDecline(id));
  }

  Future<void> completeBooking(int id) async {
    await _api.post(ApiEndpoints.rentalProviderBookingComplete(id));
  }

  Future<Map<String, dynamic>> getProviderStats() async {
    final response = await _api.get(ApiEndpoints.rentalProviderStats);
    return response as Map<String, dynamic>;
  }

  Future<List<dynamic>> getProviderReviews() async {
    final response = await _api.get(ApiEndpoints.rentalProviderReviews);
    if (response is List) return response;
    if (response is Map && response['results'] is List) return response['results'] as List;
    return [];
  }

  Future<RentalVehicleModel> addVehicle({
    required String make,
    required String model,
    required int year,
    String category = 'luxury_suv',
    required double dailyRate,
    required String licensePlate,
    int seatingCapacity = 5,
    int luggageCapacity = 3,
    double securityEscrowDeposit = 500.0,
    String transmission = 'automatic',
    String fuelType = 'gasoline',
    String location = 'Downtown Nassau & Lynden Pindling FBO',
  }) async {
    final response = await _api.post(
      ApiEndpoints.rentalProviderVehicles,
      body: {
        'name': '$make $model',
        'make': make,
        'model': model,
        'year': year,
        'category': category,
        'daily_rate': dailyRate,
        'license_plate': licensePlate,
        'seating_capacity': seatingCapacity,
        'luggage_capacity': luggageCapacity.toString(),
        'security_escrow_deposit': securityEscrowDeposit.toStringAsFixed(2),
        'transmission': transmission,
        'fuel_type': fuelType,
        'location': location,
      },
    );
    return RentalVehicleModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteVehicle(int id) async {
    await _api.delete(ApiEndpoints.rentalProviderVehicleDetail(id));
  }

  Future<Map<String, dynamic>> uploadVehicleMedia({
    required int vehicleId,
    required File imageFile,
    String? caption,
  }) async {
    final response = await _api.multipartRequest(
      'POST',
      ApiEndpoints.rentalProviderVehicleMedia(vehicleId),
      fields: {
        if (caption != null && caption.isNotEmpty) 'caption': caption,
      },
      files: {
        'image': imageFile,
      },
    );
    return response is Map<String, dynamic> ? response : <String, dynamic>{};
  }
}
