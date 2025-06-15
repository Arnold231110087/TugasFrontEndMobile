import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';
import 'about_page.dart';
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

  final List<Map<String, dynamic>> drawers = [
    {
      'section': 'Akun',
      'tiles': [
        {'title': 'Ubah profil', 'icon': Icons.person, 'page': EditProfilePage()},
        {'title': 'Ubah kata sandi', 'icon': Icons.lock, 'page': ChangePasswordPage()},
        {'title': 'Privasi', 'icon': Icons.privacy_tip},
        {'title': 'Notifikasi', 'icon': Icons.notifications},
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

  final Map<String, double> stats = {
    'penjualan': 1,
    'pengikut': 2,
    'mengikuti': 3,
  };

  final List<Map<String, dynamic>> sections = [
    {'icon': Icons.post_add, 'page': PostPage()},
    {'icon': Icons.sell, 'page': SalesPage()},
  ];

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            Row(
              children: [
                Icon(
                  Icons.dark_mode,
                  color: theme.textTheme.bodySmall!.color,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Mode gelap',
                    style: theme.textTheme.bodyMedium,
                  ),
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
            SizedBox(height: 24),
            ...drawers.expand<Widget>((drawer) => [
              DrawerSection(
                section: drawer['section'],
                tiles: drawer['tiles'],
              ),
              const SizedBox(height: 16),
            ]).toList()..removeLast(),
            SizedBox(height: 40),
            TextButton.icon(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(themeProvider.isDarkMode ? Color(0xFFE11D48) : Color(0xFFDC2626)),
                foregroundColor: WidgetStateProperty.all(theme.textTheme.displayMedium!.color),
                textStyle: WidgetStateProperty.all(theme.textTheme.displayMedium),
              ),
              label: Text('Keluar'),
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('images/profile1.png'),
                        radius: 40,
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Valerio Liuz Kienata',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: theme.textTheme.bodyMedium!.fontSize,
                                color: theme.textTheme.bodyMedium!.color,
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
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
                                      Text(
                                        entry.key,
                                        style: theme.textTheme.labelSmall,
                                      ),
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
                  SizedBox(height: 20),
                  Text(
                    'A student trying to become a designer',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
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
                    }
                  );
                }),
              ],
            ),
            Divider(),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: sections[selectedTab]['page'],
            ),
          ],
        ),
      ),
    );
  }
}
