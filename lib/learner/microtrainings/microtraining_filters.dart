// import 'package:flutter/material.dart';

// class MicrotrainingFilters extends StatelessWidget {
//   final String selectedStatus;
//   final TextEditingController searchController;
//   final ValueChanged<String> onStatusChanged;
//   final ValueChanged<String> onSearchChanged;

//   const MicrotrainingFilters({
//     super.key,
//     required this.selectedStatus,
//     required this.searchController,
//     required this.onStatusChanged,
//     required this.onSearchChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Status Filter Tabs: [ Pending | Completed ]
//         Container(
//           padding: const EdgeInsets.all(3),
//           decoration: BoxDecoration(
//             color: isDark ? const Color(0xFF131822) : const Color(0xFFF1F5F9),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildStatusPill(context, 'Pending', 'pending'),
//               _buildStatusPill(context, 'Completed', 'completed'),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),

//         // Search Bar
//         TextField(
//           controller: searchController,
//           onChanged: onSearchChanged,
//           decoration: InputDecoration(
//             hintText: 'Search microtrainings...',
//             hintStyle: TextStyle(
//               color: const Color(0xFF94A3B8),
//               fontSize: 14, 
//             ),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             fillColor: isDark ? const Color(0xFF1B2234) : Colors.white,
//             filled: true,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
//               ),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatusPill(BuildContext context, String label, String value) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final isSelected = selectedStatus == value;
//     return GestureDetector(
//       onTap: () => onStatusChanged(value),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF0EA5E9) : Colors.transparent,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: isSelected
//                 ? Colors.white
//                 : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class MicrotrainingFilters extends StatelessWidget {
  final String selectedStatus;
  final TextEditingController searchController;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onSearchChanged;

  const MicrotrainingFilters({
    super.key,
    required this.selectedStatus,
    required this.searchController,
    required this.onStatusChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Status Filter Tabs: [ Pending | Completed ]
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF131822) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusPill(context, 'Pending', 'pending'),
              _buildStatusPill(context, 'Completed', 'completed'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 2. Search Bar
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: searchController,
          builder: (context, value, child) {
            return TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText: 'Search microtrainings...',
                hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
                // Clear button appears when text is entered
                suffixIcon: value.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          color: Color(0xFF94A3B8),
                          size: 18,
                        ),
                        onPressed: () {
                          searchController.clear();
                          onSearchChanged('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                fillColor: isDark ? const Color(0xFF1B2234) : Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF0EA5E9),
                    width: 1.5,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Helper Widget: Filter Pill (Pending / Completed)
  Widget _buildStatusPill(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = selectedStatus == value;

    return GestureDetector(
      onTap: () => onStatusChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0EA5E9) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B)),
          ),
        ),
      ),
    );
  }
}
