import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  // Base URL for the API
  final String baseUrl = 'newsapi.org';
  final String apiKey =
      'a6223aa23a3a47fba9de1043fe75202c'; // You'll get this from registration

  // Method to fetch news articles with optional category
  Future<List<Article>> fetchNewsArticles({String? category}) async {
    // 1. Build the URL properly
    final uri = Uri.https(baseUrl, '/v2/top-headlines', {
      'country': 'us',
      'apiKey': apiKey,
      if (category != null) 'category': category.toLowerCase(),
    });

    // 2. Make the network request [citation:9]
    final response = await http.get(uri);

    // 3. Check status code [citation:9]
    if (response.statusCode == 200) {
      // 4. Parse JSON response [citation:9]
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      // 5. Extract articles array
      final List<dynamic> articlesJson = jsonData['articles'];

      // 6. Convert each JSON object to Article model
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      // 7. Handle errors [citation:9]
      throw Exception('Failed to load news: ${response.statusCode}');
    }
  }
}
