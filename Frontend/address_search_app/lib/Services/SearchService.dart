import 'dart:convert';
import 'package:address_search_app/Models/SearchModel.dart';
import 'package:http/http.dart' as http;

class Searchservice {
  final String apiKey = "pk.2b24007f131318bc38660ebdaba4ff74";

  /// Search theo từ khóa
  Future<List<Searchmodel>> searchAddress(String query) async {
    final url = Uri.parse(
      "https://us1.locationiq.com/v1/search?key=$apiKey&q=$query&format=json",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data.map((item) {
        return Searchmodel(
          displayName: item["display_name"],
          lat: item["lat"],
          lon: item["lon"],
        );
      }).toList();
    } else {
      throw Exception("Failed to fetch data from LocationIQ API");
    }
  }

  /// Reverse geocoding: Lấy địa chỉ từ lat/lon
  Future<Searchmodel> reverseAddress(String lat, String lon) async {
    final url = Uri.parse(
      "https://us1.locationiq.com/v1/reverse?key=$apiKey&lat=$lat&lon=$lon&format=json",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return Searchmodel(
        displayName: data["display_name"],
        lat: data["lat"].toString(),
        lon: data["lon"].toString(),
      );
    } else {
      throw Exception("Failed to fetch reverse geocoding data");
    }
  }
}
