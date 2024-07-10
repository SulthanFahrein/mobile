import 'package:http/http.dart' as http;
import 'package:test_ta_1/config/constants.dart'; // pastikan ini mengarah ke file constants.dart yang berisi baseUrll
import 'package:test_ta_1/model/property.dart';

Future<List<Datum>> fetchProperties() async {
  Uri url = Uri.parse('$baseUrll/api/property/');
  try {
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var data = propertyFromJson(res.body);
      return data.data;
    } else {
      print("Error fetching properties: ${res.statusCode}");
      return [];
    }
  } catch (e) {
    print("Error fetching properties: $e");
    return [];
  }
}

Future<void> searchProperties(String query, Function(List<Datum>) callback) async {
  if (query.isEmpty) {
    callback([]);
    return;
  }

  Uri url = Uri.parse('$baseUrll/api/property/?search=$query');
  try {
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var data = propertyFromJson(res.body);
      List<Datum> filteredProperties = data.data.where((property) =>
        property.name.toLowerCase().contains(query.toLowerCase()) ||
        property.address.toLowerCase().contains(query.toLowerCase())
      ).toList();
      callback(filteredProperties);
    } else {
      print("Error searching properties: ${res.statusCode}");
      callback([]);
    }
  } catch (e) {
    print("Error searching properties: $e");
    callback([]);
  }
}
