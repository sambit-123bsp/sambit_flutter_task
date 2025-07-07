import 'package:flutter/material.dart';
import 'package:sambit_project/pages/home/admin_home/admin_home_page.dart';
import 'package:sambit_project/pages/home/user_home/user_home_page.dart';
import '../../local_storage/store_accessToken.dart';
import '../../main.dart';
import '../Login/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> navigateTo() async {
    SecureStorageService secureStorageService = SecureStorageService();
    String? accessToken = await secureStorageService.accessToken;
    String? role = await secureStorageService.role;
    if (accessToken == null) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      if (role == "User") {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => UserHomePage()),
        );
      } else if (role == "Admin") {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      }
      else{
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    }
  }

  @override
  void initState() {
    navigateTo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Auth Role")));
  }
}
