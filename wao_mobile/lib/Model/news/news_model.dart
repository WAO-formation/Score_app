import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  final String id;
  final String imageUrl;
  final String title;
  final NewsParagraph mainParagraph;
  final List<NewsParagraph>? optionalParagraphs;
  final DateTime publishedDate;
  final String? author;
  final String? category;

  NewsModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.mainParagraph,
    this.optionalParagraphs,
    required this.publishedDate,
    this.author,
    this.category,
  });

  // Convert from Firestore DocumentSnapshot
  factory NewsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NewsModel.fromJson(data, doc.id);
  }

  // Convert from JSON with optional id parameter
  factory NewsModel.fromJson(Map<String, dynamic> json, [String? docId]) {
    return NewsModel(
      id: docId ?? json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
      mainParagraph: NewsParagraph.fromJson(json['mainParagraph']),
      optionalParagraphs: json['optionalParagraphs'] != null
          ? (json['optionalParagraphs'] as List)
          .map((p) => NewsParagraph.fromJson(p as Map<String, dynamic>))
          .toList()
          : null,
      publishedDate: (json['publishedDate'] as Timestamp).toDate(),
      author: json['author'] as String?,
      category: json['category'] as String?,
    );
  }

  // Convert to JSON for Firestore (without id since Firestore handles that)
  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'mainParagraph': mainParagraph.toJson(),
      'optionalParagraphs': optionalParagraphs?.map((p) => p.toJson()).toList(),
      'publishedDate': Timestamp.fromDate(publishedDate),
      'author': author,
      'category': category,
    };
  }

  // Convert to Firestore with id included (for updates)
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'mainParagraph': mainParagraph.toJson(),
      'optionalParagraphs': optionalParagraphs?.map((p) => p.toJson()).toList(),
      'publishedDate': Timestamp.fromDate(publishedDate),
      'author': author,
      'category': category,
    };
  }

  // Get total paragraph count
  int get totalParagraphs {
    return 1 + (optionalParagraphs?.length ?? 0);
  }

  // Get all paragraphs combined
  List<NewsParagraph> get allParagraphs {
    return [
      mainParagraph,
      ...?optionalParagraphs,
    ];
  }

  // Copy with method for easy updates
  NewsModel copyWith({
    String? id,
    String? imageUrl,
    String? title,
    NewsParagraph? mainParagraph,
    List<NewsParagraph>? optionalParagraphs,
    DateTime? publishedDate,
    String? author,
    String? category,
  }) {
    return NewsModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      mainParagraph: mainParagraph ?? this.mainParagraph,
      optionalParagraphs: optionalParagraphs ?? this.optionalParagraphs,
      publishedDate: publishedDate ?? this.publishedDate,
      author: author ?? this.author,
      category: category ?? this.category,
    );
  }
}

class NewsParagraph {
  final String? subtitle;
  final String content;

  NewsParagraph({
    this.subtitle,
    required this.content,
  });

  // Convert from JSON
  factory NewsParagraph.fromJson(Map<String, dynamic> json) {
    return NewsParagraph(
      subtitle: json['subtitle'] as String?,
      content: json['content'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'subtitle': subtitle,
      'content': content,
    };
  }

  // Check if has subtitle
  bool get hasSubtitle => subtitle != null && subtitle!.isNotEmpty;

  // Copy with method
  NewsParagraph copyWith({
    String? subtitle,
    String? content,
  }) {
    return NewsParagraph(
      subtitle: subtitle ?? this.subtitle,
      content: content ?? this.content,
    );
  }
}