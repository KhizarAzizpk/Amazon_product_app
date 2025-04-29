import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class AmazonService {
  static const String _baseUrl = 'https://real-time-amazon-data.p.rapidapi.com/search';
  static const Map<String, String> _headers = {
    'x-rapidapi-host': 'real-time-amazon-data.p.rapidapi.com',
    'x-rapidapi-key': '183f1a0973mshd1fd32c2fab27d4p111804jsn276c398cb193',
  };

  static Future<List<Product>> fetchProducts({required int page}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?query=Gifts%20for%20Kids&page=$page&page_size=100&country=US&sort_by=RELEVANCE&product_condition=ALL&is_prime=false&deals_and_discounts=NONE'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List productsJson = jsonData['data']['products'];

      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load page $page');
    }
  }
}
