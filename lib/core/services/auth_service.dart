import 'dart:io';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../storage/local_storage.dart';

class AuthService {
  final ApiClient _api = ApiClient.instance;

  // --- LOGIN ---
  Future<AuthResponseModel> login({required String email, required String password}) async {
    final response = await _api.post(
      ApiEndpoints.login,
      body: {
        'email': email.trim().toLowerCase(),
        'password': password,
      },
    );

    final authResponse = AuthResponseModel.fromJson(response as Map<String, dynamic>);
    // Save tokens and user locally
    await LocalStorage.saveTokens(access: authResponse.access, refresh: authResponse.refresh);
    await LocalStorage.saveUser(authResponse.user);
    return authResponse;
  }

  // --- REGISTRATION ---
  Future<Map<String, dynamic>> initiateRegistration({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    String? phoneNumber,
  }) async {
    final response = await _api.post(
      ApiEndpoints.registerInitiate,
      body: {
        'full_name': fullName.trim(),
        'email': email.trim().toLowerCase(),
        'password': password,
        'confirm_password': confirmPassword,
        if (phoneNumber != null && phoneNumber.isNotEmpty) 'phone_number': phoneNumber.trim(),
      },
    );
    return response as Map<String, dynamic>;
  }

  Future<AuthResponseModel> verifyRegistrationOTP({
    required String email,
    required String otp,
  }) async {
    final response = await _api.post(
      ApiEndpoints.registerVerify,
      body: {
        'email': email.trim().toLowerCase(),
        'otp': otp.trim(),
      },
    );

    final authResponse = AuthResponseModel.fromJson(response as Map<String, dynamic>);
    await LocalStorage.saveTokens(access: authResponse.access, refresh: authResponse.refresh);
    await LocalStorage.saveUser(authResponse.user);
    return authResponse;
  }

  // --- FORGOT PASSWORD ---
  Future<Map<String, dynamic>> initiatePasswordReset(String email) async {
    final response = await _api.post(
      ApiEndpoints.forgetPassInitiate,
      body: {'email': email.trim().toLowerCase()},
    );
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> verifyPasswordResetOTP({required String email, required String otp}) async {
    final response = await _api.post(
      ApiEndpoints.forgetPassVerify,
      body: {
        'email': email.trim().toLowerCase(),
        'otp': otp.trim(),
      },
    );
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await _api.post(
      ApiEndpoints.forgetPassComplete,
      body: {
        'reset_token': resetToken,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );
    return response as Map<String, dynamic>;
  }

  // --- PROFILE ---
  Future<UserModel> getProfile() async {
    final response = await _api.get(ApiEndpoints.me);
    final user = UserModel.fromJson(response as Map<String, dynamic>);
    await LocalStorage.saveUser(user);
    return user;
  }

  Future<UserModel> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? streetAddress,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    File? profileImageFile,
  }) async {
    final fields = <String, String>{};
    if (fullName != null) fields['full_name'] = fullName;
    if (phoneNumber != null) fields['phone_number'] = phoneNumber;
    if (streetAddress != null) fields['street_address'] = streetAddress;
    if (city != null) fields['city'] = city;
    if (state != null) fields['state'] = state;
    if (postalCode != null) fields['postal_code'] = postalCode;
    if (country != null) fields['country'] = country;

    final files = <String, File>{};
    if (profileImageFile != null) {
      files['profile_image'] = profileImageFile;
    }

    final dynamic response;
    if (files.isNotEmpty) {
      response = await _api.multipartRequest('PATCH', ApiEndpoints.updateProfile, fields: fields, files: files);
    } else {
      response = await _api.patch(ApiEndpoints.updateProfile, body: fields);
    }

    final updatedUser = UserModel.fromJson(response as Map<String, dynamic>);
    await LocalStorage.saveUser(updatedUser);
    return updatedUser;
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _api.post(
      ApiEndpoints.changePassword,
      body: {
        'current_password': oldPassword,
        'new_password': newPassword,
        'confirm_new_password': confirmPassword,
      },
    );
  }

  // --- LOGOUT ---
  Future<void> logout() async {
    try {
      final refresh = LocalStorage.getRefreshToken();
      if (refresh != null && refresh.isNotEmpty) {
        await _api.post(ApiEndpoints.logout, body: {'refresh': refresh});
      }
    } catch (_) {
      // Ignore network errors on logout
    } finally {
      await LocalStorage.clearAuth();
    }
  }

  // --- FAVORITES ---
  Future<Map<String, List<dynamic>>> getFavorites() async {
    final response = await _api.get(ApiEndpoints.favorites);
    if (response is Map) {
      final map = Map<String, dynamic>.from(response);
      return {
        'rides': (map['rides'] as List<dynamic>?) ?? [],
        'food': (map['food'] as List<dynamic>?) ?? [],
        'courier': (map['courier'] as List<dynamic>?) ?? [],
        'car_rentals': (map['car_rentals'] as List<dynamic>?) ?? [],
        'properties': (map['properties'] as List<dynamic>?) ?? [],
      };
    }
    return {
      'rides': [],
      'food': [],
      'courier': [],
      'car_rentals': [],
      'properties': [],
    };
  }

  Future<Map<String, dynamic>> toggleFavorite({
    required String serviceType,
    required int objectId,
  }) async {
    final response = await _api.post(
      ApiEndpoints.favoritesToggle,
      body: {
        'service_type': serviceType,
        'object_id': objectId,
      },
    );
    return response as Map<String, dynamic>;
  }
}
