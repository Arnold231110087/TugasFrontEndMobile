import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mode_settings_page.dart';
import 'theme_notifier.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'upload_page.dart';
import 'notification_page.dart';
import 'account_page.dart';
import 'chat_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key
  });
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of <ThemeNotifier> (context);
    return MaterialApp(
      title: 'LogoDesain',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.currentTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => MainNavigation(),
        '/register': (context) => RegisterPage(),
        '/forgot-password': (context) => ForgotPasswordPage(),
        '/mode-settings': (context) => ModeSettingsPage(), 
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({
    super.key
  });
  @override
  State < MainNavigation > createState() => _MainNavigationState();
}

class _MainNavigationState extends State < MainNavigation > {
  int _selectedIndex = 0;

  final List < Widget > _pages = [
    HomePage(),
    SearchPage(),
    UploadPage(),
    NotificationPage(),
    AccountPage(),
  ];

  final _title = [
    'LOGODESAIN', 'LOGODESAIN', "Unggahan Baru", "LOGODESAIN", 'LOGODESAIN'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF1E3A8A);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
                color: Colors.white,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
            );
          },
        ),
        title: Text(
          _title[_selectedIndex],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
              child: _selectedIndex == 4 ? Text("VALERIO LIUZ KIENATA", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold), ) :
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage()),
                    );
                  },
              ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF1E3A8A)),
                child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Pengaturan aplikasi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
                _buildDrawerTile(title: 'Bahasa', icon: const Icon(Icons.language)),
                _buildDrawerTile(title: 'Tema', icon: const Icon(Icons.color_lens_outlined)),
                _buildDrawerTile(
                  title: 'Mode',
                  icon: const Icon(Icons.wb_sunny_outlined),
                    onTap: () {
                      Navigator.pop(context); // tutup drawer
                      Navigator.pushNamed(context, '/mode-settings');
                    },
                ),


                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Bantuan dan layanan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                  _buildDrawerTile(title: 'Status akun', icon: const Icon(Icons.account_circle_outlined)),
                  _buildDrawerTile(title: 'Obrolan dukungan teknis', icon: const Icon(Icons.support_agent)),
                  _buildDrawerTile(title: 'Hubungi kami', icon: const Icon(Icons.phone_in_talk_outlined)),
                  _buildDrawerTile(title: 'Bantuan', icon: const Icon(Icons.help_outline)),

                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Informasi lebih lanjut', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    ),
                    _buildDrawerTile(title: 'Ketentuan dan kebijakan', icon: const Icon(Icons.description_outlined)),
                    _buildDrawerTile(title: 'Tentang kami', icon: const Icon(Icons.info_outline)),
          ],
        ),
      ),

      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue.shade900,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Cari"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: "Unggah"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: "Notifikasi"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
      ),
    );
  }
  Widget _buildDrawerTile({
    required String title,
    required Icon icon,
    VoidCallback ? onTap
  }) {
    return ListTile(
      title: Text(title),
      leading: icon,
      onTap: onTap ?? () {},
    );
  }
}