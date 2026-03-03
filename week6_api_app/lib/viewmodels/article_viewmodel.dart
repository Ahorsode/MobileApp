import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';
import '../services/api_service.dart';

class ArticleViewModel extends ChangeNotifier {
  // Dependencies
  final ApiService _apiService = ApiService();

  // State variables
  List<Article> _articles = [];
  List<Article> _savedArticles = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentCategory;

  // Getters for UI to access state
  List<Article> get articles => _articles;
  List<Article> get savedArticles => _savedArticles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get currentCategory => _currentCategory;

  // Persistence Key
  static const String _bookmarksKey = 'saved_articles';

  // Method to load data
  Future<void> loadArticles({
    String? category,
    bool isRefreshing = false,
  }) async {
    if (!isRefreshing) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    _currentCategory = category;

    try {
      _articles = await _apiService.fetchNewsArticles(category: category);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }

    // Load bookmarks when initializing or loading
    if (_savedArticles.isEmpty) {
      await loadSavedArticles();
    }
  }

  // Refresh method
  Future<void> refreshArticles() async {
    await loadArticles(category: _currentCategory, isRefreshing: true);
  }

  // --- Persistence Logic ---

  Future<void> loadSavedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final String? bookmarksJson = prefs.getString(_bookmarksKey);

    if (bookmarksJson != null) {
      final List<dynamic> decoded = jsonDecode(bookmarksJson);
      _savedArticles = decoded.map((json) => Article.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> toggleBookmark(Article article) async {
    final isSaved = _savedArticles.any((a) => a.url == article.url);

    if (isSaved) {
      _savedArticles.removeWhere((a) => a.url == article.url);
    } else {
      _savedArticles.add(article);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _bookmarksKey,
      jsonEncode(_savedArticles.map((a) => a.toJson()).toList()),
    );

    notifyListeners();
  }

  bool isArticleSaved(Article article) {
    return _savedArticles.any((a) => a.url == article.url);
  }
}
