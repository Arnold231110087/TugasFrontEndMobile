import 'package:flutter/material.dart';
import '../components/help_section_component.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Bantuan'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            HelpSearchBar(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HelpCategorySection(
                      title: 'Akun & Keamanan',
                      filter: searchQuery,
                      faqs: [
                        {
                          'question': 'Bagaimana cara mengganti kata sandi?',
                          'answer': 'Masuk ke Pengaturan > Ubah Kata Sandi.'
                        },
                        {
                          'question': 'Saya lupa kata sandi saya.',
                          'answer': 'Gunakan fitur Lupa Kata Sandi di halaman login.'
                        },
                      ],
                    ),
                    HelpCategorySection(
                      title: 'Desain & Transaksi',
                      filter: searchQuery,
                      faqs: [
                        {
                          'question': 'Bagaimana cara memesan desain?',
                          'answer': 'Kunjungi profil desainer, lalu tekan "Ajukan Transaksi".'
                        },
                        {
                          'question': 'Bagaimana cara melihat portofolio desainer?',
                          'answer': 'Buka halaman profil desainer untuk melihat karya-karyanya.'
                        },
                      ],
                    ),
                    HelpCategorySection(
                      title: 'Pembayaran & Keamanan',
                      filter: searchQuery,
                      faqs: [
                        {
                          'question': 'Metode pembayaran apa saja yang didukung?',
                          'answer': 'Kami mendukung transfer bank dan e-wallet.'
                        },
                        {
                          'question': 'Apakah pembayaran saya aman?',
                          'answer': 'Ya, semua transaksi diamankan dengan enkripsi.'
                        },
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
