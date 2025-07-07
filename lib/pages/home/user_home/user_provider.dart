import 'package:flutter/material.dart';
import 'package:sambit_project/api_service/api_routes.dart';
import 'package:sambit_project/pages/home/user_home/edit_profile_screen.dart';
import 'package:sambit_project/utils/app_snack_bar.dart';
import '../../../api_service/api_services.dart';
import '../../Login/user.dart';


class UserProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  bool isLoading = false;
  bool editName = false;
  void toggleEdit(){
    editName = !editName;
    notifyListeners();
  }
  bool _isObscure1 = true;
  bool _isObscure2 = true;

  bool get isObscure1 => _isObscure1;
  bool get isObscure2 => _isObscure2;
  void toggleVisibilityOld(){
    _isObscure1=!_isObscure1;
    notifyListeners();
  }
  void toggleVisibilityNew(){
    _isObscure2=!_isObscure2;
    notifyListeners();
  }
  Future<void> fetchUserProfile() async {
    final response = await ApiService().get(ApiRoutes.user);
    if (response.success) {
      _user = User.fromJson(response.data);
      notifyListeners();
    } else {
      throw Exception(response.message ?? "Failed to fetch user profile");
    }
  }

  Future<User?> fetchUserProfileOnce() async {
    final response = await ApiService().get(ApiRoutes.user);
    if (response.success) {
      return User.fromJson(response.data);
    } else {
      throw Exception(response.message ?? "Failed to fetch user profile");
    }
  }

  Future<void> updateProfile({required String name,required BuildContext context}) async {
    if(name.trim().isEmpty){
      AppSnackBar.snackBar(context, "name is required");
      return ;
    }

    isLoading = true;
    notifyListeners();
    final body = {
      'name': name,
    };

    final response = await ApiService().patch(ApiRoutes.user, body);
    if (response.success) {
      _user = User.fromJson(response.data);
      notifyListeners();
      AppSnackBar.success(context, 'Profile updated successfully');

    } else {
      AppSnackBar.error(context, response.message ?? 'Profile update failed');
      //throw Exception(response.message ?? 'Profile update failed');
    }
    editName=false;
    isLoading=false;
    notifyListeners();
  }
Future<bool> updatePassword(String old, String newPass) async {
    final body = {
      "oldPassword": old,
      "password": newPass
    };

    final response = await ApiService().patch(ApiRoutes.updatePassword, body);
    if (response.success) {
      return true;
    } else {
      throw Exception(response.message ?? 'Password update failed');
    }
  }

  /// Clears user on logout or token expiration
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
