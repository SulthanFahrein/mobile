import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_ta_1/config/constants.dart';

import 'package:test_ta_1/model/user.dart';
class AuthController {
  final String baseUrl = baseUrll;

  Future<dynamic> login(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/data_user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email_user': user.emailUser,
        'password': user.password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to loginnnnnnnnnnnnn: ${response.body}');
    }
  }

  Future<String> register(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/data_user/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name_user': user.nameUser,
        'phone_user': user.phoneUser,
        'email_user': user.emailUser,
        'password': user.password,
      }),
    );

    if (response.statusCode == 201) {
      return 'Registration Successful';
    } else {
      throw Exception('Registration Failed: ${response.body}');
    }
  }

  

}
