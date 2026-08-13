import 'package:flutter/material.dart';
import 'personal_info_model.dart';
import 'personal_info_service.dart';

class PersonalInfoController extends ChangeNotifier {
  final PersonalInfoService _service;

  PersonalInfoModel? info;
  bool isLoading = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

 PersonalInfoController(): _service = PersonalInfoService();

  Future<void> loadProfileData() async {
    isLoading = true;
    notifyListeners();

    info = await _service.fetchPersonalInfo();

    if (info != null) {
      firstNameController.text = info!.firstName;
      lastNameController.text = info!.lastName;
      emailController.text = info!.email;
      phoneController.text = info!.phoneNumber;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> saveChanges() async {
    if (info == null) return false;

    isLoading = true;
    notifyListeners();

    final updatedModel = PersonalInfoModel(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      phoneNumber: phoneController.text.trim(),
    );

    final success = await _service.updatePersonalInfo(updatedModel);

    if (success) {
      info = updatedModel;
    }

    isLoading = false;
    notifyListeners();

    return success;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}