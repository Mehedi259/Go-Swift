import 'dart:io';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class ProviderApplicationService {
  final ApiClient _api = ApiClient.instance;

  // =========================================================================
  // 1. RIDE SHARING / CHAUFFEUR PROVIDER
  // =========================================================================

  Future<Map<String, dynamic>> getRideProfile() async {
    final response = await _api.get(ApiEndpoints.providerRideProfile);
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateRideProfile({
    String? legalName,
    String? contactPhone,
    String? contactEmail,
    String? publicServiceDriverLicense,
    String? businessAddress,
    String? city,
    String? vehicleCategory,
    String? vehicleMake,
    String? vehicleModel,
    int? vehicleYear,
    String? licensePlate,
    String? vin,
    int? seatCapacity,
    bool? onlineAcceptingRequests,
    File? profilePhoto,
    File? vehicleImage,
  }) async {
    final fields = <String, String>{};
    if (legalName != null) fields['legal_name'] = legalName;
    if (contactPhone != null) fields['contact_phone'] = contactPhone;
    if (contactEmail != null) fields['contact_email'] = contactEmail;
    if (publicServiceDriverLicense != null) {
      fields['public_service_driver_license'] = publicServiceDriverLicense;
    }
    if (businessAddress != null) fields['business_address'] = businessAddress;
    if (city != null) fields['city'] = city;
    if (vehicleCategory != null) fields['vehicle_category'] = vehicleCategory;
    if (vehicleMake != null) fields['vehicle_make'] = vehicleMake;
    if (vehicleModel != null) fields['vehicle_model'] = vehicleModel;
    if (vehicleYear != null) fields['vehicle_year'] = vehicleYear.toString();
    if (licensePlate != null) fields['license_plate'] = licensePlate;
    if (vin != null) fields['vin'] = vin;
    if (seatCapacity != null) fields['seat_capacity'] = seatCapacity.toString();
    if (onlineAcceptingRequests != null) {
      fields['online_accepting_requests'] = onlineAcceptingRequests.toString();
    }

    final files = <String, File>{};
    if (profilePhoto != null) files['profile_photo'] = profilePhoto;
    if (vehicleImage != null) files['vehicle_image'] = vehicleImage;

    final response = files.isNotEmpty
        ? await _api.multipartRequest('PATCH', ApiEndpoints.providerRideProfile, fields: fields, files: files)
        : await _api.patch(ApiEndpoints.providerRideProfile, body: fields);
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> submitDriverApplication({
    required String businessName,
    required String legalName,
    required String contactPhone,
    required String contactEmail,
    required String businessAddress,
    required String city,
    required String country,
    required String driverLicense,
    required String vehicleCategory,
    required String vehicleMake,
    required String vehicleModel,
    required int vehicleYear,
    required String licensePlate,
    required String vin,
    int seatCapacity = 4,
    File? profilePhoto,
    File? driverLicenseFile,
    File? carRegistrationFile,
    File? nidCardFile,
    File? bahamianLicenseFile,
    File? vehicleImage,
  }) async {
    final fields = <String, String>{
      'business_name': businessName,
      'legal_name': legalName,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'business_address': businessAddress,
      'city': city,
      'country': country,
      'public_service_driver_license': driverLicense,
      'vehicle_category': vehicleCategory,
      'vehicle_make': vehicleMake,
      'vehicle_model': vehicleModel,
      'vehicle_year': vehicleYear.toString(),
      'license_plate': licensePlate,
      'vin': vin,
      'seat_capacity': seatCapacity.toString(),
    };
    final files = <String, File>{};
    if (profilePhoto != null) files['profile_photo'] = profilePhoto;
    if (driverLicenseFile != null) files['public_service_driver_license_file'] = driverLicenseFile;
    if (carRegistrationFile != null) files['car_registration_file'] = carRegistrationFile;
    if (nidCardFile != null) files['nid_card_file'] = nidCardFile;
    if (bahamianLicenseFile != null) files['bahamian_driving_license_file'] = bahamianLicenseFile;
    if (vehicleImage != null) files['vehicle_image'] = vehicleImage;

    final response = files.isNotEmpty
        ? await _api.multipartRequest('POST', ApiEndpoints.providerRideSubmit, fields: fields, files: files)
        : await _api.post(ApiEndpoints.providerRideSubmit, body: fields);
    return response as Map<String, dynamic>;
  }

  // =========================================================================
  // 2. COURIER & BONDED LOGISTICS PROVIDER
  // =========================================================================

  Future<Map<String, dynamic>> getCourierProfile() async {
    final response = await _api.get(ApiEndpoints.providerCourierProfile);
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateCourierProfile({
    String? legalName,
    String? contactPhone,
    String? contactEmail,
    String? driverLicenseNumber,
    String? operatingZone,
    String? operatingIslandZone,
    String? transportMode,
    bool? onlineAcceptingDispatch,
    File? profilePhoto,
  }) async {
    final fields = <String, String>{};
    if (legalName != null) fields['legal_name'] = legalName;
    if (contactPhone != null) fields['contact_phone'] = contactPhone;
    if (contactEmail != null) fields['contact_email'] = contactEmail;
    if (driverLicenseNumber != null) fields['driver_license_number'] = driverLicenseNumber;
    if (operatingZone != null) fields['operating_island_zone'] = operatingZone;
    if (operatingIslandZone != null) fields['operating_island_zone'] = operatingIslandZone;
    if (transportMode != null) fields['transport_mode'] = transportMode;
    if (onlineAcceptingDispatch != null) {
      fields['online_accepting_dispatch'] = onlineAcceptingDispatch.toString();
    }

    final files = <String, File>{};
    if (profilePhoto != null) files['profile_photo'] = profilePhoto;

    final response = files.isNotEmpty
        ? await _api.multipartRequest('PATCH', ApiEndpoints.providerCourierProfile, fields: fields, files: files)
        : await _api.patch(ApiEndpoints.providerCourierProfile, body: fields);
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> submitCourierApplication({
    required String businessName,
    required String legalName,
    required String contactPhone,
    required String contactEmail,
    required String businessAddress,
    required String city,
    required String country,
    required String transportMode,
    required String driverLicenseNumber,
    String operatingZone = 'Nassau & Paradise Island',
    File? profilePhoto,
    File? driverLicenseFile,
    File? courierPermitFile,
    File? policeRecordFile,
  }) async {
    final fields = <String, String>{
      'business_name': businessName,
      'legal_name': legalName,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'business_address': businessAddress,
      'city': city,
      'country': country,
      'transport_mode': transportMode,
      'driver_license_number': driverLicenseNumber,
      'operating_island_zone': operatingZone,
    };
    final files = <String, File>{};
    if (profilePhoto != null) files['profile_photo'] = profilePhoto;
    if (driverLicenseFile != null) files['driver_license_file'] = driverLicenseFile;
    if (courierPermitFile != null) files['courier_permit_file'] = courierPermitFile;
    if (policeRecordFile != null) files['police_record_certificate_file'] = policeRecordFile;

    final response = files.isNotEmpty
        ? await _api.multipartRequest('POST', ApiEndpoints.providerCourierSubmit, fields: fields, files: files)
        : await _api.post(ApiEndpoints.providerCourierSubmit, body: fields);
    return response as Map<String, dynamic>;
  }

  // =========================================================================
  // 3. RESTAURANT PARTNER
  // =========================================================================

  Future<Map<String, dynamic>> getRestaurantProfile() async {
    final response = await _api.get(ApiEndpoints.providerRestaurantProfile);
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateRestaurantProfile({
    String? restaurantName,
    String? managerOrHeadChefName,
    String? cuisineConcept,
    String? kitchenAddress,
    String? commercialLine,
    String? contactPhone,
    String? contactEmail,
    String? billingEmail,
    String? businessLicenseNumber,
    String? islandServiceHub,
    String? averagePrepWindow,
    bool? acceptingOrders,
    File? logo,
    File? restaurantPhoto,
  }) async {
    final fields = <String, String>{};
    if (restaurantName != null) fields['restaurant_name'] = restaurantName;
    if (managerOrHeadChefName != null) fields['manager_or_head_chef_name'] = managerOrHeadChefName;
    if (cuisineConcept != null) fields['cuisine_concept'] = cuisineConcept;
    if (kitchenAddress != null) fields['kitchen_dispatch_address'] = kitchenAddress;
    if (commercialLine != null) fields['commercial_line'] = commercialLine;
    if (contactPhone != null) fields['contact_phone'] = contactPhone;
    if (contactEmail != null) fields['contact_email'] = contactEmail;
    if (billingEmail != null) fields['billing_email'] = billingEmail;
    if (businessLicenseNumber != null) fields['business_license_number'] = businessLicenseNumber;
    if (islandServiceHub != null) fields['island_service_hub'] = islandServiceHub;
    if (averagePrepWindow != null) fields['average_prep_window'] = averagePrepWindow;
    if (acceptingOrders != null) fields['accepting_orders'] = acceptingOrders.toString();

    final files = <String, File>{};
    if (logo != null) files['logo'] = logo;
    if (restaurantPhoto != null) files['restaurant_photo'] = restaurantPhoto;

    final response = files.isNotEmpty
        ? await _api.multipartRequest('PATCH', ApiEndpoints.providerRestaurantProfile, fields: fields, files: files)
        : await _api.patch(ApiEndpoints.providerRestaurantProfile, body: fields);
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> submitRestaurantApplication({
    required String businessName,
    required String restaurantName,
    required String cuisineConcept,
    required String contactPhone,
    required String contactEmail,
    required String kitchenAddress,
    required String city,
    required String country,
    required String businessLicenseNumber,
    required String managerOrChefName,
    String islandHub = 'Nassau & Paradise Island',
    String averagePrepWindow = '30-45 min',
    File? logo,
    File? restaurantPhoto,
    File? commercialLicenseFile,
  }) async {
    final fields = <String, String>{
      'business_name': businessName,
      'restaurant_name': restaurantName,
      'cuisine_concept': cuisineConcept,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'kitchen_dispatch_address': kitchenAddress,
      'city': city,
      'country': country,
      'business_license_number': businessLicenseNumber,
      'manager_or_head_chef_name': managerOrChefName,
      'island_service_hub': islandHub,
      'average_prep_window': averagePrepWindow,
    };
    final files = <String, File>{};
    if (logo != null) files['logo'] = logo;
    if (restaurantPhoto != null) files['restaurant_photo'] = restaurantPhoto;
    if (commercialLicenseFile != null) files['commercial_license_file'] = commercialLicenseFile;

    final response = files.isNotEmpty
        ? await _api.multipartRequest('POST', ApiEndpoints.providerRestaurantSubmit, fields: fields, files: files)
        : await _api.post(ApiEndpoints.providerRestaurantSubmit, body: fields);
    return response as Map<String, dynamic>;
  }

  // =========================================================================
  // 4. CAR RENTAL & FLEET PROVIDER
  // =========================================================================

  Future<Map<String, dynamic>> getRentalProfile() async {
    final response = await _api.get(ApiEndpoints.providerRentalProfile);
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateRentalProfile({
    String? companyName,
    String? companyOrHostLegalName,
    String? contactName,
    String? operationalContactName,
    String? contactNumber,
    String? businessContactNumber,
    String? contactEmail,
    String? rentalLicenseNumber,
    String? primaryBase,
    String? primaryOperatingBase,
    String? estimatedFleetSize,
    String? estimatedActiveFleetSize,
    File? logo,
  }) async {
    final fields = <String, String>{};
    if (companyName != null) fields['company_or_host_legal_name'] = companyName;
    if (companyOrHostLegalName != null) fields['company_or_host_legal_name'] = companyOrHostLegalName;
    if (contactName != null) fields['operational_contact_name'] = contactName;
    if (operationalContactName != null) fields['operational_contact_name'] = operationalContactName;
    if (contactNumber != null) fields['business_contact_number'] = contactNumber;
    if (businessContactNumber != null) fields['business_contact_number'] = businessContactNumber;
    if (contactEmail != null) fields['contact_email'] = contactEmail;
    if (rentalLicenseNumber != null) fields['rental_license_number'] = rentalLicenseNumber;
    if (primaryBase != null) fields['primary_operating_base'] = primaryBase;
    if (primaryOperatingBase != null) fields['primary_operating_base'] = primaryOperatingBase;
    if (estimatedFleetSize != null) fields['estimated_active_fleet_size'] = estimatedFleetSize;
    if (estimatedActiveFleetSize != null) fields['estimated_active_fleet_size'] = estimatedActiveFleetSize;

    final files = <String, File>{};
    if (logo != null) files['logo'] = logo;

    final response = files.isNotEmpty
        ? await _api.multipartRequest('PATCH', ApiEndpoints.providerRentalProfile, fields: fields, files: files)
        : await _api.patch(ApiEndpoints.providerRentalProfile, body: fields);
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> submitRentalApplication({
    required String businessName,
    required String companyName,
    required String contactName,
    required String contactNumber,
    required String contactEmail,
    required String businessAddress,
    required String city,
    required String country,
    required String licenseNumber,
    String primaryBase = 'Nassau & Paradise Island',
    String estimatedFleetSize = '5-10 vehicles',
    File? logo,
    File? businessLicenseFile,
    File? rentalLicenseFile,
  }) async {
    final fields = <String, String>{
      'business_name': businessName,
      'company_or_host_legal_name': companyName,
      'operational_contact_name': contactName,
      'business_contact_number': contactNumber,
      'contact_phone': contactNumber,
      'contact_email': contactEmail,
      'business_address': businessAddress,
      'city': city,
      'country': country,
      'rental_license_number': licenseNumber,
      'primary_operating_base': primaryBase,
      'estimated_active_fleet_size': estimatedFleetSize,
    };
    final files = <String, File>{};
    if (logo != null) files['logo'] = logo;
    if (businessLicenseFile != null) files['business_license_permit_file'] = businessLicenseFile;
    if (rentalLicenseFile != null) files['rental_license_file'] = rentalLicenseFile;

    final response = files.isNotEmpty
        ? await _api.multipartRequest('POST', ApiEndpoints.providerRentalSubmit, fields: fields, files: files)
        : await _api.post(ApiEndpoints.providerRentalSubmit, body: fields);
    return response as Map<String, dynamic>;
  }

  // =========================================================================
  // 5. PROPERTY / ACCOMMODATION HOST
  // =========================================================================

  Future<Map<String, dynamic>> getPropertyProfile() async {
    final response = await _api.get(ApiEndpoints.providerPropertyProfile);
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updatePropertyProfile({
    Map<String, dynamic>? data,
    String? hostName,
    String? email,
    String? officialHostEmail,
    String? phone,
    String? mobilePhone,
    String? location,
    String? primaryPropertyLocation,
    String? tourismLicenseNumber,
    String? propertyTypology,
    String? portfolioScale,
    String? estimatedPortfolioScale,
    String? payoutBankName,
    String? payoutAccountNumber,
    File? logo,
  }) async {
    final fields = <String, String>{};
    if (data != null) {
      data.forEach((k, v) {
        if (v != null) fields[k] = v.toString();
      });
    }
    if (hostName != null) fields['host_name'] = hostName;
    if (email != null) fields['official_host_email'] = email;
    if (officialHostEmail != null) fields['official_host_email'] = officialHostEmail;
    if (phone != null) fields['mobile_phone'] = phone;
    if (mobilePhone != null) fields['mobile_phone'] = mobilePhone;
    if (location != null) fields['primary_property_location'] = location;
    if (primaryPropertyLocation != null) fields['primary_property_location'] = primaryPropertyLocation;
    if (tourismLicenseNumber != null) fields['tourism_license_number'] = tourismLicenseNumber;
    if (propertyTypology != null) fields['property_typology'] = propertyTypology;
    if (portfolioScale != null) fields['estimated_portfolio_scale'] = portfolioScale;
    if (estimatedPortfolioScale != null) fields['estimated_portfolio_scale'] = estimatedPortfolioScale;
    if (payoutBankName != null) fields['payout_bank_name'] = payoutBankName;
    if (payoutAccountNumber != null) fields['payout_account_number'] = payoutAccountNumber;

    final files = <String, File>{};
    if (logo != null) files['logo'] = logo;

    final response = files.isNotEmpty
        ? await _api.multipartRequest('PATCH', ApiEndpoints.providerPropertyProfile, fields: fields, files: files)
        : await _api.patch(ApiEndpoints.providerPropertyProfile, body: fields);
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> submitPropertyApplication({
    required String businessName,
    required String hostName,
    required String email,
    required String phone,
    required String businessAddress,
    required String city,
    required String country,
    required String location,
    required String tourismLicenseNumber,
    String propertyTypology = 'luxury_villa',
    String estimatedPortfolioScale = '1_property',
    String taxpayerId = 'BSD-TAX-01',
    File? logo,
    File? tourismLicenseFile,
    File? passportFile,
  }) async {
    final fields = <String, String>{
      'business_name': businessName,
      'host_name': hostName,
      'official_host_email': email,
      'contact_email': email,
      'mobile_phone': phone,
      'contact_phone': phone,
      'business_address': businessAddress,
      'city': city,
      'country': country,
      'primary_property_location': location,
      'tourism_license_number': tourismLicenseNumber,
      'property_typology': propertyTypology,
      'estimated_portfolio_scale': estimatedPortfolioScale,
      'taxpayer_identification_number': taxpayerId,
    };
    final files = <String, File>{};
    if (logo != null) files['logo'] = logo;
    if (tourismLicenseFile != null) files['tourism_license_file'] = tourismLicenseFile;
    if (passportFile != null) files['government_id_or_passport_file'] = passportFile;

    final response = files.isNotEmpty
        ? await _api.multipartRequest('POST', ApiEndpoints.providerPropertySubmit, fields: fields, files: files)
        : await _api.post(ApiEndpoints.providerPropertySubmit, body: fields);
    return response as Map<String, dynamic>;
  }
}
