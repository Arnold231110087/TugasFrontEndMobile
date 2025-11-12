import 'package:flutter/material.dart';
import 'package:mobile_arnold/utils/string_format.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Tetap perlu untuk error handling
import '../../components/input_field_2_component.dart';
import '../../services/firebase.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService(); // Instance service

  bool _isLoading = false;

  Future<void> _login() async {
    final theme = Theme.of(context);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    
    // --- Validasi Input ---
    final emailRegex =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

    if (email.isEmpty || password.isEmpty) {
      _showSnack('Email dan kata sandi tidak boleh kosong', theme);
      return;
    }
    if (email.length > 50) {
      _showSnack('Email terlalu panjang', theme);
      return;
    }
    if (!RegExp(emailRegex).hasMatch(email)) {
      _showSnack('Email tidak valid', theme);
      return;
    }
    if (password.length < 6) {
      _showSnack('Kata sandi minimal 6 karakter', theme);
      return;
    }
    // --- Akhir Validasi ---

    setState(() => _isLoading = true); // <-- 1. Loading DIMULAI

    try {
      // 1. Panggil service untuk login
      UserCredential userCredential =
          await _authService.signIn(email, password);

      if (userCredential.user != null) {
        final user = userCredential.user!;

        // 2. Panggil service untuk ambil data user
        final userData = await _authService.getUserData(user.uid);
        String username = userData?['username'].toString().toTitleCase() ?? user.email!;
        String bio = userData?['bio'] ?? '';

        // 3. Simpan sesi
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
        await prefs.setString('username', username);
        await prefs.setString('email', user.email!);
        await prefs.setString('uid', user.uid); 
        await prefs.setString('bio', bio);

        // --- INI PERBAIKANNYA (JIKA SUKSES) ---
        setState(() => _isLoading = false); // <-- 4. Loading DIHENTIKAN
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/'); // <-- 5. Baru Navigasi
        // --- AKHIR PERBAIKAN ---

      } else {
         // Handle jika user null (meskipun jarang terjadi)
        setState(() => _isLoading = false); // <-- Hentikan loading
        _showSnack('Gagal mendapatkan detail user', theme);
      }

    } on FirebaseAuthException catch (e) {
      // --- PERBAIKAN JIKA GAGAL ---
      setState(() => _isLoading = false); // <-- Loading DIHENTIKAN
      // --- AKHIR PERBAIKAN ---

      String message;
      if (e.code == 'user-not-found' || e.code == 'INVALID_LOGIN_CREDENTIALS') {
        message = 'Email belum terdaftar atau kata sandi salah.';
      } else if (e.code == 'wrong-password') {
        message = 'Kata sandi salah, silakan coba lagi.';
      } else {
        message = 'Email atau kata sandi salah.';
      }
      _showSnack(message, theme);

    } catch (e) {
      // --- PERBAIKAN JIKA GAGAL ---
      setState(() => _isLoading = false); // <-- Loading DIHENTIKAN
      // --- AKHIR PERBAIKAN ---
      _showSnack('Terjadi kesalahan: $e', theme);
    } 
  }

  void _showSnack(String message, ThemeData theme) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- (Seluruh kode UI Anda tidak berubah) ---
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.asset(
                          "assets/images/logo.jpg", // Pastikan path ini benar
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Selamat datang di',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Text(
                    'LOGODESAIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),

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
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue.shade900,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isLoading ? null : _login, // Terhubung ke _login
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.blue,
                              ),
                            )
                          : const Text('Masuk'),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgot-password');
                      },
                      child: const Text(
                        'Lupa sandi',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Belum memiliki akun',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('Daftar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}