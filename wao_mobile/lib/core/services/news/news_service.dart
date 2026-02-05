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

  // Add sample news articles
  Future<void> addSampleNews() async {
    try {
      // News Article 1: Technology
      final news1 = NewsModel(
        id: '', // Will be set by Firestore
        imageUrl: 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800',
        title: 'AI Revolution: How Machine Learning is Transforming Industries',
        mainParagraph: NewsParagraph(
          subtitle: 'Breaking New Ground',
          content: 'Artificial Intelligence and Machine Learning technologies are reshaping the landscape of modern business. From healthcare to finance, companies are leveraging AI to improve efficiency, reduce costs, and create innovative solutions that were previously impossible.',
        ),
        optionalParagraphs: [
          NewsParagraph(
            subtitle: 'Healthcare Innovation',
            content: 'In the medical field, AI-powered diagnostic tools are helping doctors detect diseases earlier and with greater accuracy. Machine learning algorithms analyze medical imaging, predict patient outcomes, and assist in drug discovery.',
          ),
          NewsParagraph(
            subtitle: 'Financial Sector Transformation',
            content: 'Banks and financial institutions are using AI for fraud detection, risk assessment, and personalized customer service. Automated trading systems and credit scoring models have become increasingly sophisticated.',
          ),
          NewsParagraph(
            content: 'As these technologies continue to evolve, experts predict that AI will become even more integrated into our daily lives, creating new opportunities and challenges for society to navigate.',
          ),
        ],
        publishedDate: DateTime.now().subtract(Duration(days: 1)),
        author: 'Sarah Johnson',
        category: 'Technology',
      );

      // News Article 2: Environment
      final news2 = NewsModel(
        id: '',
        imageUrl: 'https://images.unsplash.com/photo-1569163139394-de4798aa62b0?w=800',
        title: 'Renewable Energy Milestone: Solar Power Reaches Record Efficiency',
        mainParagraph: NewsParagraph(
          subtitle: 'Clean Energy Breakthrough',
          content: 'Scientists have achieved a new world record in solar panel efficiency, reaching 47% conversion rate in laboratory conditions. This breakthrough could accelerate the global transition to renewable energy sources.',
        ),
        optionalParagraphs: [
          NewsParagraph(
            subtitle: 'The Technology Behind It',
            content: 'The new solar cells use a multi-junction design that captures different wavelengths of light more effectively. This innovation combines several semiconductor materials in layers, each optimized for specific parts of the solar spectrum.',
          ),
          NewsParagraph(
            content: 'Industry experts believe this technology could be commercially available within the next five years, potentially reducing the cost of solar energy and making it more competitive with traditional fossil fuels.',
          ),
        ],
        publishedDate: DateTime.now().subtract(Duration(days: 3)),
        author: 'Michael Chen',
        category: 'Environment',
      );

      // News Article 3: Sports
      final news3 = NewsModel(
        id: '',
        imageUrl: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=800',
        title: 'Olympic Games 2024: Athletes Break Multiple World Records',
        mainParagraph: NewsParagraph(
          subtitle: 'Historic Performances',
          content: 'The 2024 Olympic Games witnessed an unprecedented number of world records being shattered across various disciplines. Athletes from around the globe pushed the boundaries of human performance in swimming, track and field, and gymnastics.',
        ),
        optionalParagraphs: [
          NewsParagraph(
            subtitle: 'Swimming Sensations',
            content: 'The swimming events saw five world records broken in the first week alone. The 100m freestyle final was particularly spectacular, with the gold medalist finishing 0.3 seconds faster than the previous record.',
          ),
          NewsParagraph(
            subtitle: 'Track and Field Excellence',
            content: 'On the track, sprinters and distance runners alike delivered outstanding performances. The women\'s 400m hurdles final featured three athletes finishing under the previous world record time.',
          ),
        ],
        publishedDate: DateTime.now().subtract(Duration(days: 5)),
        author: 'Emma Rodriguez',
        category: 'Sports',
      );

      // News Article 4: Business
      final news4 = NewsModel(
        id: '',
        imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800',
        title: 'Global Markets React to New Economic Policy Changes',
        mainParagraph: NewsParagraph(
          subtitle: 'Economic Shift',
          content: 'Stock markets around the world experienced significant volatility following announcements of major economic policy changes by leading central banks. Investors are reassessing their portfolios as interest rate adjustments and quantitative measures take effect.',
        ),
        optionalParagraphs: [
          NewsParagraph(
            subtitle: 'Market Response',
            content: 'The S&P 500 and other major indices showed mixed reactions, with technology stocks leading gains while traditional sectors faced pressure. Currency markets also saw substantial movements, particularly in emerging market currencies.',
          ),
          NewsParagraph(
            subtitle: 'Expert Analysis',
            content: 'Financial analysts suggest that while short-term volatility is expected, the long-term outlook remains cautiously optimistic. Many recommend diversification and a focus on fundamentally strong companies.',
          ),
          NewsParagraph(
            content: 'Economists are closely monitoring inflation rates, employment figures, and consumer spending patterns to gauge the effectiveness of these new policies in the coming months.',
          ),
        ],
        publishedDate: DateTime.now().subtract(Duration(hours: 12)),
        author: 'David Park',
        category: 'Business',
      );

      // Add all news articles to Firestore
      await createNews(news1);
      await createNews(news2);
      await createNews(news3);
      await createNews(news4);

      print('Successfully added 4 sample news articles!');
    } catch (e) {
      throw Exception('Failed to add sample news: $e');
    }
  }
}