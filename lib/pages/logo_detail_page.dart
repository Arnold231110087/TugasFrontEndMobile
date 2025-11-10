import 'dart:math';
import 'package:flutter/material.dart';
import '../pages/account_page.dart';

class LogoDetailPage extends StatelessWidget {
  final String name;
  final String domain;
  final String logoUrl;

  const LogoDetailPage({
    super.key,
    required this.name,
    required this.domain,
    required this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<Map<String, dynamic>> randomDesigners = [
      {
        'designerName': 'Kevin Durant',
        'imageAsset': 'assets/images/profile1.png',
        'sales': '120',
        'rating': 4.8,
        'followers': '2.5K',
      },
      {
        'designerName': 'Rendy Aditya',
        'imageAsset': 'assets/images/profile1.png',
        'sales': '89',
        'rating': 4.6,
        'followers': '1.2K',
      },
      {
        'designerName': 'Alicia Putri',
        'imageAsset': 'assets/images/profile1.png',
        'sales': '240',
        'rating': 4.9,
        'followers': '3.1K',
      },
    ];

    final randomDesigner = randomDesigners[Random().nextInt(randomDesigners.length)];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          style: theme.textTheme.displayLarge?.copyWith(
            color: theme.appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor, 
        iconTheme: IconThemeData(color: theme.appBarTheme.foregroundColor),
        elevation: 0,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                logoUrl,
                height: 120,
                width: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 80),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              domain,
              style: theme.textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AccountPage(
                      // designerName: randomDesigner['designerName'],
                      // imageAsset: randomDesigner['imageAsset'],
                      // sales: randomDesigner['sales'],
                      // rating: randomDesigner['rating'],
                      // followers: randomDesigner['followers'],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
              label: const Text(
                "Pesan Logo",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.appBarTheme.backgroundColor ?? const Color(0xFF1E40AF),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
