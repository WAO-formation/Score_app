import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';
import 'package:wao_mobile/core/utils/drive_image.dart';
import '../../../Model/news/news_model.dart';
import '../../../ViewModel/news_viewmodel/news_viewmodel.dart';
import 'news_details.dart';

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
          borderRadius: BorderRadius.circular(24),
          color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NewsImage(news: news),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: GoogleFonts.oswald(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                      color: isDarkMode ? Colors.white : AppColors.waoNavy,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (news.author != null && news.author!.isNotEmpty) ...[
                        Text(
                          news.author!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? Colors.white60
                                : Colors.grey.shade600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            '•',
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white38
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ],
                      Text(
                        _formatRelativeDate(news.publishedDate),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? Colors.white38
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    news.mainParagraph.content,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.4,
                      color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Read More',
                        style: GoogleFonts.oswald(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          letterSpacing: 0.3,
                          color: AppColors.waoRed,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: AppColors.waoRed,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatRelativeDate(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes.clamp(1, 59)}m ago';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }
    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}

// ── News image with a category chip overlaid on top ──────────────────────────
class _NewsImage extends StatelessWidget {
  const _NewsImage({required this.news});
  final NewsModel news;

  static Widget _placeholder() => Container(
        color: AppColors.waoNavy.withOpacity(0.06),
        child: Icon(
          Icons.image_outlined,
          color: AppColors.waoNavy.withOpacity(0.3),
          size: 32,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = DriveImage.resolve(news.imageUrl);

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (DriveImage.isSafeToLoad(resolvedUrl))
            Image.network(
              resolvedUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.waoNavy.withOpacity(0.06),
                  child: const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(AppColors.waoYellow),
                      ),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => _placeholder(),
            )
          else
            _placeholder(),
          if (news.category != null && news.category!.isNotEmpty)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.waoYellow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  news.category!.toUpperCase(),
                  style: GoogleFonts.oswald(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: AppColors.waoNavy,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Widget to display news section with StreamBuilder
class NewsSection extends StatelessWidget {
  final bool isDarkMode;

  const NewsSection({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NewsModel>>(
      // Routed through NewsViewModel (already in the provider tree) rather
      // than instantiating NewsService directly — a fresh service/stream
      // was previously created on every rebuild of this widget.
      stream: context.read<NewsViewModel>().listenToNews(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _StatusCard(
            isDarkMode: isDarkMode,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.waoYellow),
            ),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return _StatusCard(
            isDarkMode: isDarkMode,
            child: Text(
              'Error loading news',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          );
        }

        // Empty state
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _StatusCard(
            isDarkMode: isDarkMode,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 40,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.3)
                      : Colors.grey.shade400,
                ),
                const SizedBox(height: 10),
                Text(
                  'No news available yet',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
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
                  bottom: index < newsList.length - 1 ? 16.0 : 0,
                ),
                child: NewsListItem(
                  news: news,
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailsPage(news: news),
                      ),
                    );
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

// ── Shared chrome for loading / error / empty states ─────────────────────────
class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.isDarkMode, required this.child});
  final bool isDarkMode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Center(child: child),
    );
  }
}
