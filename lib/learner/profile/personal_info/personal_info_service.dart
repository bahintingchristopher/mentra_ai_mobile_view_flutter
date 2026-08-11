import 'personal_info_model.dart';

class PersonalInfoService {
  Future<PersonalInfoModel> fetchPersonalInfo() async {
    // Replace with your API endpoint GET call
    await Future.delayed(const Duration(milliseconds: 300));
    return PersonalInfoModel(
      firstName: 'Big',
      lastName: 'Learner',
      email: 'big_learner@bigbang.com',
      phoneNumber: '+1234567890',
    );
  }

  Future<bool> updatePersonalInfo(PersonalInfoModel model) async {
    // Replace with your API endpoint PUT/POST call
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}