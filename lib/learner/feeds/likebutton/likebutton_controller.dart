import 'likebutton_service.dart';

class LikeController {
  final LikeService service = LikeService();

  Future<void> likePost({
    required int postId,
    required String reaction,
    required String accessToken,
    String? sessionKey,
  }) async {
    await LikeService.sendReaction(
      postId: postId,
      reaction: reaction,
      accessToken: accessToken,
      sessionKey: sessionKey,
    );
  }
}