import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/input_field_1_component.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController =
      TextEditingController(text: 'Valerio Liuz Kienata');
  final TextEditingController emailController =
      TextEditingController(text: 'valerio.kongxifacai@gmail.com');
  final TextEditingController bioController =
      TextEditingController(text: 'A student trying to become a designer');

  final TextEditingController dobController = TextEditingController();
  DateTime? _selectedDate = DateTime(2005, 1, 1);

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    if (_selectedDate != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    }
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('username') ?? 'Valerio Liuz Kienata';
      emailController.text = prefs.getString('email') ?? 'valerio.kongxifacai@gmail.com';
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', nameController.text);
    await prefs.setString('email', emailController.text);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
      helpText: 'Pilih Tanggal Lahir',
      confirmText: 'PILIH',
      cancelText: 'BATAL',
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          Container(
            alignment: Alignment.center,
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile1.png'),
              radius: 48,
            ),
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: 40),
          InputField1(
            label: 'Nama',
            controller: nameController,
          ),
          const SizedBox(height: 24),
          InputField1(
            label: 'Email',
            controller: emailController,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: dobController,
            style: theme.textTheme.bodyMedium,
            cursorColor: theme.textTheme.headlineSmall!.color,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Tanggal Lahir',
              labelStyle: theme.textTheme.labelMedium,
              hintText: 'YYYY-MM-DD',
              suffixIcon: const Icon(Icons.calendar_today),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: theme.dividerColor),
              ),
            ),
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: 24),
          InputField1(
            label: 'Bio',
            controller: bioController,
          ),
          const SizedBox(height: 40),
          TextButton(
            onPressed: () async {
              await _saveProfileData();
              if (context.mounted) {
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
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: theme.textTheme.headlineSmall!.color,
              foregroundColor: theme.textTheme.displaySmall!.color,
              textStyle: theme.textTheme.displayMedium,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
