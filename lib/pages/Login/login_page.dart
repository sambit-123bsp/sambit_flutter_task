import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sambit_project/utils/app_primary_button.dart';
import 'package:sambit_project/utils/decoration.dart';

import 'auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      Provider.of<AuthProvider>(
        context,
        listen: false,
      ).login(username, password,_buttonKey);
    }
  }
  GlobalKey<AppPrimaryButtonState> _buttonKey = GlobalKey<AppPrimaryButtonState>();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              keyboardType: TextInputType.emailAddress,
              decoration:AppDecorations.textFieldDecoration(context).copyWith(hintText: 'Enter email id'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: auth.isObscure,
              decoration: AppDecorations.textFieldDecoration(context).copyWith(
                hintText: 'Enter password',

                suffixIcon: IconButton(
                  onPressed: auth.toggleVisibility,
                  icon:
                      auth.isObscure
                          ? Icon(Icons.remove_red_eye_rounded)
                          : Icon(CupertinoIcons.eye_slash_fill),
                ),
              ),
            ),
            const SizedBox(height: 24),
           AppPrimaryButton(
              key: _buttonKey,
                  onPressed: _submit,
                  child: const Text('Login'),
                ),
            if (auth.error != null) ...[
              const SizedBox(height: 12),
              Text(auth.error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
