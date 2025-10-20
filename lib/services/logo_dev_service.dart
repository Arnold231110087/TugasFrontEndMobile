import 'dart:convert';
import 'package:http/http.dart' as http;

class LogoDevService {
  static const String _baseUrl = "https://api.logo.dev/search";
  static const String _apiKey = "pk_TRHD3FQCSwWXPz-VC6nfBg";

  Future<List<Map<String, dynamic>>> searchBrandLogos(String query) async {
    if (query.isEmpty) return [];

    final uri = Uri.parse("$_baseUrl?q=${Uri.encodeComponent(query)}");

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer sk_dvYjP5i4RBKeSV1usE4wvQ',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      if (data.isEmpty) return [];

      return data.map<Map<String, dynamic>>((item) {
        final domain = item['domain'] ?? '';
        return {
          'name': item['name'] ?? '',
          'domain': domain,
          'logoUrl':
              'https://img.logo.dev/$domain?token=$_apiKey&size=80&retina=true',
        };
      }).toList();
    } else {
      throw Exception('Gagal fetch logo brand: ${response.statusCode}');
    }
  }
}
