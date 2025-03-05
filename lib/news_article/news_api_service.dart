import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class NewsApiService {
  static const String _apiKey = '12bef2fd2bc84837bff45e6e7e65414d'; // Replace with actual API key
  static const String _baseUrl = 'https://newsapi.org/v2';

  Future<List<NewsArticle>> fetchNewsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/top-headlines?country=us&category=$category&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articlesList = data['articles'];

      return articlesList
          .map((articleJson) => NewsArticle.fromJson(articleJson))
          .toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}