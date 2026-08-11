import 'package:flutter/material.dart';
import 'reaction_counter_controller.dart';

class ReactionCounterView extends StatefulWidget {
  final String postId;
  final String userToken;
  final Map<String, int> reactionCounts;

  const ReactionCounterView({
    super.key,
    required this.postId,
    required this.userToken,
    required this.reactionCounts,
  });

  @override
  State<ReactionCounterView> createState() =>
      _ReactionCounterViewState();
}

class _ReactionCounterViewState
    extends State<ReactionCounterView> {
  late final ReactionCounterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ReactionCounterController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // --------------------------------------------------
  // TOTAL REACTION COUNT
  // --------------------------------------------------

  int get totalCount {
    return widget.reactionCounts.values.fold(
      0,
      (sum, count) => sum + count,
    );
  }

  // --------------------------------------------------
  // REACTION EMOJIS
  // --------------------------------------------------

  Widget _reactionIcon(String reaction) {
    switch (reaction) {
      case 'like':
        return const Text(
          '👍',
          style: TextStyle(fontSize: 17),
        );

      case 'love':
        return const Text(
          '❤️',
          style: TextStyle(fontSize: 17),
        );

      case 'haha':
        return const Text(
          '😂',
          style: TextStyle(fontSize: 17),
        );

      case 'wow':
        return const Text(
          '😮',
          style: TextStyle(fontSize: 17),
        );

      case 'sad':
        return const Text(
          '😢',
          style: TextStyle(fontSize: 17),
        );

      case 'angry':
        return const Text(
          '😡',
          style: TextStyle(fontSize: 17),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  // --------------------------------------------------
  // SHOW REACTION USERS
  // --------------------------------------------------

  void _showUserListBottomSheet(
    BuildContext context,
  ) {
    _controller.loadReactionUsers(
      int.parse(widget.postId),
      widget.userToken,
    );

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (bottomSheetContext) {
        return ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            // Loading
            if (_controller.isLoading) {
              return const SizedBox(
                height: 180,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Error
            if (_controller.errorMessage != null) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Text(
                    _controller.errorMessage!,
                  ),
                ),
              );
            }

            // No reactions
            if (_controller.reactionUsers.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(24.0),
                child: Center(
                  child: Text(
                    'No reactions yet.',
                  ),
                ),
              );
            }

            // Reaction user list
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    _controller.reactionUsers.length,
                itemBuilder: (context, index) {
                  final user =
                      _controller.reactionUsers[index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Colors.pink.shade100,
                      child: Text(
                        user.username.isNotEmpty
                            ? user.username[0]
                                .toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      user.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: _reactionIcon(
                      user.reactionType,
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Don't display anything if there are no reactions.
    if (totalCount == 0) {
      return const SizedBox.shrink();
    }

    // Only show reaction types that have
    // at least one reaction.
    //
    // Maximum of 3 reaction icons.
    final visibleReactions =
        widget.reactionCounts.entries
            .where(
              (entry) => entry.value > 0,
            )
            .take(3)
            .toList();

    return InkWell(
      onTap: () =>
          _showUserListBottomSheet(context),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ----------------------------------------
            // REACTION ICONS
            // ----------------------------------------

            ...visibleReactions.map(
              (entry) => _HoverReaction(
                reaction: entry.key,
                count: entry.value,
                icon: _reactionIcon(entry.key),
              ),
            ),

            const SizedBox(width: 5),

            // ----------------------------------------
            // TOTAL REACTION COUNT
            // ----------------------------------------

            Text(
              '$totalCount',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================
// HOVER REACTION WIDGET
// ==================================================

class _HoverReaction extends StatefulWidget {
  final String reaction;
  final int count;
  final Widget icon;

  const _HoverReaction({
    required this.reaction,
    required this.count,
    required this.icon,
  });

  @override
  State<_HoverReaction> createState() =>
      _HoverReactionState();
}

class _HoverReactionState
    extends State<_HoverReaction> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,

      // Mouse enters the emoji
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },

      // Mouse leaves the emoji
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },

      child: SizedBox(
  width: 25, // give room for emoji + number
  height: 32,
  child: Stack(
    clipBehavior: Clip.none,
    children: [
      // Emoji stays centered around the left side
      Positioned(
        left: 0,
        top: 7,
        child: widget.icon,
      ),

      if (_isHovered)
        Positioned(
          left: 12, // number is just to the right of emoji
          top: -6,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 2,
              vertical: 1,
            ),
            child: Text(
              '${widget.count}',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
    ],
  ),
),
    );
  }
}