import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';

class ModeSettingsPage extends StatelessWidget {
  const ModeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan Mode"),
      ),
      body: ListTile(
        title: const Text("Aktifkan Mode Gelap"),
        trailing: Switch(
          value: themeNotifier.isDarkMode,
          onChanged: (val) {
            themeNotifier.toggleTheme(val);
          },
        ),
      ),
    );
  }
}
