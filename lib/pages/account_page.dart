import 'package:flutter/material.dart';
import 'package:mobile_arnold/services/firebase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- Pastikan ini ada
import '../providers/theme_provider.dart';
import '../providers/post_provider.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';
import 'about_page.dart';
import 'history_page.dart';
import 'account_status_page.dart';
import 'policy_page.dart';
import 'help_page.dart';
import 'post_page.dart';
import 'sales_page.dart';
import '../components/drawer_section_component.dart';
import '../components/account_page_section_button_component.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int selectedTab = 0;
  
  // State diubah: kita tidak lagi menyimpan username/bio
  // Kita hanya perlu AuthService dan UID
  final AuthService _authService = AuthService();
  String? _uid;

  @override
  void initState() {
    super.initState();
    // Ambil UID user yang sedang login saat halaman dibuka
    _uid = _authService.currentUser?.uid;
  }

  // Fungsi _loadUserData() sudah tidak diperlukan lagi

  // (List 'drawers', 'stats', 'sections' Anda tetap sama)
  final List<Map<String, dynamic>> drawers = [
    {
      'section': 'Akun',
      'tiles': [
        {'title': 'Ubah profil', 'icon': Icons.person, 'page': EditProfilePage()},
        {'title': 'Ubah kata sandi', 'icon': Icons.lock, 'page': ChangePasswordPage()},
        {'title': 'Privasi', 'icon': Icons.privacy_tip},
        {'title': 'Histori', 'icon': Icons.history, 'page': HistoryPage()},
      ],
    },
    {
      'section': 'Pengaturan aplikasi',
      'tiles': [
        {'title': 'Bahasa', 'icon': Icons.language},
        {'title': 'Tema', 'icon': Icons.color_lens_outlined},
      ],
    },
    {
      'section': 'Bantuan dan layanan',
      'tiles': [
        {'title': 'Status akun', 'icon': Icons.account_circle_outlined, 'page': AccountStatusPage()},
        {'title': 'Obrolan dukungan teknis', 'icon': Icons.support_agent},
        {'title': 'Hubungi kami', 'icon': Icons.phone_in_talk_outlined},
        {'title': 'Bantuan', 'icon': Icons.help_outline, 'page': HelpPage()},
      ],
    },
    {
      'section': 'Informasi lebih lanjut',
      'tiles': [
        {'title': 'Ketentuan dan kebijakan', 'icon': Icons.description_outlined, 'page': PolicyPage()},
        {'title': 'Tentang kami', 'icon': Icons.info_outline, 'page': AboutUsPage()},
      ],
    },
  ];

  final Map<String, int> stats = {
    'penjualan': 1,
    'pengikut': 2,
    'mengikuti': 3,
  };

  final List<Map<String, dynamic>> sections = [
    {'icon': Icons.post_add, 'page': PostPage()},
    {'icon': Icons.sell, 'page': SalesPage()},
  ];

  Future<void> _logout(BuildContext context) async {
    final authService = AuthService();
    await authService.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 

    if (context.mounted) {
      Provider.of<PostProvider>(context, listen: false).clearPosts();
    }

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'PROFIL',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: theme.textTheme.displayLarge!.fontSize,
            color: theme.textTheme.displayLarge!.color,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  color: theme.textTheme.displaySmall!.color,
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        backgroundColor: theme.scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            Row(
              children: [
                Icon(Icons.dark_mode, color: theme.textTheme.bodySmall!.color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Mode gelap', style: theme.textTheme.bodyMedium),
                ),
                Switch(
                  inactiveTrackColor: theme.scaffoldBackgroundColor,
                  inactiveThumbColor: theme.textTheme.labelSmall!.color,
                  activeColor: theme.textTheme.headlineSmall!.color,
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...drawers
                .expand<Widget>(
                  (drawer) => [
                    DrawerSection(section: drawer['section'], tiles: drawer['tiles']),
                    const SizedBox(height: 16),
                  ],
                )
                .toList()
              ..removeLast(),
            const SizedBox(height: 40),
            TextButton.icon(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  themeProvider.isDarkMode
                      ? const Color(0xFFE11D48)
                      : const Color(0xFFDC2626),
                ),
                foregroundColor: WidgetStateProperty.all(theme.textTheme.displayMedium!.color),
                textStyle: WidgetStateProperty.all(theme.textTheme.displayMedium),
              ),
              label: const Text('Keluar'),
              icon: const Icon(Icons.logout),
              onPressed: () async {
                // konfirmasi dulu
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: const Text('Apakah kamu yakin ingin keluar dari akun ini?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Keluar')),
                    ],
                  ),
                );
                if (confirm == true) {
                  _logout(context);
                }
              },
            ),
          ],
        ),
      ),
      // --- PERUBAHAN UTAMA ADA DI SINI ---
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bungkus UI Profil dengan StreamBuilder
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              // 1. Tentukan Stream: dengarkan data user berdasarkan UID
              stream: _uid != null ? _authService.getUserDataStream(_uid!) : null,
              builder: (context, snapshot) {
                
                // 2. Tampilkan loading spinner selagi data dimuat
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    // Buat UI "skeleton" (loading palsu) agar tidak loncat
                    child: _ProfileHeaderLoadingSkeleton(), 
                  );
                }

                // 3. Tampilkan error jika ada
                if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Center(child: Text('Gagal memuat data profil')),
                  );
                }

                // 4. Jika data berhasil didapat
                final userData = snapshot.data!.data();
                final String username = userData?['username'] ?? 'Pengguna';
                final String bio = userData?['bio'] ?? 'Bio belum diatur';

                // 5. Kembalikan UI Profil Anda dengan data dinamis
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/profile1.png'),
                            radius: 40,
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  username, // <-- Data dinamis dari Stream
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: theme.textTheme.bodyMedium!.fontSize,
                                    color: theme.textTheme.bodyMedium!.color,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    // ... (Stats Anda tetap sama) ...
                                    ...stats.entries.expand<Widget>((entry) => [
                                      Column(
                                        children: [
                                          Text(
                                            entry.value.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: theme.textTheme.bodyMedium!.fontSize,
                                              color: theme.textTheme.bodyMedium!.color,
                                            ),
                                          ),
                                          Text(entry.key, style: theme.textTheme.labelSmall),
                                        ],
                                      ),
                                      const SizedBox(width: 32),
                                    ]).toList()..removeLast(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        // Jika bio tidak kosong, tambahkan tanda kutip.
                        // Jika kosong, tampilkan placeholder.
                        bio.isNotEmpty ? bio : 'Bio belum diatur',
                        
                        style: theme.textTheme.bodyMedium?.copyWith(
                          // Tambahkan style miring untuk memperjelas
                          fontStyle: bio.isNotEmpty ? FontStyle.italic : FontStyle.normal,
                          
                          // Buat warna placeholder sedikit pudar agar tidak terlalu menonjol
                          color: bio.isNotEmpty
                              ? theme.textTheme.bodyMedium!.color
                              : theme.textTheme.bodySmall!.color,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                );
              },
            ),
            // --- AKHIR BAGIAN YANG DIPERBARUI ---

            // Bagian Tab (Post/Sales) tetap sama
            Row(
              children: [
                ...sections.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final Map<String, dynamic> section = entry.value;

                  return AccountPageSectionButton(
                    icon: section['icon'],
                    isActive: selectedTab == index,
                    onPressed: () {
                      setState(() {
                        selectedTab = index;
                      });
                    },
                  );
                }),
              ],
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: sections[selectedTab]['page'],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget internal untuk menampilkan loading yang cantik (opsional tapi disarankan)
class _ProfileHeaderLoadingSkeleton extends StatelessWidget {
  const _ProfileHeaderLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    // Anda bisa membuat ini lebih bagus dengan package 'shimmer'
    // Tapi untuk sekarang, CircularProgressIndicator sudah cukup
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}