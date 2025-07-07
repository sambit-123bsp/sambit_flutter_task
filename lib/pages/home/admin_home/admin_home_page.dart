import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sambit_project/pages/home/admin_home/admin_profile.dart';
import 'package:sambit_project/pages/home/admin_home/admin_provider.dart';
import 'package:sambit_project/pages/home/admin_home/manage_users.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    final adminProvider = Provider.of<AdminProvider>(context,listen: false);
    adminProvider.currentTab = 0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: adminProvider.currentTab,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: adminProvider.changeTab,
          items: [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile"),
      ]),
      body: [ManageUserScreen(),AdminProfile()][adminProvider.currentTab],
    );
  }
}
