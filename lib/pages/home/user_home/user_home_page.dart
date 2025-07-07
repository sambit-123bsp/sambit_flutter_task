import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sambit_project/local_storage/store_accessToken.dart';
import 'package:sambit_project/main.dart';
import 'package:sambit_project/pages/Login/login_page.dart';
import '../../Login/user.dart';
import 'edit_profile_screen.dart';
import 'user_provider.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
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
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("User Profile"),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      initialValue: user.name,
                      enabled: userProvider.editName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                      decoration: const InputDecoration(border: InputBorder.none),
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                    if (userProvider.editName)
                      if (userProvider.isLoading)
                        const CircularProgressIndicator()
                      else
                        TextButton(
                          onPressed: () => userProvider.updateProfile(
                            name: name,
                            context: context,
                          ),
                          child: const Text("Save"),
                        )
                    else
                      TextButton(
                        onPressed: userProvider.toggleEdit,
                        child: const Text("Edit"),
                      ),
                  ],
                ),
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
                  child: Text("Update Password"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                    );
                  },
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
