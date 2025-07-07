import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:sambit_project/main.dart';
import 'package:sambit_project/pages/Login/user.dart';
import 'package:sambit_project/pages/home/admin_home/add_user.dart';

import 'admin_provider.dart';

class ManageUserScreen extends StatefulWidget {
  const ManageUserScreen({super.key});

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
   Future<void>? _future;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _future = Provider.of<AdminProvider>(context, listen: false).fetchUsers();
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Users"),
        actions: [
          TextButton.icon(
            onPressed: () {
              navigatorKey.currentState?.push(
                MaterialPageRoute(builder: (context) => AddUserScreen()),
              );
            },
            label: Text("Add User"),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (adminProvider.isLoading ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final users = adminProvider.users;

          if (users.isEmpty) {
            return const Center(child: Text("No users found."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final user = users[index];

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatar),
                ),
                title: Text(user.name),
                subtitle: Text('${user.email}\nRole: ${user.role.value}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: theme.primaryColor),
                      onPressed: () {
                        navigatorKey.currentState?.push(
                          MaterialPageRoute(
                            builder: (context) => AddUserScreen(id: user.id),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (ctx) => AlertDialog(
                                title: const Text("Delete User"),
                                content: const Text(
                                  "Are you sure you want to delete this user?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                        );

                        if (confirm == true) {
                          try {
                            await adminProvider.deleteUser(user.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Deleted ${user.name}")),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: ${e.toString()}")),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
