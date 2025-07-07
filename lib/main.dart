import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sambit_project/pages/Login/auth_provider.dart';
import 'package:sambit_project/pages/home/admin_home/admin_provider.dart';
import 'package:sambit_project/pages/splash/splash_page.dart';

import 'pages/home/user_home/user_provider.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthProvider(),),
      ChangeNotifierProvider(create: (context) => UserProvider(),),
      ChangeNotifierProvider(create: (context) => AdminProvider(),),
    ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashPage(),
    );
  }
}