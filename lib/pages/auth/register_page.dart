import 'package:flutter/material.dart';
import '../../components/input_field_2_component.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Daftar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                // Nama Pengguna
                InputField2(
                  icon: Icons.person,
                  hint: 'Nama pengguna',
                  controller: usernameController,
                ),
                // Email
                InputField2(
                  icon: Icons.email,
                  hint: 'Email',
                  controller: emailController,
                ),
                // Kata sandi
                InputField2(
                  icon: Icons.lock,
                  hint: 'Kata sandi',
                  controller: passwordController,
                  obscureText: true,
                ),
                // Konfirmasi kata sandi
                InputField2(
                  icon: Icons.lock_outline,
                  hint: 'Konfirmasi kata sandi',
                  controller: confirmPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                // Tombol Daftar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      // Tambahkan validasi jika ingin
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Akun berhasil didaftar',
                            style: theme.textTheme.displayMedium,
                          ),
                          backgroundColor: Colors.green.shade800,
                        ),
                      );
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text('Buat akun'),
                  ),
                ),
                const SizedBox(height: 24),
                // Sudah punya akun - Start
                Text(
                  'Sudah memiliki akun',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white),
                    padding: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 32,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Masuk'),
                ),
                // Sudah punya akun - End
              ],
            ),
          ),
        ),
      ),
    );
  }
}
