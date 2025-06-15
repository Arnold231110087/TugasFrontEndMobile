import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/auth/forgot_password_page.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/upload_page.dart';
import 'pages/notification_page.dart';
import 'pages/account_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'LogoDesain',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        cardColor: Color(0xFFF9FAFB),
        dividerColor: Color(0xFFD1E7FF),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF1E40AF),
          foregroundColor: Color(0xFFFFFFFF),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: Color(0xFFFFFFFF),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: Color(0xFFFFFFFF),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
          displayMedium: TextStyle(color: Color(0xFFFFFFFF), fontSize: 14),
          displaySmall: TextStyle(color: Color(0xFFFFFFFF), fontSize: 12),
          headlineLarge: TextStyle(color: Color(0xFF1E4FCC), fontSize: 18),
          headlineMedium: TextStyle(color: Color(0xFF1E4FCC), fontSize: 14),
          headlineSmall: TextStyle(color: Color(0xFF1E4FCC), fontSize: 12),
          bodyLarge: TextStyle(color: Color(0xFF1A1A1A), fontSize: 18),
          bodyMedium: TextStyle(color: Color(0xFF1A1A1A), fontSize: 14),
          bodySmall: TextStyle(color: Color(0xFF1A1A1A), fontSize: 12),
          labelLarge: TextStyle(color: Color(0xFF7A7A7A), fontSize: 18),
          labelMedium: TextStyle(color: Color(0xFF7A7A7A), fontSize: 14),
          labelSmall: TextStyle(color: Color(0xFF7A7A7A), fontSize: 12),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF121212),
        cardColor: Color(0xFF1A1A1A),
        dividerColor: Color(0xFF2C2C2C),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF121212),
          foregroundColor: Color(0xFFE0E0E0),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: Color(0xFF121212),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: Color(0xFF121212),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(color: Color(0xFFE0E0E0), fontSize: 18),
          displayMedium: TextStyle(color: Color(0xFFE0E0E0), fontSize: 14),
          displaySmall: TextStyle(color: Color(0xFFE0E0E0), fontSize: 12),
          headlineLarge: TextStyle(color: Color(0xFF5A8CD1), fontSize: 18),
          headlineMedium: TextStyle(color: Color(0xFF5A8CD1), fontSize: 14),
          headlineSmall: TextStyle(color: Color(0xFF5A8CD1), fontSize: 12),
          bodyLarge: TextStyle(color: Color(0xFFE0E0E0), fontSize: 18),
          bodyMedium: TextStyle(color: Color(0xFFE0E0E0), fontSize: 14),
          bodySmall: TextStyle(color: Color(0xFFE0E0E0), fontSize: 12),
          labelLarge: TextStyle(color: Color(0xFF8A8A8A), fontSize: 18),
          labelMedium: TextStyle(color: Color(0xFF8A8A8A), fontSize: 14),
          labelSmall: TextStyle(color: Color(0xFF8A8A8A), fontSize: 12),
        ),
      ),
      themeMode: themeProvider.themeMode,
      initialRoute: '/splash',
      routes: {
        '/': (context) => MainNavigation(),
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => LoginPage(),
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: theme.textTheme.headlineSmall!.color,
        unselectedItemColor: theme.textTheme.labelSmall!.color,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Unggah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}
