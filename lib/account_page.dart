import 'package:flutter/material.dart';
import 'sales_page.dart';
import 'post_page.dart';
import 'account_settings.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State < AccountPage > {
  int selectedTab = 0;
  bool isSettingsOpen = false;

  final List < Widget > tabs = [
    PostPage(),
    SalesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe6ecff),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildProfileInfo(),
              if (!isSettingsOpen) _buildTabMenu(),
                Expanded(
                  child: isSettingsOpen ?
                  AccountSettings() :
                  tabs[selectedTab],
                ),
            ],
          ),
        ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
        color: const Color(0xff0039a6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                  "Valerio Liuz Kienata",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      // future menu page if needed
                    },
                )
            ],
          ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/avatar.png'),
              ),
              const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("2 Followers  |  3 Following", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("A student trying to become a designer")
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountSettings()),
                    );
                  },
                )

          ],
        ),
    );
  }

  Widget _buildTabMenu() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          _buildTabIcon(Icons.post_add, 0),
          _buildTabIcon(Icons.sell, 1),
        ],
      ),
    );
  }

  Widget _buildTabIcon(IconData icon, int index) {
    return Expanded(
      child: IconButton(
        icon: Icon(
          icon,
          color: selectedTab == index ?
          const Color(0xff0039a6): Colors.grey,
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