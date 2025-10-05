import 'package:flutter/material.dart';
import '../components/password_input_component.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah kamu yakin ingin mengganti password?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password berhasil diubah")),
                );
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ganti Password"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              PasswordInputField(
                controller: _oldPasswordController,
                label: "Password Lama",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Masukkan password lama";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              PasswordInputField(
                controller: _newPasswordController,
                label: "Password Baru",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Masukkan password baru";
                  }
                  if (value == _oldPasswordController.text) {
                    return "Password baru tidak boleh sama dengan password lama";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              PasswordInputField(
                controller: _confirmPasswordController,
                label: "Konfirmasi Password Baru",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Masukkan konfirmasi password";
                  }
                  if (value != _newPasswordController.text) {
                    return "Konfirmasi password tidak cocok";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text("Simpan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
