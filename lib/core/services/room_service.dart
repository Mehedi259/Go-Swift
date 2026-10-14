import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/property_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class RoomService {
  final ApiClient _api = ApiClient.instance;

  // --- LISTINGS ---
  Future<List<PropertyListingModel>> getListings({
    String? search,
    String? region,
    int? bedrooms,
    int? maxGuests,
  }) async {
    final params = <String, String>{};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (region != null && region.isNotEmpty) params['region'] = region;
    if (bedrooms != null) params['bedrooms'] = bedrooms.toString();
    if (maxGuests != null) params['max_guests'] = maxGuests.toString();

    final response = await _api.get(ApiEndpoints.propertyListings, queryParams: params);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => PropertyListingModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PropertyListingModel> getListingDetail(int id) async {
    final response = await _api.get(ApiEndpoints.propertyListingDetail(id));
    return PropertyListingModel.fromJson(response as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> getQuote({
    required int listingId,
    required String checkInDate,
    required String checkOutDate,
    int guestsCount = 2,
  }) async {
    final response = await _api.post(
      ApiEndpoints.roomServiceQuote,
      body: {
        'listing': listingId,
        'check_in_date': checkInDate,
        'check_out_date': checkOutDate,
        'guests_count': guestsCount,
      },
    );
    return response as Map<String, dynamic>;
  }

  // --- BOOKINGS ---
  Future<RoomBookingModel> createBooking({
    required int listingId,
    required String checkInDate,
    required String checkOutDate,
    int numberOfPersons = 2,
    String primaryGuestName = 'VIP Sovereign Guest',
    String primaryGuestContact = '+1 (242) 555-0199',
    String primaryGuestEmail = 'guest@goswift.bs',
    String? guestNote,
  }) async {
    final response = await _api.post(
      ApiEndpoints.customerRoomBookings,
      body: {
        'listing_id': listingId,
        'check_in_date': checkInDate,
        'check_out_date': checkOutDate,
        'number_of_persons': numberOfPersons,
        'primary_guest_full_legal_name': primaryGuestName,
        'primary_guest_contact_number': primaryGuestContact,
        'primary_guest_email': primaryGuestEmail,
        ...?guestNote != null ? {'guest_note': guestNote} : null,
      },
    );
    return RoomBookingModel.fromJson(response as Map<String, dynamic>);
  }

  Future<List<RoomBookingModel>> getMyBookings() async {
    final response = await _api.get(ApiEndpoints.customerRoomBookings);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => RoomBookingModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<RoomBookingModel> getBookingDetail(int id) async {
    final response = await _api.get(ApiEndpoints.customerRoomBookingDetail(id));
    return RoomBookingModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> cancelBooking(int id, {required String reason}) async {
    await _api.post(
      ApiEndpoints.customerRoomBookingCancel(id),
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
      ApiEndpoints.customerRoomBookingReview(id),
      body: {
        'rating': rating,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
        if (stoodOut != null && stoodOut.isNotEmpty) 'stood_out': stoodOut,
      },
    );
    return response as Map<String, dynamic>;
  }

  // --- PROPERTY PROVIDER ---
  Future<List<PropertyListingModel>> getMyListings() async {
    final response = await _api.get(ApiEndpoints.propertyProviderListings);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => PropertyListingModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<RoomBookingModel>> getProviderBookings() async {
    final response = await _api.get(ApiEndpoints.propertyProviderBookings);
    List<dynamic> list = [];
    if (response is List) {
      list = response;
    } else if (response is Map && response['results'] is List) {
      list = response['results'] as List;
    }
    return list.map((e) => RoomBookingModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> confirmBooking(int id) async {
    await _api.post(ApiEndpoints.propertyProviderBookingConfirm(id));
  }

  Future<void> declineBooking(int id) async {
    await _api.post(ApiEndpoints.propertyProviderBookingDecline(id));
  }

  Future<void> completeBooking(int id) async {
    await _api.post(ApiEndpoints.propertyProviderBookingComplete(id));
  }

  Future<Map<String, dynamic>> getProviderStats() async {
    final response = await _api.get(ApiEndpoints.propertyProviderStats);
    return response as Map<String, dynamic>;
  }

  Future<List<dynamic>> getProviderReviews() async {
    final response = await _api.get(ApiEndpoints.propertyProviderReviews);
    if (response is List) return response;
    if (response is Map && response['results'] is List) return response['results'] as List;
    return [];
  }

  Future<PropertyListingModel> createListing({
    required String title,
    String? propertyType,
    required String islandRegion,
    required String streetAddress,
    required double nightlyBaseRate,
    int bedrooms = 3,
    dynamic bathrooms = 2.0,
    int maxGuests = 6,
    String? description,
    List<String>? amenities,
    String? gatedCommunity,
  }) async {
    final double parsedBaths = bathrooms is num ? bathrooms.toDouble() : (double.tryParse(bathrooms.toString()) ?? 2.0);
    final response = await _api.post(
      ApiEndpoints.propertyProviderListings,
      body: {
        'title': title,
        'island_region': islandRegion,
        'street_address': streetAddress,
        'nightly_base_rate': nightlyBaseRate,
        'bedrooms': bedrooms,
        'bathrooms': parsedBaths,
        'max_guests': maxGuests,
        'description': (description != null && description.isNotEmpty)
            ? description
            : 'Exclusive luxury residence in $islandRegion offering premium amenities and panoramic views.',
        'amenities': (amenities != null && amenities.isNotEmpty)
            ? amenities
            : ['Private Pool', 'Ocean View', 'Butler Service', 'Private Beach'],
        if (gatedCommunity != null && gatedCommunity.isNotEmpty) 'gated_community': gatedCommunity,
        'is_active': true,
      },
    );
    return PropertyListingModel.fromJson(response as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> uploadListingPhoto(
    int listingId, {
    File? file,
    String? photoUrl,
    bool isCover = true,
    String caption = 'Cover Photo',
  }) async {
    File uploadFile;
    if (file != null) {
      uploadFile = file;
    } else if (photoUrl != null && photoUrl.isNotEmpty) {
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/listing_${listingId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final res = await http.get(Uri.parse(photoUrl));
      uploadFile = File(tempPath);
      await uploadFile.writeAsBytes(res.bodyBytes);
    } else {
      throw Exception('No photo provided');
    }

    final response = await _api.multipartRequest(
      'POST',
      ApiEndpoints.propertyProviderListingPhotos(listingId),
      fields: {
        'is_cover': isCover.toString(),
        'caption': caption,
      },
      files: {
        'image': uploadFile,
      },
    );
    return response is Map<String, dynamic> ? response : <String, dynamic>{};
  }

  Future<void> seedListingAvailability(int listingId, {int days = 14, double? rateOverride}) async {
    final now = DateTime.now();
    final futures = List.generate(days, (i) {
      final date = now.add(Duration(days: i));
      final dateStr = '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      return _api.post(
        ApiEndpoints.propertyProviderListingAvailability(listingId),
        body: {
          'date': dateStr,
          'is_available': true,
          ...?rateOverride != null ? {'nightly_rate_override': rateOverride} : null,
          'note': 'Standard Open Availability',
        },
      ).catchError((_) => null);
    });
    await Future.wait(futures);
  }
}
