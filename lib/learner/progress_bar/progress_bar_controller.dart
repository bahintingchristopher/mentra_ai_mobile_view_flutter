import 'progress_bar_model.dart';
import 'progress_bar_service.dart';

class ProgressBarController {
  final ProgressBarService _service =
      ProgressBarService();

  Future<ProgressBarModel> fetchProgress({
    required String accessToken,
  }) {
    return _service.fetchProgress(
      accessToken: accessToken,
    );
  }
}