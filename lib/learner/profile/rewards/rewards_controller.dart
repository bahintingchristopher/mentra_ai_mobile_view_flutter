import 'package:flutter/material.dart';
import 'rewards_model.dart';
import 'rewards_service.dart';

class RewardsController extends ChangeNotifier {
  final RewardsService _service = RewardsService();

  List<RewardBadgeModel> badges = [];
  bool isLoading = false;

  Future<void> fetchBadges() async {
    isLoading = true;
    notifyListeners();

    badges = await _service.fetchUserBadges();

    isLoading = false;
    notifyListeners();
  }
}