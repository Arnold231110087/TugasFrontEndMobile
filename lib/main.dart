import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_arnold/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'providers/theme_provider.dart';
import 'providers/post_provider.dart';

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


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  
  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
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
      
      // --- TEMA TERANG (LIGHT THEME) ---
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        cardColor: const Color(0xFFF9FAFB),
        dividerColor: const Color(0xFFD1E7FF),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF1E40AF),
          foregroundColor: Color(0xFFFFFFFF),
        ),
        popupMenuTheme: const PopupMenuThemeData(
          color: Color(0xFFFFFFFF),
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: Color(0xFFFFFFFF),
        ),
        textTheme: const TextTheme(
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
      
      // --- TEMA GELAP (DARK THEME) ---
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1A1A1A),
        dividerColor: const Color(0xFF2C2C2C),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF121212),
          foregroundColor: Color(0xFFE0E0E0),
        ),
        popupMenuTheme: const PopupMenuThemeData(
          color: Color(0xFF121212),
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: Color(0xFF121212),
        ),
        // --- DUPLIKASI DIHAPUS ---
        textTheme: const TextTheme(
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
        '/': (context) => const MainNavigation(),
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/forgot-password': (context) => ForgotPasswordPage(),
      },
    );
  }
}

// --- NAVIGASI BAWAH  ---

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    UploadPage(),
    NotificationPage(),
    AccountPage(), 
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        selectedItemColor: theme.textTheme.headlineSmall!.color,
        unselectedItemColor: theme.textTheme.labelSmall!.color,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
            tooltip: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cari',
            tooltip: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Unggah',
            tooltip: 'Unggah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notifikasi',
            tooltip: 'Notifikasi',
          ),
          // --- 'TYPO' DIHAPUS DARI SINI ---
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
            tooltip: 'Akun',
          ),
        ],
      ),
    );
  }
}