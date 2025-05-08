import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'UNGGAH',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: theme.textTheme.displayLarge!.fontSize,
            color: theme.textTheme.displayLarge!.color,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('images/profile1.png'),
                  radius: 24,
                ),
                SizedBox(width: 16),
                Text(
                  'Valerio Liuz Kienata',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: theme.textTheme.bodyMedium!.fontSize,
                    color: theme.textTheme.bodyMedium!.color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Tulis Sesuatu...',
                  hintStyle: theme.textTheme.labelMedium,
                  filled: true,
                  fillColor: theme.cardColor,
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: themeProvider.isDarkMode ? theme.cardColor : theme.appBarTheme.backgroundColor,
                foregroundColor: theme.textTheme.displaySmall!.color,
                textStyle: theme.textTheme.displayMedium,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Unggah'),
            ),
          ],
        ),
      ),
    );
  }
}
