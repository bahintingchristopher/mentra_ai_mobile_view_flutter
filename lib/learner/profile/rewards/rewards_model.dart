class RewardBadgeModel {
  final String id;
  final String title;
  final String imageUrl;

  RewardBadgeModel({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory RewardBadgeModel.fromJson(Map<String, dynamic> json) {
    return RewardBadgeModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
    };
  }
}