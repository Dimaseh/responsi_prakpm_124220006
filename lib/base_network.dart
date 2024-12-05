import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsi_124220006/karakter.dart';

class ApiService {
  Future<List<Amiibo>> fetchAmiibos() async {
    final response =
        await http.get(Uri.parse('https://amiiboapi.com/api/amiibo/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body)['amiibo'];
      return jsonResponse.map((data) => Amiibo.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load Amiibo data');
    }
  }
}
