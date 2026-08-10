import 'comment_model.dart';
import 'comment_service.dart';

class CommentController {
  Future<List<CommentModel>> getComments({
    required int postId,
    required String accessToken,
    String? sessionKey,
  }) {
    return CommentService.getComments(
      postId: postId,
      accessToken: accessToken,
      sessionKey: sessionKey,
    );
  }

  Future<void> addComment({
    required int postId,
    required String content,
    required String accessToken,
    String? sessionKey,
  }) {
    return CommentService.addComment(
      postId: postId,
      content: content,
      accessToken: accessToken,
      sessionKey: sessionKey,
    );
  }
}