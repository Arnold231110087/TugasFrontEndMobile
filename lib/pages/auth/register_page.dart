import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_arnold/services/firebase.dart'; 
import '../../components/input_field_2_component.dart'; 

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _registerUser(
      BuildContext context, String username, String email, String password) async {
    
    setState(() => _isLoading = true);

    try {
      // Panggil fungsi register
      await _authService.register(email, password, username);

      // --- SUKSES ---
      setState(() => _isLoading = false);
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Akun berhasil dibuat! Silakan login."),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');

    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String message;
      
      if (e.code == 'email-already-in-use') {
        message = 'Email sudah terdaftar, gunakan email lain.';
      } else if (e.code == 'weak-password') {
        message = 'Kata sandi terlalu lemah (minimal 6 karakter).';
      } else if (e.code == 'username-already-in-use') { 
        // Error custom dari AuthService
        message = 'Nama pengguna ini sudah terdaftar. Coba yang lain.';
        // Rollback aman
        await _authService.signOut(); 
      } else {
        message = e.message ?? 'Terjadi kesalahan.';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }

    } catch (e) {
      // Error umum
      setState(() => _isLoading = false);
      String message = e.toString();
      
      if (message.contains('username-already-in-use')) { 
        message = 'Nama pengguna ini sudah terdaftar. Coba yang lain.';
        await _authService.signOut(); 
      } else {
        message = 'Registrasi gagal: $e';
        await _authService.signOut(); 
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mengembalikan Background Gradient Asli Anda
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
              children: [
                const Text(
                  'Daftar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                
                InputField2(
                  icon: Icons.person,
                  hint: 'Nama pengguna',
                  controller: usernameController,
                ),
                InputField2(
                  icon: Icons.email,
                  hint: 'Email',
                  controller: emailController,
                ),
                InputField2(
                  icon: Icons.lock,
                  hint: 'Kata sandi',
                  controller: passwordController,
                  obscureText: true,
                ),
                InputField2(
                  icon: Icons.lock_outline,
                  hint: 'Konfirmasi kata sandi',
                  controller: confirmPasswordController,
                  obscureText: true,
                ),
                
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () async {
                            final username = usernameController.text.trim();
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            final confirmPassword = confirmPasswordController.text.trim();

                            if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Semua kolom wajib diisi'), backgroundColor: Colors.red),
                              );
                              return;
                            }
                            if (username.length < 3) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Nama pengguna minimal 3 karakter'), backgroundColor: Colors.red),
                              );
                              return;
                            }
                             if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Format email tidak valid'), backgroundColor: Colors.red),
                              );
                              return;
                            }
                            if (password.length < 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Password minimal 6 karakter'), backgroundColor: Colors.red),
                              );
                              return;
                            }
                            if (password != confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Konfirmasi password tidak cocok'), backgroundColor: Colors.red),
                              );
                              return;
                            }
                            
                            await _registerUser(context, username, email, password);
                          },
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.blue,
                            ),
                          )
                        : const Text('Buat akun'),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                const Text(
                  'Sudah punya akun?',
                  style: TextStyle(color: Colors.white),
                ),
                
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                  onPressed: () {
                    if (_isLoading) return; 
                    Navigator.pop(context);
                  },
                  child: const Text('Masuk'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}