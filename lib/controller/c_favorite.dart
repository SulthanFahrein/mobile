import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_ta_1/config/constants.dart';

class FavoriteController {
  Future<void> postFavorite({
    required int idPengguna,
    required int idProperti,
  }) async {
    final url = Uri.parse('$baseUrll/api/favorite');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'id_pengguna': idPengguna,
      'id_properti': idProperti,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        print('Favorite posted successfully');
      } else {
        print('Failed to post Favorite: ${response.body}');
        throw Exception('Failed to post Favorite');
      }
    } catch (e) {
      print('Error posting Favorite: $e');
      throw Exception('Failed to post Favorite');
    }
  }

  Future<List<dynamic>> getFavorite(int idUser) async {
    final url = Uri.parse('$baseUrll/api/favorite');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> favorites = responseData['favorite'] ?? [];
        return favorites.where((favorite) => favorite['id_pengguna'] == idUser).toList();
      } else {
        print('Failed to fetch Favorite: ${response.statusCode}');
        throw Exception('Failed to fetch Favorite: ${response.body}');
      }
    } catch (e) {
      print('Error fetching Favorite: $e');
      throw Exception('Failed to fetch Favorite');
    }
  }

  Future<void> deleteFavorite(int id_favorite) async {
    final url = Uri.parse('$baseUrll/api/favorite/$id_favorite');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        print('Favorite deleted successfully');
      } else {
        print('Failed to delete Favorite: ${response.body}');
        throw Exception('Failed to delete Favorite');
      }
    } catch (e) {
      print('Error deleting Favorite: $e');
      throw Exception('Failed to delete Favorite');
    }
  }
}
