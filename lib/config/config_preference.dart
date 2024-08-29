import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mekinaye/config/localization/localization_manager.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ConfigPreference {
  // Prevent instantiation
  ConfigPreference._();

  // Shared Preferences instance
  static late SharedPreferences _sharedPreferences;

  // Storing keys
  static const String _currentLocalKey = 'current_local';
  static const String _lightThemeKey = 'is_theme_light';
  static const String _isFirstLaunchKey = 'is_first_launch';
  static const String _idKey = 'id';
  static const String _firstNameKey = 'first_name';
  static const String _lastNameKey = 'last_name';
  static const String _emailKey = 'email';
  static const String _statusKey = 'status';
  static const String _userNameKey = 'user_name';
  static const String _phoneNumberKey = 'phone_number';
  static const String _typeKey = 'type';
  static const String _createdAtKey = 'created_at';
  static const String _updatedAtKey = 'updated_at';
  static const String _accessTokenKey = 'access_token';
  RxBool hasConnection = true.obs;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static setStorage(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  /// Set theme to light
  static Future<void> setThemeIsLight(bool lightTheme) =>
      _sharedPreferences.setBool(_lightThemeKey, lightTheme);

  /// Get current theme (light or dark)
  static bool getThemeIsLight() =>
      _sharedPreferences.getBool(_lightThemeKey) ?? true;

  /// Save current language
  static Future<void> setCurrentLanguage(String languageCode) =>
      _sharedPreferences.setString(_currentLocalKey, languageCode);

  /// Get current language
  static Locale getCurrentLocal() {
    String? langCode = _sharedPreferences.getString(_currentLocalKey);
    return langCode == null
        ? LocalizationManager.defaultLanguage
        : LocalizationManager.supportedLanguages[langCode]!;
  }

  /// Check if it's the first launch
  static bool isFirstLaunch() =>
      _sharedPreferences.getBool(_isFirstLaunchKey) ?? true;

  Future<void> checkConnection() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      hasConnection.value = true;
    } else {
      hasConnection.value = false;
    }
  }

  /// Set first launch to completed
  static Future<void> setFirstLaunchCompleted() =>
      _sharedPreferences.setBool(_isFirstLaunchKey, false);

  /// Store user profile information
  static Future<void> storeUserProfile(Map<String, dynamic> userData) async {
    await _sharedPreferences.setInt(_idKey, userData['id']);
    await _sharedPreferences.setString(_firstNameKey, userData['firstName']);
    await _sharedPreferences.setString(_lastNameKey, userData['lastName']);
    await _sharedPreferences.setString(_emailKey, userData['email']);
    // await _sharedPreferences.setInt(_statusKey, userData['status']);
    await _sharedPreferences.setString(_userNameKey, userData['userName']);
    await _sharedPreferences.setString(
        _phoneNumberKey, userData['phoneNumber']);
    await _sharedPreferences.setString(_typeKey, userData['type']);
    await _sharedPreferences.setString(_createdAtKey, userData['createdAt']);
    await _sharedPreferences.setString(_updatedAtKey, userData['updatedAt']);
  }

  static Future<void> storeUserGoogleProfile(
      Map<String, dynamic> userData) async {
    await _sharedPreferences.setInt(_idKey, userData['id']);
    await _sharedPreferences.setString(_firstNameKey, userData['firstName']);
    await _sharedPreferences.setString(_lastNameKey, userData['lastName']);
    await _sharedPreferences.setString(_emailKey, userData['email']);
    // await _sharedPreferences.setInt(_statusKey, userData['status']);
    await _sharedPreferences.setString(_userNameKey, userData['userName']);
    // await _sharedPreferences.setString(_phoneNumberKey, userData['phoneNumber']);
    // await _sharedPreferences.setString(_typeKey, userData['type']);
    // await _sharedPreferences.setString(_createdAtKey, userData['createdAt']);
    // await _sharedPreferences.setString(_updatedAtKey, userData['updatedAt']);
  }

  /// Get user profile information
  static Map<String, dynamic> getUserProfile() {
    return {
      'id': _sharedPreferences.getInt(_idKey),
      'firstName': _sharedPreferences.getString(_firstNameKey),
      'lastName': _sharedPreferences.getString(_lastNameKey),
      'email': _sharedPreferences.getString(_emailKey),
      'status': _sharedPreferences.getInt(_statusKey),
      'userName': _sharedPreferences.getString(_userNameKey),
      'phoneNumber': _sharedPreferences.getString(_phoneNumberKey),
      'type': _sharedPreferences.getString(_typeKey),
      'createdAt': _sharedPreferences.getString(_createdAtKey),
      'updatedAt': _sharedPreferences.getString(_updatedAtKey),
    };
  }

  /// Store access token
  static Future<void> storeAccessToken(String accessToken) async {
    await _sharedPreferences.setString(_accessTokenKey, accessToken);
  }

  static String? getAccessToken() =>
      _sharedPreferences.getString(_accessTokenKey);

  static Future<int> decodeTokenAndGetId() async {
    String? token = getAccessToken();
    if (token != null) {
      List<String> parts = token.split('.');
      if (parts.length != 3) return -1;

      String payload = parts[1];
      String normalized = base64Url.normalize(payload);
      String decoded = utf8.decode(base64Url.decode(normalized));
      Map<String, dynamic> payloadMap = json.decode(decoded);

      return payloadMap['id'] ?? -1;
    } else {
      return -1;
    }
  }

  /// Clear all data from SharedPreferences
  static Future<void> clear() async => await _sharedPreferences.clear();
}
