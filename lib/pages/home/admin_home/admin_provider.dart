import 'package:flutter/material.dart';
import 'package:sambit_project/api_service/api_routes.dart';

import '../../../api_service/api_services.dart';
import '../../Login/user.dart';

class AdminProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
   int currentTab = 0;
  List<User> _users = [];
  List<User> get users => _users;

  void changeTab(int value){
    currentTab = value;
    notifyListeners();
  }
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    final res = await _api.get(ApiRoutes.manageUser);
    _isLoading = false;

    if (res.success) {
      _users = List<User>.from(res.data.map((u) => User.fromJson(u)));
      notifyListeners();
    } else {
      throw Exception(res.message ?? 'Failed to fetch users');
    }
  }

  Future<bool> addUser({
    required String name,
    required String email,
    required String password,
    required UserRole role
}) async {
    final res = await _api.post(ApiRoutes.manageUser, {
      'name': name,
      'email': email,
      'password': password,
      'role': role.value,
    });

    if (res.success) {
      await fetchUsers(); // Refresh list
      return true;
    } else {
      throw Exception(res.message ?? 'Failed to add user');
    }
  }

  /// Edit user (but prevent editing self outside UI)
  Future<bool> editUser({
    required String userId,
    required String name,
    required UserRole role,
  }) async {
    final res = await _api.patch('${ApiRoutes.manageUser}/$userId', {
      'name': name,
      'role': role.value,
    });

    if (res.success) {
      await fetchUsers(); // Refresh list
      return true;
    } else {
      throw Exception(res.message ?? 'Failed to update user');
    }
  }

  Future<bool> deleteUser(String userId) async {
    final res = await _api.delete('${ApiRoutes.manageUser}/$userId');

    if (res.success) {
      _users.removeWhere((u) => u.id == userId);
      notifyListeners();
      return true;
    } else {
      throw Exception(res.message ?? 'Failed to delete user');
    }
  }

  User? getUserById(String id) {
    return _users.firstWhere((u) => u.id == id,);
  }

  void clear() {
    _users = [];
    notifyListeners();
  }
}
