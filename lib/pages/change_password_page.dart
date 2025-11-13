import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <-- Tambahkan ini
import '../components/password_input_component.dart';
import '../services/firebase.dart';

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


  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _showSnack(String message, Color backgroundColor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: backgroundColor,
      ),
    );
  }

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
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() => _isLoading = true);

                try {
                  await _authService.changePassword(
                    _oldPasswordController.text.trim(),
                    _newPasswordController.text.trim(),
                  );

                  _showSnack("Password berhasil diubah", Colors.green);
                  if (mounted) Navigator.pop(context); 

                } on FirebaseAuthException catch (e) {
                  String message;
                  if (e.code == 'wrong-password' || e.code == 'INVALID_LOGIN_CREDENTIALS') {
                    message = "Password lama Anda salah.";
                  } else {
                    message = e.message ?? "Terjadi kesalahan";
                  }
                  _showSnack(message, Colors.red);
                } catch (e) {
                  _showSnack("Terjadi kesalahan: $e", Colors.red);
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
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
                  if (value.length < 6) {
                    return "Password minimal 6 karakter";
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
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Simpan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}