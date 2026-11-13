import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wao_mobile/View/games_details/widgets/game_detail_shared.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';
import 'package:wao_mobile/core/utils/drive_image.dart';
import '../../../Model/news/news_model.dart';

class NewsDetailsPage extends StatelessWidget {
  const NewsDetailsPage({super.key, required this.news});
  final NewsModel news;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      // top:false leaves the hero image full-bleed against the status bar
      // (it hand-rolls its own top inset for the back button); bottom
      // protects the article text from the home indicator.
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NewsHero(news: news),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: GoogleFonts.oswald(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      color: isDark ? Colors.white : AppColors.waoNavy,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _MetaRow(news: news, isDark: isDark),
                  const SizedBox(height: 20),
                  Container(
                    width: 40,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.waoRed,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (final paragraph in news.allParagraphs)
                    _ParagraphBlock(paragraph: paragraph, isDark: isDark),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

// ── Hero image with back button + category badge overlaid ────────────────────
class _NewsHero extends StatelessWidget {
  const _NewsHero({required this.news});
  final NewsModel news;

  static Widget _placeholder() => Container(
        color: AppColors.waoNavy.withOpacity(0.08),
        child: Icon(
          Icons.image_outlined,
          color: AppColors.waoNavy.withOpacity(0.3),
          size: 40,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final resolvedUrl = DriveImage.resolve(news.imageUrl);

    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (DriveImage.isSafeToLoad(resolvedUrl))
            Image.network(
              resolvedUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(color: AppColors.waoNavy.withOpacity(0.08));
              },
              errorBuilder: (context, error, stackTrace) => _placeholder(),
            )
          else
            _placeholder(),
          // Scrim so the back button and badge stay legible over any photo.
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.45), Colors.transparent],
                stops: const [0, 0.6],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, top + 12, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const DetailBackButton(),
                if (news.category != null && news.category!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.waoYellow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      news.category!.toUpperCase(),
                      style: GoogleFonts.oswald(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: AppColors.waoNavy,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Author • published-date byline ────────────────────────────────────────────
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.news, required this.isDark});
  final NewsModel news;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final hasAuthor = news.author != null && news.author!.isNotEmpty;
    final mutedColor = isDark ? Colors.white54 : Colors.grey.shade600;

    return Row(
      children: [
        if (hasAuthor) ...[
          Icon(Icons.person_outline, size: 14, color: mutedColor),
          const SizedBox(width: 4),
          Text(
            news.author!,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('•', style: TextStyle(color: isDark ? Colors.white38 : Colors.grey.shade400)),
          ),
        ],
        Icon(Icons.schedule, size: 14, color: mutedColor),
        const SizedBox(width: 4),
        Text(
          DateFormat('MMM d, yyyy').format(news.publishedDate),
          style: TextStyle(fontSize: 13, color: mutedColor),
        ),
      ],
    );
  }
}

// ── One body paragraph, with an optional sub-heading ──────────────────────────
class _ParagraphBlock extends StatelessWidget {
  const _ParagraphBlock({required this.paragraph, required this.isDark});
  final NewsParagraph paragraph;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (paragraph.hasSubtitle) ...[
            Text(
              paragraph.subtitle!,
              style: GoogleFonts.oswald(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.waoNavy,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            paragraph.content,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: isDark ? Colors.white70 : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
