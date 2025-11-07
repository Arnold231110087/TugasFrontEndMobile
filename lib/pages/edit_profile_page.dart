import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/input_field_1_component.dart';
import '../services/firebase.dart'; // Sesuaikan path ini jika perlu

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthService _authService = AuthService(); // Instance service

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

    // 1. Dapatkan user dari Firebase Auth
    User? user = _authService.currentUser;
    if (user == null) {
      if (mounted) Navigator.of(context).pushReplacementNamed('/login');
      return;
    }

    _uid = user.uid; // Simpan UID
    emailController.text = user.email ?? 'Tidak ada email'; // Email dari Auth

    // 2. Dapatkan data profil dari Firestore
    final userData = await _authService.getUserData(_uid);
    if (userData != null) {
      nameController.text = userData['username'] ?? '';
      bioController.text = userData['bio'] ?? ''; // Asumsi Anda menyimpan 'bio'

      // 3. Muat tanggal lahir (jika ada)
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
    if (_uid.isEmpty) return; // Pastikan UID ada
    if (!mounted) return;

    setState(() => _isSaving = true); // <-- 1. Loading DIMULAI
    final theme = Theme.of(context);

    try {
      // 1. Siapkan data untuk di-update di Firestore
      Map<String, dynamic> dataToUpdate = {
        'username': nameController.text.trim(),
        'bio': bioController.text.trim(),
        if (_selectedDate != null) 'dob': Timestamp.fromDate(_selectedDate!),
      };

      // 2. Panggil service untuk update Firestore
      await _authService.updateUserProfileData(_uid, dataToUpdate);

      // 3. Update SharedPreferences (cache lokal)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', nameController.text.trim());

      // --- PERBAIKAN (JIKA SUKSES) ---
      _showSnack('Profil berhasil disimpan', Colors.green);
      setState(() => _isSaving = false); // <-- 2. Loading DIHENTIKAN
      
      // Tunggu sebentar agar user bisa lihat snackbar, baru pop
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) Navigator.pop(context);
      // --- AKHIR PERBAIKAN ---

    } catch (e) {
      // --- PERBAIKAN (JIKA GAGAL) ---
      _showSnack('Gagal menyimpan profil: $e', Colors.red);
      if (mounted) {
        setState(() => _isSaving = false); // <-- 3. Loading DIHENTIKAN
      }
      // --- AKHIR PERBAIKAN ---
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
    FocusScope.of(context).requestFocus(FocusNode()); // Tutup keyboard
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
      // Tampilkan loading indicator jika sedang memuat data awal
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile1.png'), // Pastikan path benar
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
                  readOnly: true, // Gunakan parameter opsional
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
                  // Hubungkan ke _isSaving
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
                  // Tampilkan loading di dalam tombol
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