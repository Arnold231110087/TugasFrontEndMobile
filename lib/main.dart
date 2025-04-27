import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'upload_page.dart';
import 'notification_page.dart';
import 'account_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LogoDesain',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => MainNavigation(), // Ganti ke MainNavigation
        '/register': (context) => RegisterPage(),
        '/forgot-password': (context) => ForgotPasswordPage(),
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    UploadPage(),
    NotificationPage(),
    AccountPage(),
  ];

  final _title = [
    'LOGODESAIN','LOGODESAIN',"Unggahan Baru","LOGODESAIN",'LOGODESAIN'
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
            child: _selectedIndex == 4 ? Text("VALERIO LIUZ KIENATA",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),) : Icon(Icons.chat_bubble_outline, color: Colors.white),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 60,
              width: double.infinity, // Adjust the height as needed
              child: DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF1E3A8A)),
                child: const Text(
                  'Account Settings',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerTile(
                    title: 'Edit Profile',
                    icon: const Icon(Icons.person),
                  ),
                  _buildDrawerTile(
                    title: 'Change Password',
                    icon: const Icon(Icons.lock),
                  ),
                  _buildDrawerTile(
                    title: 'Privacy',
                    icon: const Icon(Icons.privacy_tip),
                  ),
                  _buildDrawerTile(
                    title: 'Notifications',
                    icon: const Icon(Icons.notifications),
                  ),
                ],
              ),
            ),
            const Divider(),
            _buildDrawerTile(title: 'Log out', icon: const Icon(Icons.logout)),
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
    Widget _buildDrawerTile({required String title, required Icon icon}) {
    return ListTile(title: Text(title), leading: icon,onTap: (){},);
  }
}
