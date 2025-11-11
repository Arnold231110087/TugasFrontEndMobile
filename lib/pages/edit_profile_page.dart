import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_arnold/services/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/input_field_1_component.dart'; // Sesuaikan path

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthService _authService = AuthService(); // Instance service

  // Controller diinisialisasi kosong
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  DateTime? _selectedDate;
  bool _isLoading = false; // Untuk loading data awal
  bool _isSaving = false;  // Untuk loading saat simpan
  String _uid = ''; // Untuk menyimpan UID user

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);

    User? user = _authService.currentUser;
    if (user == null) {
      if (mounted) Navigator.of(context).pushReplacementNamed('/login');
      return;
    }

    _uid = user.uid; 
    emailController.text = user.email ?? 'Tidak ada email'; 

    final userData = await _authService.getUserData(_uid);
    if (userData != null) {
      nameController.text = userData['username'] ?? '';
      bioController.text = userData['bio'] ?? ''; 

      if (userData['dob'] != null && userData['dob'] is Timestamp) {
        _selectedDate = (userData['dob'] as Timestamp).toDate();
        dobController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      }
    }

    setState(() => _isLoading = false);
  }

  void _showSnack(String message, Color backgroundColor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (_uid.isEmpty) return; 
    if (!mounted) return;

    setState(() => _isSaving = true); 
    
    // Validasi sederhana (opsional, tapi bagus)
    final username = nameController.text.trim();
    if (username.length < 3) {
      _showSnack('Username minimal 3 karakter', Colors.red);
      setState(() => _isSaving = false);
      return;
    }

    try {
      Map<String, dynamic> dataToUpdate = {
        'username': username.toLowerCase(),
        'bio': bioController.text.trim(),
        if (_selectedDate != null) 'dob': Timestamp.fromDate(_selectedDate!),
      };

      // Panggil service (versi sederhana)
      await _authService.updateUserProfileData(_uid, dataToUpdate);

      // Update SharedPreferences (cache lokal)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', nameController.text.trim());
      await prefs.setString('bio', bioController.text.trim());

      _showSnack('Profil berhasil disimpan', Colors.green);
      setState(() => _isSaving = false); 
      
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) Navigator.pop(context);

    } catch (e) {
      // Error handling sederhana
      _showSnack('Gagal menyimpan profil: $e', Colors.red);
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
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
                    onPressed: () {
                      // TODO: Tambahkan logika ganti gambar
                    },
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
                  readOnly: true, 
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
                  onPressed: _isSaving ? null : _saveProfile,
                  style: TextButton.styleFrom(
                    backgroundColor: theme.textTheme.headlineSmall!.color,
                    foregroundColor: theme.textTheme.displaySmall!.color,
                    textStyle: theme.textTheme.displayMedium,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Simpan'),
                ),
              ],
            ),
    );
  }
}