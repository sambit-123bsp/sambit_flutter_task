import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../local_storage/store_accessToken.dart';
import '../../../main.dart';
import '../../Login/login_page.dart';
import '../../Login/user.dart';
import '../user_home/user_provider.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  late Future<User?> _futureUser;
  String name = "";

  @override
  void initState() {
    super.initState();
    // Fetch once & reuse the future
    _futureUser = Provider.of<UserProvider>(context, listen: false).fetchUserProfileOnce();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Profile"),
      ),
      body: FutureBuilder<User?>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text("No user data found."));
          }

          name = user.name;

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user.avatar),
                ),
                const SizedBox(height: 20),
                Text(user.name, style: const TextStyle(color: Colors.black)),
                const SizedBox(height: 8),
                Text(user.email, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.verified_user, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Text('Role: ${user.role.value}'),
                  ],
                ),
                const SizedBox(height: 16),
                TextButton(
                  child: Text("Logout",style: TextStyle(color: Colors.red),),
                  onPressed: () {
                    SecureStorageService service = SecureStorageService();
                    service.deleteAccessToken();
                    navigatorKey.currentState?.pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
