import 'package:flutter/material.dart';
import 'sales_page.dart';
import 'post_page.dart';
import 'account_settings.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int selectedTab = 0;
  bool isSettingsOpen = false;

  final List<Widget> tabs = [PostPage(), SalesPage()];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context); // Access the current theme

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor, // Use theme for background color
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(theme),
            _buildProfileInfo(theme),
            if (!isSettingsOpen) _buildTabMenu(theme),
            Expanded(
              child: isSettingsOpen ? AccountSettings() : tabs[selectedTab],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: theme.primaryColor, // Use primary color from theme
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Valerio Liuz Kienata",
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white, // Text color from theme
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.menu,
              color: theme.iconTheme.color,
            ), // Icon color from theme
            onPressed: () {
              // future menu page if needed
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(ThemeData theme) {
    return Container(
      color: theme.cardColor, // Use card color from theme
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('images/profile1.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "2 Followers  |  3 Following",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("A student trying to become a designer"),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: theme.iconTheme.color,
            ), // Icon color from theme
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountSettings()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabMenu(ThemeData theme) {
    return Container(
      color: theme.cardColor, // Use card color from theme
      child: Row(
        children: [
          _buildTabIcon(Icons.post_add, 0, theme),
          _buildTabIcon(Icons.sell, 1, theme),
        ],
      ),
    );
  }

  Widget _buildTabIcon(IconData icon, int index, ThemeData theme) {
    return Expanded(
      child: IconButton(
        icon: Icon(
          icon,
          color:
              selectedTab == index
                  ? theme.primaryColor
                  : theme.iconTheme.color, // Active tab color from theme
        ),
        onPressed: () {
          setState(() {
            selectedTab = index;
            isSettingsOpen = false; // Close settings if tab selected
          });
        },
      ),
    );
  }
}
