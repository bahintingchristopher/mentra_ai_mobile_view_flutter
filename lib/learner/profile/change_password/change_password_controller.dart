import 'package:flutter/material.dart';
import 'change_password_model.dart';
import 'change_password_service.dart';

class ChangePasswordController extends ChangeNotifier {
  final ChangePasswordService _service = ChangePasswordService();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isObscured = true;
  bool isLoading = false;

  void toggleVisibility() {
    isObscured = !isObscured;
    notifyListeners();
  }

  void resetFields() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    notifyListeners();
  }

  Future<bool> submitPasswordChange() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      return false;
    }

    isLoading = true;
    notifyListeners();

    final model = ChangePasswordModel(
      currentPassword: currentPasswordController.text,
      newPassword: newPasswordController.text,
      confirmPassword: confirmPasswordController.text,
    );

    bool result = await _service.changePassword(model);
    isLoading = false;
    if (result) resetFields();
    notifyListeners();
    return result;
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}