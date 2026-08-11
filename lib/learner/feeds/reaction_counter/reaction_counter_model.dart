class ReactionCounterModel {
  final Map<String, int> reactionCounts;
  final List<ReactionUserModel> users;

  ReactionCounterModel({
    required this.reactionCounts,
    required this.users,
  });

  int get totalReactions {
    return reactionCounts.values.fold(
      0,
      (sum, count) => sum + count,
    );
  }

  factory ReactionCounterModel.fromJson(
    Map<String, dynamic> json,
  ) {
    // -------------------------
    // REACTION COUNTS
    // -------------------------
    final Map<String, int> counts = {};

    final rawCounts = json['reaction_counts'];

    if (rawCounts is Map) {
      rawCounts.forEach((key, value) {
        counts[key.toString()] =
            int.tryParse(value.toString()) ?? 0;
      });
    }

    // -------------------------
    // USERS WHO REACTED
    // -------------------------
    final List<ReactionUserModel> users = [];

    final rawUsers = json['reactions'];

    if (rawUsers is List) {
      for (final item in rawUsers) {
        if (item is Map<String, dynamic>) {
          users.add(
            ReactionUserModel.fromJson(item),
          );
        }
      }
    }

    return ReactionCounterModel(
      reactionCounts: counts,
      users: users,
    );
  }
}


class ReactionUserModel {
  final int id;
  final String username;
  final String reactionType;

  ReactionUserModel({
    required this.id,
    required this.username,
    required this.reactionType,
  });

  factory ReactionUserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReactionUserModel(
      id: int.tryParse(
            json['id']?.toString() ?? '0',
          ) ??
          0,

      username:
          json['user']?['username'] ??
          json['username'] ??
          'Anonymous',

      reactionType:
          json['reaction_type']?.toString() ??
          'like',
    );
  }
}