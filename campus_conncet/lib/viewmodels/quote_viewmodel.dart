import 'package:flutter/material.dart';
import '../services/quote_service.dart';
import '../models/quote.dart';

class QuoteViewModel extends ChangeNotifier {
  final QuoteService _quoteService = QuoteService();
  Quote? _currentQuote;
  bool _isLoading = false;
  String? _errorMessage;

  Quote? get currentQuote => _currentQuote;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadRandomQuote() async {
    _setLoading(true);
    try {
      final quote = await _quoteService.fetchRandomQuote();
      _currentQuote = quote;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
