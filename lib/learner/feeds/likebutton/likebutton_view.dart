import 'package:flutter/material.dart';
import 'likebutton_controller.dart';

class LikeView extends StatefulWidget {
  final String postId;
  final String accessToken;
  final String? sessionKey;

  const LikeView({
    super.key,
    required this.postId,
    required this.accessToken,
    this.sessionKey,
  });

  @override
  State<LikeView> createState() => _LikeViewState();
}

class _LikeViewState extends State<LikeView> {
  final LikeController controller = LikeController();

  String? selectedReaction;

  final Map<String, String> reactions = {
    'like': '👍',
    'love': '❤️',
    'haha': '😂',
    'wow': '😮',
    'sad': '😢',
    'angry': '😡',
  };

  Future<void> selectReaction(String reaction) async {
    print('DEBUG: Attempting to like Post ID -> "${widget.postId}"');
    try {
      await controller.likePost(
          postId: int.parse(widget.postId),
          reaction: reaction,
          accessToken: widget.accessToken,
          sessionKey: widget.sessionKey,
        );

      setState(() {
        selectedReaction = reaction;
      });
    } catch (e) {
      print('Reaction failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: selectReaction,

itemBuilder: (context) {
  return [
    PopupMenuItem<String>(
      value: 'reactions',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: reactions.entries.map((entry) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
              selectReaction(entry.key);
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                entry.value,
                style: const TextStyle(fontSize: 26),
              ),
            ),
          );
        }).toList(),
      ),
    ),
  ];
},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedReaction == null
                ? '👍'
                : reactions[selectedReaction]!,
            style: const TextStyle(fontSize: 20),
          ),

          const SizedBox(width: 5),

          Text(
            selectedReaction == null
                ? 'Like'
                : selectedReaction!,
          ),
        ],
      ),
    );
  }
}