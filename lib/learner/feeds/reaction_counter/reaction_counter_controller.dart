import 'package:flutter/material.dart';
import 'reaction_counter_model.dart';
import 'reaction_counter_service.dart';

class ReactionCounterController extends ChangeNotifier {
  final ReactionCounterService _service;

  ReactionCounterController({ReactionCounterService? service})
      : _service = service ?? ReactionCounterService();

  List<ReactionUserModel> _reactionUsers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ReactionUserModel> get reactionUsers => _reactionUsers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadReactionUsers(int postId, String token) async {
    if (_reactionUsers.isNotEmpty || _isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _reactionUsers = await _service.fetchPostReactions(postId, token);
    } catch (e) {
      _errorMessage = 'Could not load users.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}