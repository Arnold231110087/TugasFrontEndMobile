import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';

// class AccountSettings extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFE6ECFF),
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//             color: const Color(0xFF0039A6),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: const Icon(Icons.arrow_back, color: Colors.white),
//                 ),
//                 const SizedBox(width: 16),
//                 const Text(
//                   'Account Settings',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               children: [
//                 _buildSettingsTile(Icons.person, "Edit Profile"),
//                 _buildSettingsTile(Icons.lock, "Change Password"),
//                 _buildSettingsTile(Icons.privacy_tip, "Privacy"),
//                 _buildSettingsTile(Icons.notifications, "Notifications"),
//                 _buildSettingsTile(Icons.logout, "Log Out", isLogout: true),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingsTile(
//     IconData icon,
//     String title, {
//     bool isLogout = false,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: isLogout ? Colors.red : Colors.black),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: isLogout ? Colors.red : Colors.black,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//         ],
//       ),
//     );
//   }
// }

class AccountSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider via context
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context); // Access the current theme

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor, // Dynamic background color
      appBar: AppBar(
        backgroundColor:
            theme.appBarTheme.backgroundColor, // AppBar background from theme
        elevation: 0,
        automaticallyImplyLeading: false, // Disable default back button
        title: Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 12),

          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  color: theme.iconTheme.color,
                ), // Icon color from theme
              ),
              const SizedBox(width: 16),
              Text(
                'Account Settings',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          // You can add other actions if needed
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // List of settings
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildDarkModeTile(context, themeProvider, theme),
                _buildSettingsTile(Icons.person, "Edit Profile", theme),
                _buildSettingsTile(Icons.lock, "Change Password", theme),
                _buildSettingsTile(Icons.privacy_tip, "Privacy", theme),
                _buildSettingsTile(Icons.notifications, "Notifications", theme),
                _buildSettingsTile(
                  Icons.logout,
                  "Log Out",
                  theme,
                  isLogout: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dark Mode Tile (Switch)
  Widget _buildDarkModeTile(
    BuildContext context,
    ThemeProvider themeProvider,
    ThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: theme.cardColor, // Card color based on theme
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.dark_mode,
            color: theme.iconTheme.color,
          ), // Icon color based on theme
          const SizedBox(width: 16),
          const Expanded(
            child: Text("Dark Mode", style: TextStyle(fontSize: 16)),
          ),
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
        ],
      ),
    );
  }

  // Helper function for other settings
  Widget _buildSettingsTile(
    IconData icon,
    String title,
    ThemeData theme, {
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: theme.cardColor, // Use dynamic card color
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isLogout ? Colors.red : theme.iconTheme.color,
          ), // Icon color from theme
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color:
                    isLogout
                        ? Colors.red
                        : theme
                            .textTheme
                            .bodyLarge
                            ?.color, // Dynamic text color
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: theme.iconTheme.color,
          ), // Arrow color from theme
        ],
      ),
    );
  }
}
