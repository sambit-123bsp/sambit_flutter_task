
import 'package:flutter/material.dart';
import 'package:sambit_project/api_service/api_routes.dart';
import 'package:sambit_project/main.dart';
import 'package:sambit_project/pages/Login/user.dart';
import 'package:sambit_project/pages/home/admin_home/admin_home_page.dart';
import 'package:sambit_project/pages/home/user_home/user_home_page.dart';
import 'package:sambit_project/utils/app_primary_button.dart';

import '../../api_service/api_services.dart';
import '../../local_storage/store_accessToken.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _isObscure = true;
  bool _isLoggedIn = false;

  bool get isObscure => _isObscure;

  bool get isLoading => _isLoading;

  String? get error => _error;

  bool get isLoggedIn => _isLoggedIn;

  void toggleVisibility() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  Future<void> login(String username, String password, GlobalKey<AppPrimaryButtonState> key) async {
    key.currentState?.showLoader();
    _error = null;
    notifyListeners();

    final response = await ApiService().post(ApiRoutes.authenticate, {
      'email': username,
      'password': password,
    });

    if (response.success) {
      final token = response.data['access_token'];
      User user = User.fromJson(response.data["user"]);
      await SecureStorageService().setAccessToken(token);
      await SecureStorageService().setRole(user.role.value);
      _isLoggedIn = true;
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => user.role==UserRole.User?UserHomePage():AdminHomePage()),
      );
    } else {
      _error = response.message;
    }
    key.currentState?.hideLoader();
    _isLoading = false;
    notifyListeners();
  }
}
