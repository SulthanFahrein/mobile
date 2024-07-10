import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_ta_1/config/constants.dart';
import 'package:http/http.dart' as http;
import 'package:test_ta_1/controller/c_user.dart';
import 'package:test_ta_1/model/user.dart';
import 'dart:convert';

class SessionProvider with ChangeNotifier {
  static User? _user; // Make _user static
  String? _token;
  AuthController _authController = AuthController();

  String? get token => _token;
  User? get user => _user; // Use static _user

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    return _token;
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    _token = token;
    notifyListeners();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      _user = User.fromJson(jsonDecode(userData));
      notifyListeners();
    }
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
    _user = user;
    notifyListeners();
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    _token = null;
    _user = null;
    notifyListeners();
  }

  void printUserData() {
    if (_user != null) {
      print('User ID: ${_user!.idUser}');
      print('Username: ${_user!.nameUser}');
      print('Email: ${_user!.emailUser}');
      print('Phone: ${_user!.phoneUser}');
      // print other fields if needed
    } else {
      print('No user data available');
    }
    print(token);
  }

  Future<void> login(User user) async {
    try {
      var data = await _authController.login(user);
      String token = data['token'];
      if (token.isNotEmpty) {
        await saveToken(token);
        _user = User.fromJson(data['user']);
        await saveUser(_user!); // Save user data to SharedPreferences
        printUserData();
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    await clearToken();
  }

  Future<void> updateProfile(User user) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrll/api/data_user/edit'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token', // Include bearer token
        },
        body: jsonEncode({
          'name_user': user.nameUser,
          'phone_user': user.phoneUser,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _user = User.fromJson(responseData['user']);
        await saveUser(_user!); // Update user data in SharedPreferences
        notifyListeners();
      } else {
        throw Exception('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
  
}
