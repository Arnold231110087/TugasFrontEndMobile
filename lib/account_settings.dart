import 'package:flutter/material.dart';
import 'edit_profile.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({
    super.key
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6ECFF),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                color: const Color(0xFF0039A6),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                        const Text(
                          'Account Settings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                    ],
                  ),
            ),
            const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildSettingsTile(Icons.person, "Edit Profile", onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                            const EditProfilePage()),
                        );
                      }),

                      _buildSettingsTile(Icons.lock, "Change Password"),
                      _buildSettingsTile(Icons.privacy_tip, "Privacy"),
                      _buildSettingsTile(Icons.notifications, "Notifications"),
                      _buildSettingsTile(Icons.logout, "Log Out", isLogout: true, onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Akun berhasil logout')),
                        );
                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.pushReplacementNamed(context, '/login'); // pastikan route '/login' sudah didefinisikan
                        });
                      }),

                    ],
                ),
              ),
          ],
        ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {
    bool isLogout = false,
    VoidCallback ? onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(icon, color: isLogout ? Colors.red : Colors.black),
                const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        color: isLogout ? Colors.red : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
      ),
    );
  }
}