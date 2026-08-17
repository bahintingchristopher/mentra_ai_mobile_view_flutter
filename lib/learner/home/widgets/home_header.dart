import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final bool isFeedSelected;
  final VoidCallback onSelectMicrotrainings;
  final VoidCallback onSelectFeed;

  const HomeHeader({
    super.key,
    required this.isFeedSelected,
    required this.onSelectMicrotrainings,
    required this.onSelectFeed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Subtitle Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFeedSelected ? 'Your Feed' : 'Your\nMicrotrainings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isFeedSelected
                    ? 'Updates and content from\nyour organization.'
                    : 'Browse assigned microtrainings\nby status and category.',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // Toggle Switch Pill
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF131822) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPillButton(
                  context: context,
                  label: 'Microtrainings',
                  isSelected: !isFeedSelected,
                  onTap: onSelectMicrotrainings,
                ),
                _buildPillButton(
                  context: context,
                  label: 'Feed',
                  isSelected: isFeedSelected,
                  onTap: onSelectFeed,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPillButton({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF2D3748) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected && !isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 4,
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? (isDark ? Colors.white : const Color(0xFF0F172A))
                : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
          ),
        ),
      ),
    );
  }
}