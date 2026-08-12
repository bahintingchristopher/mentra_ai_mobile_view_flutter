import 'package:flutter/material.dart';
import 'package:mentra_mobile_view/learner/microtrainings/microtraining_model.dart';

class MicrotrainingCard extends StatelessWidget {
  final MicrotrainingModel item;
  final VoidCallback? onTap;

const MicrotrainingCard({
  super.key,
  required this.item,
  this.onTap,
});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Category Badges
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: item.categories.map((cat) {
                  final isMicro = cat.toLowerCase().contains('microtraining');
                  return _buildBadge(
                    cat,
                    isMicro ? const Color(0xFFDCFCE7) : const Color(0xFFE0F2FE),
                    isMicro ? const Color(0xFF166534) : const Color(0xFF0369A1),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),

              // 2. Pending/Completion Subtitle
              Text(
                item.pendingStatusText,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),

              // 3. Title & Status Chip
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(item.status),
                ],
              ),
              const SizedBox(height: 6),

              // 4. Description (if available)
              if (item.description != null && item.description!.isNotEmpty) ...[
                  Text(
                    item.description!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF475569),
                    ),
                  ),
                ],
              // 5. Questions & Date Metadata
              Text(
                '${item.questionsCount} questions   •   Assigned ${item.assignedDate}',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),

              // 6. Notice Box Banner
              if (item.noticeMessage.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    item.noticeMessage,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget: Category Badge Pill
  Widget _buildBadge(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  // Helper Widget: Status Chip (Pending / Completed)
  Widget _buildStatusChip(String status) {
    final isPending = status.toLowerCase() == 'pending';
    final bgColor = isPending ? const Color(0xFFE0F2FE) : const Color(0xFFDCFCE7);
    final textColor = isPending ? const Color(0xFF0284C7) : const Color(0xFF15803D);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}