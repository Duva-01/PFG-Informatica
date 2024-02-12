import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://10.0.2.2:5000';

Future<String> getRecommendation(String symbol) async {
  final response = await http.get(Uri.parse('$baseUrl/recommendations/$symbol'));
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return data['recommendation'];
  } else {
    throw Exception('Failed to load recommendation');
  }
}
