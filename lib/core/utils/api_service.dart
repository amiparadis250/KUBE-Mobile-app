import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // Using Render hosted backend - works on all devices!
  static const String baseUrl = 'https://kube-systems.onrender.com/api';
  
  static const Duration timeout = Duration(seconds: 30); // Increased for cloud server

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Auth endpoints
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      debugPrint('🌐 API CALL: POST $baseUrl/auth/login');
      debugPrint('📤 Request Body: {"email": "$email", "password": "***"}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(timeout);
      
      debugPrint('📥 Response Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] && data['data']['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['data']['token']);
        }
        return data;
      }
      throw Exception('Login failed: ${response.body}');
    } catch (e) {
      debugPrint('❌ API ERROR: $e');
      throw Exception('Cannot connect to server. Please check: \n1. Backend is running\n2. API URL is correct for your device\n3. Device and computer are on same network');
    }
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] && data['data']['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['data']['token']);
      }
      return data;
    }
    throw Exception('Registration failed: ${response.body}');
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Dashboard endpoints
  static Future<Map<String, dynamic>> getDashboardOverview() async {
    debugPrint('🌐 API CALL: GET $baseUrl/dashboard/overview');
    
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/overview'),
      headers: await _getHeaders(),
    );
    
    debugPrint('📥 Response Status: ${response.statusCode}');
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getFarmDashboard() async {
    debugPrint('🌐 API CALL: GET $baseUrl/dashboard/farm');
    
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/farm'),
      headers: await _getHeaders(),
    );
    
    debugPrint('📥 Response Status: ${response.statusCode}');
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getParkDashboard() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/park'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getLandDashboard() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/land'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  // Farm endpoints
  static Future<Map<String, dynamic>> getFarms() async {
    final response = await http.get(
      Uri.parse('$baseUrl/farms'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getFarmById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/farms/$id'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  // Park endpoints
  static Future<Map<String, dynamic>> getParks() async {
    final response = await http.get(
      Uri.parse('$baseUrl/parks'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getParkById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/parks/$id'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  // Land endpoints
  static Future<Map<String, dynamic>> getLandZones() async {
    final response = await http.get(
      Uri.parse('$baseUrl/land/zones'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getLandZoneById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/land/zones/$id'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  // Alert endpoints
  static Future<Map<String, dynamic>> getAlerts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/alerts'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getAlertStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/alerts/stats'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }
}