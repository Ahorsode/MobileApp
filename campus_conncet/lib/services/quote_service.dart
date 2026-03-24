import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class QuoteService {
  final String _apiUrl = 'https://zenquotes.io/api/random';

  Future<Quote> fetchRandomQuote() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return Quote.fromJson(data[0]);
        } else {
          throw Exception('No quote found in response');
        }
      } else {
        throw Exception('Failed to load quote');
      }
    } catch (e) {
      rethrow;
    }
  }
}
