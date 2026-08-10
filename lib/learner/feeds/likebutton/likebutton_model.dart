class LikeModel {
  final int postId;
  final Map<String, int> reactionCounts;
  String? userReaction;

  LikeModel({
    required this.postId,
    required this.reactionCounts,
    this.userReaction,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      postId: json['id'],
      reactionCounts: Map<String, int>.from(
        json['reaction_counts'] ?? {},
      ),
      userReaction: json['user_reaction'],
    );
  }
}