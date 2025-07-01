import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

// Assuming input_field_1_component.dart exists and is used for other fields
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

  // --- NEW: For Date of Birth Input ---
  final TextEditingController dobController = TextEditingController();
  DateTime? _selectedDate = DateTime(2005,1,1); // Stores the actual DateTime object

  @override
  void initState() {
    super.initState();
    // Optional: If you want to pre-fill the date field, e.g., from existing profile data
    // _selectedDate = DateTime(1995, 8, 15); // Example initial date
    if (_selectedDate != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    dobController.dispose(); // Dispose the new controller
    super.dispose();
  }

  // --- NEW: Function to handle date selection ---
  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1), // Sensible default for DOB
      firstDate: DateTime(1900, 1, 1), // Earliest possible birth date
      lastDate: DateTime.now(),        // Cannot be born in the future
      helpText: 'Pilih Tanggal Lahir', // Custom text for the dialog header
      confirmText: 'PILIH',            // Custom text for the confirm button
      cancelText: 'BATAL',             // Custom text for the cancel button
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
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        children: [
          Container(
            alignment: Alignment.center,
            child: const CircleAvatar(
                backgroundImage: AssetImage('images/profile1.png'), radius: 48),
          ),
          const SizedBox(height: 8),
          Container(
            alignment: Alignment.center,
            child: TextButton.icon(
              onPressed: () {
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
          // --- END NEW ---

          InputField1(
            label: 'Bio',
            controller: bioController,
          ),
          const SizedBox(height: 40),
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
              backgroundColor: theme.textTheme.headlineSmall!.color,
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