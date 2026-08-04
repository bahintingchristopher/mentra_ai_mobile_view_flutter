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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Subtitle Text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isFeedSelected ? 'Your\nFeed' : 'Your\nMicrotrainings',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
                height: 1.1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isFeedSelected
                  ? 'Updates and content from\nyour organization.'
                  : 'Browse assigned microtrainings\nby status and category.',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),

        // Toggle Switch Pill
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPillButton(
                label: 'Microtrainings',
                isSelected: !isFeedSelected,
                onTap: onSelectMicrotrainings,
              ),
              _buildPillButton(
                label: 'Feed',
                isSelected: isFeedSelected,
                onTap: onSelectFeed,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPillButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
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
            color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}