import 'package:flutter/material.dart';
import '../components/about_us_section_component.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Kami'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          AboutUsSection(
            title: 'Siapa Kami?',
            description:
                'LOGODESAIN adalah platform kreatif yang menghubungkan desainer logo profesional dengan pelanggan dari seluruh Indonesia. Kami hadir sebagai solusi bagi individu maupun bisnis yang ingin mendapatkan identitas visual yang unik dan berkualitas.',
          ),
          SizedBox(height: 24),
          AboutUsSection(
            title: 'Visi Kami',
            description:
                'Menjadi platform desain terpercaya yang membangun ekosistem kreatif, berkelanjutan, dan memberikan dampak positif bagi industri desain lokal.',
          ),
          SizedBox(height: 24),
          AboutUsSection(
            title: 'Misi Kami',
            description:
                '- Mempermudah proses transaksi desain antara klien dan desainer.\n'
                '- Menyediakan tempat aman dan transparan untuk menampilkan karya.\n'
                '- Mendukung perkembangan talenta lokal melalui berbagai fitur komunitas.',
          ),
          SizedBox(height: 24),
          AboutUsSection(
            title: 'Mengapa Memilih Kami?',
            description:
                'Kami bukan hanya sekadar platform transaksi desain. Kami adalah ruang kolaborasi, tempat belajar, dan showcase bagi desainer untuk berkembang dan dikenal lebih luas. Dengan sistem rating, portofolio, dan pengikut, kami bantu kamu membangun reputasi.',
          ),
          SizedBox(height: 24),
          AboutUsSection(
            title: 'Kontak Kami',
            description:
                'Email: support@logodesain.id\nWhatsApp: 0812-3456-7890\nInstagram: @logodesain_id',
          ),
        ],
      ),
    );
  }
}
