import 'package:flutter/material.dart';
import 'auth_service.dart';
import '../../admin/authentication/user_model.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isLoading = false;

  Future<String?> handleLogin(String username, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      UserModel user = await _authService.login(username, password);

      // Routing decisions based on backend role
      switch (user.role.toLowerCase()) {
        case 'superadmin':
          return '/superadmin_home'; // Ready for when backend adds superadmin
        case 'admin':
          return '/admin_home';
        case 'learner':
        default:
          return '/learner_home';
      }
    } catch (e) {
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}