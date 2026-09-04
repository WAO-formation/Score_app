import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

class DateFilter extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DateFilter({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 1));
          final isSelected = DateUtils.isSameDay(date, selectedDate);
          final isToday = DateUtils.isSameDay(date, DateTime.now());

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.waoRed
                    : isDark
                        ? Colors.white.withOpacity(0.06)
                        : AppColors.waoNavy.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.waoRed
                      : isDark
                          ? Colors.white.withOpacity(0.08)
                          : AppColors.waoNavy.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isToday ? 'TODAY' : DateFormat('EEE').format(date).toUpperCase(),
                    style: GoogleFonts.oswald(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white70
                          : isDark
                              ? Colors.white38
                              : AppColors.waoNavy.withOpacity(0.45),
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    DateFormat('d MMM').format(date),
                    style: GoogleFonts.oswald(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : isDark
                              ? Colors.white
                              : AppColors.waoNavy,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryFilter extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const CategoryFilter({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return GestureDetector(
            onTap: () => onFilterSelected(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.waoRed
                    : isDark
                        ? Colors.white.withOpacity(0.06)
                        : AppColors.waoNavy.withOpacity(0.06),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.waoRed
                      : isDark
                          ? Colors.white.withOpacity(0.1)
                          : AppColors.waoNavy.withOpacity(0.12),
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                filter,
                style: GoogleFonts.oswald(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : isDark
                          ? Colors.white60
                          : AppColors.waoNavy.withOpacity(0.7),
                  letterSpacing: 0.3,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
