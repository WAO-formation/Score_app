import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Model/news/news_model.dart';

class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'news';

  // Get collection reference
  CollectionReference get _newsCollection =>
      _firestore.collection(_collectionName);

  // Create new news
  Future<String> createNews(NewsModel news) async {
    try {
      final docRef = await _newsCollection.add(news.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create news: $e');
    }
  }

  // Update existing news
  Future<void> updateNews(NewsModel news) async {
    try {
      await _newsCollection.doc(news.id).update(news.toJson());
    } catch (e) {
      throw Exception('Failed to update news: $e');
    }
  }

  // Delete news
  Future<void> deleteNews(String newsId) async {
    try {
      await _newsCollection.doc(newsId).delete();
    } catch (e) {
      throw Exception('Failed to delete news: $e');
    }
  }

  // Get single news by ID
  Future<NewsModel?> getNewsById(String newsId) async {
    try {
      final doc = await _newsCollection.doc(newsId).get();
      if (doc.exists) {
        return NewsModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get news: $e');
    }
  }

  // Get all news (stream for real-time updates)
  Stream<List<NewsModel>> getAllNewsStream() {
    return _newsCollection
        .orderBy('publishedDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => NewsModel.fromFirestore(doc))
        .toList());
  }

  // Get all news (one-time fetch)
  Future<List<NewsModel>> getAllNews() async {
    try {
      final snapshot = await _newsCollection
          .orderBy('publishedDate', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => NewsModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all news: $e');
    }
  }

  // Get news by category (stream)
  Stream<List<NewsModel>> getNewsByCategory(String category) {
    return _newsCollection
        .where('category', isEqualTo: category)
        .orderBy('publishedDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => NewsModel.fromFirestore(doc))
        .toList());
  }

  // Get latest news (limited)
  Future<List<NewsModel>> getLatestNews({int limit = 10}) async {
    try {
      final snapshot = await _newsCollection
          .orderBy('publishedDate', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs
          .map((doc) => NewsModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get latest news: $e');
    }
  }

  // Search news by title
  Future<List<NewsModel>> searchNewsByTitle(String searchTerm) async {
    try {
      final snapshot = await _newsCollection
          .where('title', isGreaterThanOrEqualTo: searchTerm)
          .where('title', isLessThanOrEqualTo: searchTerm + '\uf8ff')
          .get();
      return snapshot.docs
          .map((doc) => NewsModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to search news: $e');
    }
  }

}