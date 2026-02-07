import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Model/news/news_model.dart';
import '../../core/services/news/news_service.dart';

enum NewsLoadingState {
  initial,
  loading,
  loaded,
  error,
}

class NewsViewModel extends ChangeNotifier {
  final NewsService _newsService;

  NewsViewModel(this._newsService) {
    getAllNews();
  }

  // State management
  NewsLoadingState _loadingState = NewsLoadingState.initial;
  List<NewsModel> _newsList = [];
  NewsModel? _selectedNews;
  String? _errorMessage;
  String? _selectedCategory;

  // Getters
  NewsLoadingState get loadingState => _loadingState;
  List<NewsModel> get newsList => _newsList;
  NewsModel? get selectedNews => _selectedNews;
  String? get errorMessage => _errorMessage;
  String? get selectedCategory => _selectedCategory;
  bool get isLoading => _loadingState == NewsLoadingState.loading;
  bool get hasError => _loadingState == NewsLoadingState.error;
  bool get isEmpty => _newsList.isEmpty && _loadingState == NewsLoadingState.loaded;

  // Get filtered news by category
  List<NewsModel> get filteredNews {
    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      return _newsList;
    }
    return _newsList.where((news) => news.category == _selectedCategory).toList();
  }

  // Get unique categories from news list
  List<String> get categories {
    final categorySet = <String>{};
    for (final news in _newsList) {
      if (news.category != null && news.category!.isNotEmpty) {
        categorySet.add(news.category!);
      }
    }
    return categorySet.toList()..sort();
  }

  // Set loading state
  void _setLoadingState(NewsLoadingState state) {
    _loadingState = state;
    notifyListeners();
  }

  // Set error
  void _setError(String message) {
    _errorMessage = message;
    _loadingState = NewsLoadingState.error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Get all news
  Future<void> getAllNews() async {
    try {
      _setLoadingState(NewsLoadingState.loading);
      _newsList = await _newsService.getAllNews();
      _loadingState = NewsLoadingState.loaded;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load news: ${e.toString()}');
    }
  }

  // Get latest news with limit
  Future<void> getLatestNews({int limit = 10}) async {
    try {
      _setLoadingState(NewsLoadingState.loading);
      _newsList = await _newsService.getLatestNews(limit: limit);
      _loadingState = NewsLoadingState.loaded;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load latest news: ${e.toString()}');
    }
  }

  // Listen to real-time news updates
  Stream<List<NewsModel>> listenToNews() {
    return _newsService.getAllNewsStream();
  }

  // Listen to news updates and update state
  void startListeningToNews() {
    _newsService.getAllNewsStream().listen(
          (newsList) {
        _newsList = newsList;
        _loadingState = NewsLoadingState.loaded;
        notifyListeners();
      },
      onError: (error) {
        _setError('Real-time update failed: ${error.toString()}');
      },
    );
  }

  // Get news by ID
  Future<void> getNewsById(String newsId) async {
    try {
      _setLoadingState(NewsLoadingState.loading);
      _selectedNews = await _newsService.getNewsById(newsId);
      _loadingState = NewsLoadingState.loaded;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load news details: ${e.toString()}');
    }
  }

  // Set selected news (for viewing details)
  void setSelectedNews(NewsModel? news) {
    _selectedNews = news;
    notifyListeners();
  }

  // Filter by category
  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Clear category filter
  void clearCategoryFilter() {
    _selectedCategory = null;
    notifyListeners();
  }

  // Create new news
  Future<bool> createNews(NewsModel news) async {
    try {
      _setLoadingState(NewsLoadingState.loading);
      final newsId = await _newsService.createNews(news);

      // Refresh the list
      await getAllNews();

      return true;
    } catch (e) {
      _setError('Failed to create news: ${e.toString()}');
      return false;
    }
  }

  // Update existing news
  Future<bool> updateNews(NewsModel news) async {
    try {
      _setLoadingState(NewsLoadingState.loading);
      await _newsService.updateNews(news);

      // Update in local list
      final index = _newsList.indexWhere((n) => n.id == news.id);
      if (index != -1) {
        _newsList[index] = news;
      }

      // Update selected news if it's the same
      if (_selectedNews?.id == news.id) {
        _selectedNews = news;
      }

      _loadingState = NewsLoadingState.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update news: ${e.toString()}');
      return false;
    }
  }

  // Delete news
  Future<bool> deleteNews(String newsId) async {
    try {
      _setLoadingState(NewsLoadingState.loading);
      await _newsService.deleteNews(newsId);

      // Remove from local list
      _newsList.removeWhere((news) => news.id == newsId);

      // Clear selected news if it was deleted
      if (_selectedNews?.id == newsId) {
        _selectedNews = null;
      }

      _loadingState = NewsLoadingState.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete news: ${e.toString()}');
      return false;
    }
  }

  // Search news by title
  Future<void> searchNews(String searchTerm) async {
    try {
      if (searchTerm.isEmpty) {
        await getAllNews();
        return;
      }

      _setLoadingState(NewsLoadingState.loading);
      _newsList = await _newsService.searchNewsByTitle(searchTerm);
      _loadingState = NewsLoadingState.loaded;
      notifyListeners();
    } catch (e) {
      _setError('Search failed: ${e.toString()}');
    }
  }

  // Refresh news
  Future<void> refresh() async {
    await getAllNews();
  }

  @override
  void dispose() {
    super.dispose();
  }
}