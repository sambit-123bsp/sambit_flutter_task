import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sambit_project/utils/app_primary_button.dart';
import 'package:sambit_project/utils/app_snack_bar.dart';
import 'package:sambit_project/utils/decoration.dart';

import '../../../utils/validator.dart';
import '../../Login/user.dart';
import 'admin_provider.dart';

class AddUserScreen extends StatefulWidget {
  final String? id;

  const AddUserScreen({super.key, this.id});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _buttonKey = GlobalKey<AppPrimaryButtonState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  UserRole _selectedRole = UserRole.User;
  bool _isEditMode = false;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _loadUserData(widget.id!);
      _isEditMode = true;
    }
  }

  void toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  Future<void> _loadUserData(String id) async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final user = adminProvider.getUserById(id);
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _selectedRole = user.role;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _buttonKey.currentState?.showLoader();
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    try {
      if (_isEditMode) {
        await adminProvider.editUser(
          userId: widget.id!,
          name: _nameController.text.trim(),
          role: _selectedRole,
        );
        AppSnackBar.success(context, "User updated successfully!");
      } else {
        await adminProvider.addUser(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          role: _selectedRole,
        );
        AppSnackBar.success(context, "User added successfully!");
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      AppSnackBar.error(context, "$e");
    } finally {
      _buttonKey.currentState?.hideLoader();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(_isEditMode ? "Edit User" : "Add User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: AppDecorations.textFieldDecoration(
                  context,
                ).copyWith(hintText: "Name"),
                validator: (val) => Validator.required(val, field: "Name"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                enabled: !_isEditMode,
                decoration: AppDecorations.textFieldDecoration(
                  context,
                ).copyWith(hintText: "Email"),
                validator: (val) => Validator.email(val),
              ),
              if (!_isEditMode) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: AppDecorations.textFieldDecoration(
                    context,
                  ).copyWith(
                    hintText: "Password",
                    suffixIcon: IconButton(
                      onPressed: toggleObscure,
                      icon:
                          _isObscure
                              ? Icon(Icons.remove_red_eye_rounded)
                              : Icon(CupertinoIcons.eye_slash_fill),
                    ),
                  ),
                  validator: (val) => Validator.password(val),
                ),
              ],
              const SizedBox(height: 16),
              DropdownButtonFormField<UserRole>(
                value: _selectedRole,
                decoration: AppDecorations.textFieldDecoration(
                  context,
                ).copyWith(hintText: "Role"),
                items:
                    UserRole.values
                        .map(
                          (role) => DropdownMenuItem(
                            value: role,
                            child: Text(role.value),
                          ),
                        )
                        .toList(),
                onChanged: !_isEditMode?(value) {
                  if (value != null) setState(() => _selectedRole = value);
                }:null,
              ),
              const SizedBox(height: 24),
              AppPrimaryButton(
                key: _buttonKey,
                onPressed: _submit,
                child: Text(_isEditMode ? "Update" : "Add User"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
