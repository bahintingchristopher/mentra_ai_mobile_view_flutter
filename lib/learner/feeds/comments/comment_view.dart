import 'package:flutter/material.dart';
import 'comment_controller.dart';
import 'comment_model.dart';

class CommentView extends StatefulWidget {
  final String postId;
  final String accessToken;
  final String? sessionKey;
  final VoidCallback? onCommentAdded;

  const CommentView({
    super.key,
    required this.postId,
    required this.accessToken,
    this.sessionKey,
    this.onCommentAdded,
  });

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  final CommentController controller = CommentController();
  final TextEditingController textController = TextEditingController();

  List<CommentModel> comments = [];
  bool loading = true;
  bool submitting = false;

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> loadComments() async {
    try {
      final result = await controller.getComments(
        postId: int.parse(widget.postId),
        accessToken: widget.accessToken,
        sessionKey: widget.sessionKey,
      );

      if (!mounted) return;

      setState(() {
        comments = result;
        loading = false;
      });
    } catch (e) {
      print('Comment error: $e');

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> submitComment() async {
    final text = textController.text.trim();

    if (text.isEmpty || submitting) return;

    setState(() {
      submitting = true;
    });

    try {
      await controller.addComment(
        postId: int.parse(widget.postId),
        content: text,
        accessToken: widget.accessToken,
        sessionKey: widget.sessionKey,
      );

      widget.onCommentAdded?.call();

      textController.clear();

      await loadComments();
    } catch (e) {
      print('Add comment error: $e');
    } finally {
      if (mounted) {
        setState(() {
          submitting = false;
        });
      }
    }
  }

  String getInitials(String name) {
    final parts = name
        .trim()
        .split(' ')
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '?';

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // =========================
            // HEADER
            // =========================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 10),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // =========================
            // COMMENTS
            // =========================
            Expanded(
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : comments.isEmpty
                      ? const Center(
                          child: Text(
                            'No comments yet.',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];

                            return _buildComment(comment);
                          },
                        ),
            ),

            // =========================
            // COMMENT INPUT
            // =========================
            Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: textController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText:
                          'Write a comment... (use @ to mention someone)',
                      hintStyle: const TextStyle(
                        color: Color(0xFF94A3B8),
                      ),
                      contentPadding: const EdgeInsets.all(14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFCBD5E1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFCBD5E1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF38BDF8),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: submitting ? null : submitComment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF38BDF8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: submitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Comment',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // SINGLE COMMENT
  // =========================
  Widget _buildComment(CommentModel comment) {
    final name = comment.authorName;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 21,
            backgroundColor: const Color(0xFFE2E8F0),
            child: Text(
              getInitials(name),
              style: const TextStyle(
                color: Color(0xFF475569),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Comment content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),

                      // We can add formatted date here
                      // when your CommentModel exposes createdAt.
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    comment.content,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Color(0xFF334155),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          // Reply feature can be connected later.
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(45, 25),
                          tapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Reply',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}