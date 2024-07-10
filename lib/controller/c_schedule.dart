import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_ta_1/config/constants.dart';

class ScheduleController {
  final String baseUrl = baseUrll;

  Future<void> postSchedule({
    required int idPengguna,
    required int idProperti,
    required String tanggal,
    required String pukul,
  }) async {
    final url = Uri.parse('$baseUrl/api/schedule');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'id_pengguna': idPengguna,
      'id_properti': idProperti,
      'tanggal': tanggal,
      'pukul': pukul,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        print('Schedule posted successfully');
      } else {
        print('Failed to post schedule: ${response.body}');
        throw Exception('Failed to post schedule');
      }
    } catch (e) {
      print('Error posting schedule: $e');
      throw Exception('Failed to post schedule');
    }
  }

  Future<List<Map<String, dynamic>>> getSchedule(int idUser) async {
    final url = Uri.parse('$baseUrl/api/schedule');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['jadwal'] ?? [];
        return responseData.cast<Map<String, dynamic>>().where((schedule) => schedule['id_pengguna'] == idUser).toList();
      } else {
        print('Failed to fetch schedule: ${response.statusCode}');
        throw Exception('Failed to fetch schedule: ${response.body}');
      }
    } catch (e) {
      print('Error fetching schedule: $e');
      throw Exception('Failed to fetch schedule');
    }
  }

  Future<void> updateSchedule({
    required int id_jadwal,
    required String tanggal,
    required String pukul,
  }) async {
    final url = Uri.parse('$baseUrl/api/schedule/$id_jadwal');
    final headers = {'Content-Type': 'application/json'};

    try {
      final body = jsonEncode({
        'tanggal': tanggal,
        'pukul': pukul,
      });

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Schedule updated successfully');
      } else {
        print('Failed to update schedule: ${response.body}');
        throw Exception('Failed to update schedule: ${response.body}');
      }
    } catch (e) {
      print('Error updating schedule: $e');
      throw Exception('Failed to update schedule');
    }
  }

  Future<void> deleteSchedule(int id_jadwal) async {
    final url = Uri.parse('$baseUrl/api/schedule/$id_jadwal');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        print('Schedule deleted successfully');
      } else {
        print('Failed to delete schedule: ${response.body}');
        throw Exception('Failed to delete schedule');
      }
    } catch (e) {
      print('Error deleting schedule: $e');
      throw Exception('Failed to delete schedule');
    }
  }
}
