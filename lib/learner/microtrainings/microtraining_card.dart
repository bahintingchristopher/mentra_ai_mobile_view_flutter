import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:mentra_mobile_view/learner/microtrainings/microtraining_model.dart';

class MicrotrainingCard extends StatelessWidget {
  final MicrotrainingModel item;
  final VoidCallback? onTap;
  final VoidCallback? onVideoCompleted;

  const MicrotrainingCard({
    super.key,
    required this.item,
    this.onTap,
    this.onVideoCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final currentStatus = (item.status).toLowerCase();
    final isCompleted = currentStatus == 'completed' || currentStatus == 'done';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      color: isDark ? const Color(0xFF434B5E) : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.categories.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: item.categories.map((cat) {
                    final isMicro = cat.toLowerCase().contains('microtraining');
                    return _buildBadge(
                      cat,
                      isMicro
                          ? (isDark
                              ? const Color(0xFF166534)
                              : const Color(0xFFDCFCE7))
                          : (isDark
                              ? const Color(0xFF0369A1)
                              : const Color(0xFFE0F2FE)),
                      isMicro
                          ? (isDark
                              ? const Color(0xFF86EFAC)
                              : const Color(0xFF166534))
                          : (isDark
                              ? const Color(0xFF7DD3FC)
                              : const Color(0xFF0369A1)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
              ],
            
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(item.status, isDark),
                ],
              ),
              const SizedBox(height: 8),

              if (item.description != null && item.description!.isNotEmpty) ...[
                Text(
                  item.description!,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              if (item.videoUrl.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: MicrotrainingVideoPlayer(
                    videoUrl: item.videoUrl,
                    onVideoCompleted: onVideoCompleted,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              Text(
                '${item.questionsCount} questions   •   Assigned ${item.assignedDate}',
                style: TextStyle(
                  color:
                      isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),

              if (item.noticeMessage.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF475569)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    item.noticeMessage,
                    style: TextStyle(
                      color:
                          isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
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

  Widget _buildStatusChip(String status, bool isDark) {
    final cleanStatus = status.toLowerCase();
    final isDone = cleanStatus == 'completed' || cleanStatus == 'done';

    final bgColor = isDone
        ? (isDark ? const Color(0xFF14532D) : const Color(0xFFDCFCE7))
        : (isDark ? const Color(0xFF0C4A6E) : const Color(0xFFE0F2FE));

    final textColor = isDone
        ? (isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D))
        : (isDark ? const Color(0xFF7DD3FC) : const Color(0xFF0284C7));

    final displayText = isDone ? 'DONE' : 'PENDING';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

class MicrotrainingVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final VoidCallback? onVideoCompleted;

  const MicrotrainingVideoPlayer({
    super.key,
    required this.videoUrl,
    this.onVideoCompleted,
  });

  @override
  State<MicrotrainingVideoPlayer> createState() =>
      _MicrotrainingVideoPlayerState();
}

class _MicrotrainingVideoPlayerState extends State<MicrotrainingVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _disposed = false;
  bool _controllerCreated = false;
  bool _videoCompletionHandled = false;
  bool _wasPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      _controllerCreated = true;
      await _controller.initialize();

      _controller.addListener(_onVideoProgress);

      if (!_disposed && mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (!_disposed && mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  void _onVideoProgress() {
    if (_disposed || !mounted) return;

    if (_controller.value.isPlaying) {
      _wasPlaying = true;
    }

    if (_controller.value.isInitialized &&
        _controller.value.position >= _controller.value.duration &&
        !_controller.value.isPlaying &&
        _wasPlaying &&
        !_videoCompletionHandled) {
      _videoCompletionHandled = true;
      _wasPlaying = false;
      widget.onVideoCompleted?.call();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    if (_controllerCreated) {
      _controller.removeListener(_onVideoProgress);
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        height: 180,
        color: Colors.black12,
        child: const Center(
          child: Text(
            'Unable to load video',
            style: TextStyle(color: Colors.red, fontSize: 13),
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: const Color(0xFF0F172A),
          child: const Center(
            child: CircularProgressIndicator(color: Color(0xFF0EA5E9)),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          VideoPlayer(_controller),
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  _controller.value.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          ),
          VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Color(0xFF0EA5E9),
              bufferedColor: Colors.white30,
              backgroundColor: Colors.black26,
            ),
          ),
        ],
      ),
    );
  }
}

