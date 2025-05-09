import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../components/input_field_1_component.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  final TextEditingController nameController = TextEditingController(text: 'Valerio Liuz Kienata');
  final TextEditingController emailController = TextEditingController(text: 'valerio.kongxifacai@gmail.com');
  final TextEditingController bioController = TextEditingController(text: 'A student trying to become a designer');

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'UBAH PROFIL',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: theme.textTheme.displayLarge!.fontSize,
            color: theme.textTheme.displayLarge!.color,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        children: [
          Container(
            alignment: Alignment.center,
            child: CircleAvatar(backgroundImage: AssetImage('images/profile1.png'), radius: 48),
          ),
          SizedBox(height: 8),
          Container(
            alignment: Alignment.center,
            child: TextButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.camera_alt,
                color: theme.textTheme.headlineSmall!.color,
              ),
              label: Text(
                'Change image or avatar',
                style: theme.textTheme.headlineMedium,
              ),
            ),
          ),
          SizedBox(height: 40),
          InputField1(
            label: 'Nama',
            controller: nameController,
          ),
          SizedBox(height: 24),
          InputField1(
            label: 'Email',
            controller: emailController,
          ),
          SizedBox(height: 24),
          InputField1(
            label: 'Bio',
            controller: bioController,
          ),
          SizedBox(height: 40),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Profil berhasil disimpan',
                    style: theme.textTheme.displayMedium,
                  ),
                  backgroundColor: Colors.green.shade800,
                ),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: themeProvider.isDarkMode ? theme.cardColor : theme.appBarTheme.backgroundColor,
              foregroundColor: theme.textTheme.displaySmall!.color,
              textStyle: theme.textTheme.displayMedium,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}