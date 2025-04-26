import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              children: [
                // Logo
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.ac_unit, size: 48, color: Colors.blue),
                    // Ganti dengan logo asli jika ada
                  ),
                ),

                Text(
                  'Selamat datang di',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'LOGODESAIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 32),

                // Email field
                buildInputField(
                  icon: Icons.email,
                  hint: 'Email',
                  controller: emailController,
                ),

                // Password field
                buildInputField(
                  icon: Icons.lock,
                  hint: 'Kata sandi',
                  controller: passwordController,
                  obscureText: true,
                ),

                const SizedBox(height: 12),

                // Tombol Login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade900,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Email dan password tidak boleh kosong"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (!email.contains('@') ||
                          (!email.endsWith('.com') && !email.endsWith('.ac.id'))) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Email harus valid"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: Text("Masuk"),
                  ),
                ),

                const SizedBox(height: 8),

                // Lupa Sandi
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot-password');
                    },
                    child: Text("Lupa sandi", style: TextStyle(color: Colors.white)),
                  ),
                ),

                const SizedBox(height: 24),

                // Belum punya akun
                Text('Belum memiliki akun', style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),

                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text('Daftar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
