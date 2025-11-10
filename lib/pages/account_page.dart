import 'package:flutter/material.dart';
import 'package:mobile_arnold/services/firebase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
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
import 'chat_detail_page.dart'; // <-- Tambahkan ini
import '../components/drawer_section_component.dart';
import '../components/account_page_section_button_component.dart';

class AccountPage extends StatefulWidget {
  final String? userId;

  const AccountPage({
    super.key,
    this.userId, 
  });

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int selectedTab = 0;
  
  final AuthService _authService = AuthService();
  String? _uid;
  bool _isMyProfile = false; 
  bool _isFollowing = false; 

  @override
  void initState() {
    super.initState();
    
    // --- PERBAIKAN LOGIKA DI SINI ---
    String? currentLoggedInUid = _authService.currentUser?.uid;

    if (widget.userId == null || widget.userId == currentLoggedInUid) {
      // Ini adalah profil SAYA jika:
      // 1. Dibuka dari tab bar (widget.userId == null)
      // 2. Dibuka dari search TAPI userId-nya == UID saya
      _uid = currentLoggedInUid;
      _isMyProfile = true;
    } else {
      // Ini adalah profil ORANG LAIN
      _uid = widget.userId;
      _isMyProfile = false;
      // TODO: Tambahkan logika cek 'isFollowing'
    }
    // --- AKHIR PERBAIKAN ---
  }

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
  
  Map<String, dynamic> _getChatData(String name, String image) {
    return {
      'username': name,
      'profileImage': image,
      'messages': <Map<String, dynamic>>[], 
    };
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: !_isMyProfile, 
        title: Text(
          _isMyProfile ? 'PROFIL SAYA' : 'PROFIL DESAINER',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: theme.textTheme.displayLarge!.fontSize,
            color: theme.textTheme.displayLarge!.color,
          ),
        ),
        actions: [
          if (_isMyProfile)
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
      endDrawer: _isMyProfile ? Drawer(
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
      ) : null,
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: _uid != null ? _authService.getUserDataStream(_uid!) : null,
              builder: (context, snapshot) {
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: _ProfileHeaderLoadingSkeleton(), 
                  );
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Center(child: Text('Gagal memuat data profil')),
                  );
                }

                final userData = snapshot.data!.data() ?? {};
                final String username = userData['username'] ?? 'Pengguna';
                final String bio = userData['bio'] ?? 'Bio belum diatur';
                final String imageAsset = userData['profileImageUrl'] ?? 'assets/images/profile1.png';
                
                final Map<String, int> dynamicStats = {
                  'penjualan': userData['salesCount'] ?? 0,
                  'pengikut': userData['followerCount'] ?? 0,
                  'mengikuti': userData['followingCount'] ?? 0,
                };

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(imageAsset),
                            radius: 40,
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  username, 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: theme.textTheme.bodyMedium!.fontSize,
                                    color: theme.textTheme.bodyMedium!.color,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    ...dynamicStats.entries.expand<Widget>(
                                      (entry) => [
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
                                            Text(
                                              entry.key,
                                              style: theme.textTheme.labelSmall,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 32),
                                      ],
                                    ).toList()..removeLast(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        bio.isNotEmpty ? '"$bio"' : 'Bio belum diatur.', 
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: bio.isNotEmpty ? FontStyle.italic : FontStyle.normal,
                          color: bio.isNotEmpty
                              ? theme.textTheme.bodyMedium!.color
                              : theme.textTheme.bodySmall!.color,
                        ),
                      ),
                      
                      if (!_isMyProfile)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() => _isFollowing = !_isFollowing);
                                  },
                                  icon: Icon(_isFollowing ? Icons.check : Icons.person_add_alt_1),
                                  label: Text(_isFollowing ? 'Diikuti' : 'Ikuti'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isFollowing ? theme.cardColor : theme.primaryColor,
                                    foregroundColor: _isFollowing ? theme.textTheme.bodyMedium!.color : theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatDetailPage(
                                          chat: _getChatData(username, imageAsset),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.chat_bubble_outline),
                                  label: Text('Pesan'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: theme.primaryColor,
                                    side: BorderSide(color: theme.primaryColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            
            if (_isMyProfile) ...[
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
            ]
          ],
        ),
      ),
    );
  }
}

class _ProfileHeaderLoadingSkeleton extends StatelessWidget {
  const _ProfileHeaderLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}