import 'dart:io';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class ProviderApplicationService {
  final ApiClient _api = ApiClient.instance;

  // --- RIDE DRIVER ---
  Future<Map<String, dynamic>> submitDriverApplication({
    required String legalName,
    required String driverLicense,
    required String vehicleCategory,
    required String vehicleMake,
    required String vehicleModel,
    required String vehicleYear,
    required String licensePlate,
    int seatCapacity = 4,
    File? driverLicenseFile,
    File? carRegistrationFile,
  }) async {
    final fields = <String, String>{
      'legal_name': legalName,
      'public_service_driver_license': driverLicense,
      'vehicle_category': vehicleCategory,
      'vehicle_make': vehicleMake,
      'vehicle_model': vehicleModel,
      'vehicle_year': vehicleYear,
      'license_plate': licensePlate,
      'seat_capacity': seatCapacity.toString(),
    };
    final files = <String, File>{};
    if (driverLicenseFile != null) files['bahamian_driving_license_file'] = driverLicenseFile;
    if (carRegistrationFile != null) files['car_registration_file'] = carRegistrationFile;

    final response = files.isNotEmpty
        ? await _api.multipartRequest('POST', ApiEndpoints.providerRideSubmit, fields: fields, files: files)
        : await _api.post(ApiEndpoints.providerRideSubmit, body: fields);
    return response as Map<String, dynamic>;
  }

  // --- COURIER ---
  Future<Map<String, dynamic>> submitCourierApplication({
    required String legalName,
    required String transportMode,
    required String driverLicenseNumber,
    String operatingZone = 'Nassau & Paradise Island',
    File? driverLicenseFile,
  }) async {
    final fields = <String, String>{
      'legal_name': legalName,
      'transport_mode': transportMode,
      'driver_license_number': driverLicenseNumber,
      'operating_island_zone': operatingZone,
    };
    final files = <String, File>{};
    if (driverLicenseFile != null) files['driver_license_file'] = driverLicenseFile;

    final response = files.isNotEmpty
        ? await _api.multipartRequest('POST', ApiEndpoints.providerCourierSubmit, fields: fields, files: files)
        : await _api.post(ApiEndpoints.providerCourierSubmit, body: fields);
    return response as Map<String, dynamic>;
  }

  // --- CAR RENTAL FLEET ---
  Future<Map<String, dynamic>> submitRentalApplication({
    required String companyName,
    required String contactName,
    required String contactNumber,
    required String licenseNumber,
    String primaryBase = 'Nassau',
  }) async {
    final response = await _api.post(
      ApiEndpoints.providerRentalSubmit,
      body: {
        'company_or_host_legal_name': companyName,
        'operational_contact_name': contactName,
        'business_contact_number': contactNumber,
        'rental_license_number': licenseNumber,
        'primary_operating_base': primaryBase,
      },
    );
    return response as Map<String, dynamic>;
  }

  // --- RESTAURANT ---
  Future<Map<String, dynamic>> submitRestaurantApplication({
    required String restaurantName,
    required String cuisineConcept,
    required String address,
    required String licenseNumber,
    String islandHub = 'Nassau & Paradise Island',
  }) async {
    final response = await _api.post(
      ApiEndpoints.providerRestaurantSubmit,
      body: {
        'restaurant_name': restaurantName,
        'cuisine_concept': cuisineConcept,
        'kitchen_dispatch_address': address,
        'business_license_number': licenseNumber,
        'island_service_hub': islandHub,
      },
    );
    return response as Map<String, dynamic>;
  }

  // --- PROPERTY OWNER ---
  Future<Map<String, dynamic>> submitPropertyApplication({
    required String hostName,
    required String email,
    required String phone,
    required String location,
    required String tourismLicenseNumber,
  }) async {
    final response = await _api.post(
      ApiEndpoints.providerPropertySubmit,
      body: {
        'host_name': hostName,
        'official_host_email': email,
        'mobile_phone': phone,
        'primary_property_location': location,
        'tourism_license_number': tourismLicenseNumber,
      },
    );
    return response as Map<String, dynamic>;
  }
}
