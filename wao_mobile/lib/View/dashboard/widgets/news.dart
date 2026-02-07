import 'package:flutter/material.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';
import '../../../Model/news/news_model.dart';
import '../../../core/services/news/news_service.dart';
import '../../../core/theme/app_typography.dart';


class NewsListItem extends StatelessWidget {
  final NewsModel news;
  final bool isDarkMode;
  final VoidCallback? onTap;

  const NewsListItem({
    Key? key,
    required this.news,
    required this.isDarkMode,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                news.imageUrl,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.withOpacity(0.3),
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.withOpacity(0.3),
                    child: const Icon(Icons.image, color: Colors.grey),
                  );
                },
              ),
            ),

            const SizedBox(height: 10,),

            // Text section
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                news.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: AppTypography.bodyLg,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: GestureDetector(
                onTap: () {
                  // TODO: Navigate to detail page later
                  print('Tapped on: ${news.title}');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Read More',
                      style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: AppTypography.bodyLg,
                      color: AppColors.waoYellow,
                    ),),
                    SizedBox(width: 5.0,),

                    Icon(Icons.arrow_forward, color: AppColors.waoYellow,)
                  ]
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Widget to display news section with StreamBuilder
class NewsSection extends StatelessWidget {
  final bool isDarkMode;
  final NewsService _newsService = NewsService();

  NewsSection({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NewsModel>>(
      stream: _newsService.getAllNewsStream(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'Error loading news',
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
          );
        }

        // Empty state
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 48,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No news available yet',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Success state
        final newsList = snapshot.data!;
        return Column(
          children: List.generate(
            newsList.length,
                (index) {
              final news = newsList[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < newsList.length - 1 ? 12.0 : 0,
                ),
                child: NewsListItem(
                  news: news,
                  isDarkMode: isDarkMode,
                  onTap: () {
                    // TODO: Navigate to detail page later
                    print('Tapped on: ${news.title}');
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}