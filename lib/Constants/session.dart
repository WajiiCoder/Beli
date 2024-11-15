import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_mate/Constants/user_status.dart';

class SessionManager {
  static const String userIdKey = 'userId';
  static const String vendorIdKey = 'vendorId';
  static const String sessionTokenKey = 'sessionToken';
  static const String _tokenKeyPrefix =
      'token_number_'; // Prefix for token keys
  static const String _dateKeyPrefix =
      'last_token_date_'; // Prefix for date keys

  Future<void> saveUserSession(String userId, String sessionToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userIdKey, userId); // Store userId
    await prefs.setString(sessionTokenKey, sessionToken); // Store sessionToken
  }

  Future<void> saveVendorDetails(String vendorId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(vendorIdKey, vendorId); // Store vendorId
  }

  Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getVendorId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(vendorIdKey);
  }

  Future<String?> getSessionToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sessionTokenKey);
  }

  Future<void> clearSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userIdKey);
    await prefs.remove(sessionTokenKey);
    await prefs.remove(vendorIdKey);
  }

  Future<int> generateTokenNumber(String vendorId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String tokenKey = '$_tokenKeyPrefix$vendorId';
    String dateKey = '$_dateKeyPrefix$vendorId';

    DateTime now = DateTime.now().toUtc().add(Duration(hours: 5, minutes: 30));
    DateTime tokenResetTime =
        DateTime(now.year, now.month, now.day, 5, 0); // 5 AM IST

    int currentTokenNumber = prefs.getInt(tokenKey) ?? 0;
    String? lastTokenDateString = prefs.getString(dateKey);
    DateTime? lastTokenDate;

    // Parse the last token date if it exists
    if (lastTokenDateString != null) {
      lastTokenDate = DateTime.parse(lastTokenDateString);
    }

    // Check if it's a new day and needs reset after 5 AM IST
    if (lastTokenDate == null ||
        lastTokenDate.isBefore(tokenResetTime) ||
        now.isAfter(tokenResetTime.add(Duration(days: 1)))) {
      // Reset the token if it's a new day after 5 AM IST
      currentTokenNumber = 1;
      lastTokenDate = tokenResetTime;
    } else {
      // Increment the token number for the same day
      currentTokenNumber++;
    }

    // Store the updated token number and date for this vendor
    await prefs.setInt(tokenKey, currentTokenNumber);
    await prefs.setString(dateKey, now.toIso8601String());

    return currentTokenNumber; // Return the generated token number for this order
  }
}
