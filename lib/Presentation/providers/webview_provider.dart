import 'package:flutter/material.dart';

class WebViewProvider extends ChangeNotifier {
  String _currentUrl = 'https://store.steampowered.com';
  bool _isLoading = false;
  String? _error;

  String get currentUrl => _currentUrl;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setUrl(String url) {
    _currentUrl = url;
    _error = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }
}
