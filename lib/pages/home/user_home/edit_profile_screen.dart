import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sambit_project/utils/app_primary_button.dart';
import 'package:sambit_project/utils/app_snack_bar.dart';
import 'package:sambit_project/utils/decoration.dart';
import 'package:sambit_project/utils/validator.dart';

import 'user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _buttonKey = GlobalKey<AppPrimaryButtonState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      _nameController.text = user.name;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
      return;
    }

    try {
      _buttonKey.currentState?.showLoader();
      await Provider.of<UserProvider>(context, listen: false).updatePassword(
        _oldPasswordController.text,
            _passwordController.text
      );
      if (mounted) {
        Navigator.pop(context);
        AppSnackBar.success(context, "Password updated successfully!");
      }
    } catch (e) {
      AppSnackBar.error(context, "$e");
    } finally {
      _buttonKey.currentState?.hideLoader();

    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Update Password")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            spacing: 16,
            children: [
              TextFormField(
                controller: _oldPasswordController,
                keyboardType: TextInputType.text,
                decoration: AppDecorations.textFieldDecoration(context).copyWith(
                  hintText: "Enter old password",
                  suffixIcon: IconButton(
                    onPressed: userProvider.toggleVisibilityOld,
                    icon:
                    userProvider.isObscure1
                        ? Icon(Icons.remove_red_eye_rounded)
                        : Icon(CupertinoIcons.eye_slash_fill),
                  ),
                ),
                obscureText: userProvider.isObscure1,
              ),
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.text,
                obscureText: userProvider.isObscure2,
                decoration: AppDecorations.textFieldDecoration(context).copyWith(
                    hintText: "Enter new password",
                  suffixIcon: IconButton(
                    onPressed: userProvider.toggleVisibilityNew,
                    icon:
                    userProvider.isObscure2
                        ? Icon(Icons.remove_red_eye_rounded)
                        : Icon(CupertinoIcons.eye_slash_fill),
                  ),
                ),
              ),
              AppPrimaryButton(
                key: _buttonKey,
                  onPressed: _save, child: Text("Change")),
            ],
          ),
        ),
      ),
    );
  }
}

