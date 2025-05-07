import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  // Constructor untuk memuat tema saat aplikasi pertama kali dijalankan
  ThemeProvider() {
    _loadTheme();
  }

  // Default theme mode (light)
  ThemeMode _themeMode = ThemeMode.light;

  // Getter untuk mengambil nilai themeMode
  ThemeMode get themeMode => _themeMode;

  // Getter untuk mengecek apakah Dark Mode aktif
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Fungsi untuk mengubah tema antara Light dan Dark
  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    _saveTheme(isOn); // Menyimpan pengaturan tema ke SharedPreferences
    notifyListeners(); // Memberitahu widget untuk melakukan rebuild
  }

  // Fungsi untuk memuat tema yang tersimpan dari SharedPreferences
  Future<void> _loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isDark = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Memberitahu widget agar merender ulang jika tema berubah
  }

  // Fungsi untuk menyimpan tema ke SharedPreferences
  Future<void> _saveTheme(bool isDark) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark); // Menyimpan pilihan tema
  }
}
