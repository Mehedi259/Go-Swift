import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../storage/local_storage.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => LocalStorage.hasToken() && _user != null;
  String get userRole => _user?.role ?? LocalStorage.getUserRole() ?? 'customer';

  Future<void> init() async {
    await LocalStorage.init();
    _user = LocalStorage.getUser();
    notifyListeners();

    if (LocalStorage.hasToken()) {
      try {
        _user = await _authService.getProfile();
        notifyListeners();
      } catch (_) {
        // Token might have expired or network is unreachable; leave offline user intact
      }
    }
  }

  // --- LOGIN ---
  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final authResponse = await _authService.login(email: email, password: password);
      _user = authResponse.user;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // --- REGISTRATION INITIATE ---
  Future<bool> initiateRegistration({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    String? phoneNumber,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authService.initiateRegistration(
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // --- REGISTRATION VERIFY OTP ---
  Future<bool> verifyRegistrationOTP({
    required String email,
    required String otp,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final authResponse = await _authService.verifyRegistrationOTP(email: email, otp: otp);
      _user = authResponse.user;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // --- PROFILE UPDATE ---
  Future<bool> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? streetAddress,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    File? profileImageFile,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _user = await _authService.updateProfile(
        fullName: fullName,
        phoneNumber: phoneNumber,
        streetAddress: streetAddress,
        city: city,
        state: state,
        postalCode: postalCode,
        country: country,
        profileImageFile: profileImageFile,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // --- CHANGE PASSWORD ---
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // --- LOGOUT ---
  Future<void> logout() async {
    _setLoading(true);
    await _authService.logout();
    _user = null;
    _setLoading(false);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
