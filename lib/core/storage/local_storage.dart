import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class LocalStorage {
  static const String _keyAccessToken = 'gs_access_token';
  static const String _keyRefreshToken = 'gs_refresh_token';
  static const String _keyUser = 'gs_user_data';
  static const String _keyRole = 'gs_user_role';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('LocalStorage.init() must be called before accessing prefs.');
    }
    return _prefs!;
  }

  // --- TOKENS ---
  static Future<void> saveTokens({required String access, String? refresh}) async {
    await init();
    await _prefs!.setString(_keyAccessToken, access);
    if (refresh != null && refresh.isNotEmpty) {
      await _prefs!.setString(_keyRefreshToken, refresh);
    }
  }

  static String? getAccessToken() {
    return _prefs?.getString(_keyAccessToken);
  }

  static String? getRefreshToken() {
    return _prefs?.getString(_keyRefreshToken);
  }

  static bool hasToken() {
    final token = getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // --- USER DATA ---
  static Future<void> saveUser(UserModel user) async {
    await init();
    final jsonStr = jsonEncode(user.toJson());
    await _prefs!.setString(_keyUser, jsonStr);
    await _prefs!.setString(_keyRole, user.role);
  }

  static UserModel? getUser() {
    final jsonStr = _prefs?.getString(_keyUser);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static String? getUserRole() {
    return _prefs?.getString(_keyRole) ?? getUser()?.role;
  }

  static bool get isLoggedIn => hasToken();

  // --- PAYMENT CARDS ---
  static const String _keySavedCards = 'gs_saved_cards';

  static Future<void> savePaymentCards(List<Map<String, dynamic>> cards) async {
    await init();
    final jsonStr = jsonEncode(cards);
    await _prefs!.setString(_keySavedCards, jsonStr);
  }

  static List<Map<String, dynamic>> getPaymentCards() {
    final jsonStr = _prefs?.getString(_keySavedCards);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final list = jsonDecode(jsonStr) as List;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  static const String _keyProviderCategory = 'gs_provider_category';
  static const String _keyActivePortal = 'gs_active_portal';

  static Future<void> saveProviderCategory(String category) async {
    await init();
    await _prefs!.setString(_keyProviderCategory, category);
  }

  static String? getProviderCategory() {
    return _prefs?.getString(_keyProviderCategory);
  }

  static Future<void> saveActivePortal(String portal) async {
    await init();
    await _prefs!.setString(_keyActivePortal, portal);
  }

  static String? getActivePortal() {
    return _prefs?.getString(_keyActivePortal);
  }

  static Future<void> setString(String key, String value) async {
    await init();
    await _prefs!.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  // --- LOGOUT / CLEAR ---
  static Future<void> clearAuth() async {
    await init();
    await _prefs!.remove(_keyAccessToken);
    await _prefs!.remove(_keyRefreshToken);
    await _prefs!.remove(_keyUser);
    await _prefs!.remove(_keyRole);
    await _prefs!.remove(_keyProviderCategory);
    await _prefs!.remove(_keyActivePortal);
    await _prefs!.remove(_keySavedCards);
    await _prefs!.reload();
  }

  static Future<void> clear() => clearAuth();
}
