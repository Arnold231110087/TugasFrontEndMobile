// import 'package:flutter/material.dart';
// import 'package:mobile_arnold/services/firebase.dart';
// import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // <-- Tambahkan
// import '../providers/theme_provider.dart';
// import 'sales_page.dart';
// import '../components/account_page_section_button_component.dart';
// import 'chat_detail_page.dart';

// class DesignerAccountPage extends StatefulWidget {
//   // --- 1. HANYA PERLU 'userId' ---
//   final String userId;

//   const DesignerAccountPage({
//     super.key,
//     required this.userId, // <-- Terima 'userId' dari hasil pencarian
//   });
//   // --- AKHIR PERUBAHAN ---

//   @override
//   State<DesignerAccountPage> createState() => _DesignerAccountPageState();
// }

// class _DesignerAccountPageState extends State<DesignerAccountPage> {
//   int selectedTab = 0;
//   bool _isFollowing = false; // Logika 'follow' tetap (meski belum fungsional)
  
//   // --- 2. TAMBAHKAN AuthService ---
//   final AuthService _authService = AuthService();
//   // --- AKHIR PERUBAHAN ---

//   final List<Map<String, dynamic>> sections = [
//     {'icon': Icons.post_add, 'title': 'Postingan', 'page': null},
//     {'icon': Icons.sell, 'title': 'Penjualan', 'page': SalesPage()},
//   ];

//   Map<String, dynamic> _getChatDataForDesigner(String name, String image) {
//     return {
//       'username': name,
//       'profileImage': image,
//       'messages': <Map<String, dynamic>>[], 
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final ThemeData theme = Theme.of(context);
    
//     // Hapus parsing 'stats' yang lama

//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       // --- 3. BUNGKUS 'SingleChildScrollView' DENGAN 'StreamBuilder' ---
//       body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//         // Ambil data user desainer berdasarkan 'widget.userId'
//         stream: _authService.getUserDataStream(widget.userId),
//         builder: (context, snapshot) {
          
//           // Tampilkan loading
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Scaffold(
//               appBar: AppBar(
//                 title: Text(
//                   'Memuat Profil...',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: theme.textTheme.displayLarge!.fontSize,
//                     color: theme.textTheme.displayLarge!.color,
//                   ),
//                 ),
//               ),
//               body: const Center(child: CircularProgressIndicator()),
//             );
//           }
          
//           // Tampilkan error
//           if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
//             return Scaffold(
//               appBar: AppBar(title: const Text("Error")),
//               body: const Center(child: Text('Gagal memuat profil desainer')),
//             );
//           }
          
//           // --- 4. AMBIL DATA DINAMIS DARI SNAPSHOT ---
//           final userData = snapshot.data!.data() ?? {};
//           final String designerName = userData['username'] ?? 'Desainer';
//           final String bio = userData['bio'] ?? 'Bio belum diatur.';
//           // Asumsi Anda menyimpan URL gambar di 'profileImageUrl'
//           // Jika tidak, ganti 'assets/images/profile1.png'
//           final String imageAsset = userData['profileImageUrl'] ?? 'assets/images/profile1.png'; 
          
//           // Ambil stats (pastikan nama field ini ada di Firestore Anda)
//           final Map<String, double> stats = {
//             'penjualan': (userData['salesCount'] ?? 0).toDouble(),
//             'pengikut': (userData['followerCount'] ?? 0).toDouble(),
//             'mengikuti': (userData['followingCount'] ?? 0).toDouble(),
//           };
//           // --- AKHIR PERUBAHAN ---

//           // --- 5. KEMBALIKAN UI DENGAN DATA DINAMIS ---
//           return Scaffold(
//             appBar: AppBar(
//               title: Text(
//                 designerName.toUpperCase(), // <-- Data dinamis
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: theme.textTheme.displayLarge!.fontSize,
//                   color: theme.textTheme.displayLarge!.color,
//                 ),
//               ),
//             ),
//             body: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             CircleAvatar(
//                               backgroundImage: AssetImage(imageAsset), // <-- Data dinamis
//                               radius: 40,
//                             ),
//                             const SizedBox(width: 24),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     designerName, // <-- Data dinamis
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: theme.textTheme.bodyMedium!.fontSize,
//                                       color: theme.textTheme.bodyMedium!.color,
//                                     ),
//                                   ),
//                                   SizedBox(height: 12),
//                                   Row(
//                                     children: [
//                                       ...stats.entries.expand<Widget>(
//                                         (entry) => [
//                                           Column(
//                                             children: [
//                                               Text(
//                                                 entry.value.toStringAsFixed(0), // <-- Data dinamis
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: theme.textTheme.bodyMedium!.fontSize,
//                                                   color: theme.textTheme.bodyMedium!.color,
//                                                 ),
//                                               ),
//                                               Text(
//                                                 entry.key,
//                                                 style: theme.textTheme.labelSmall,
//                                               ),
//                                             ],
//                                           ),
//                                           const SizedBox(width: 32),
//                                         ],
//                                       ).toList()..removeLast(),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 20),
//                         Text(
//                           bio.isNotEmpty ? '"$bio"' : 'Bio belum diatur.', // <-- Data dinamis
//                           style: theme.textTheme.bodyMedium?.copyWith(
//                             fontStyle: bio.isNotEmpty ? FontStyle.italic : FontStyle.normal,
//                             color: bio.isNotEmpty
//                                 ? theme.textTheme.bodyMedium!.color
//                                 : theme.textTheme.bodySmall!.color,
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: ElevatedButton.icon(
//                                 onPressed: () {
//                                   // TODO: Tambahkan logika follow/unfollow ke Firebase
//                                   setState(() => _isFollowing = !_isFollowing);
//                                 },
//                                 icon: Icon(
//                                   _isFollowing ? Icons.check : Icons.person_add_alt_1,
//                                 ),
//                                 label: Text(_isFollowing ? 'Diikuti' : 'Ikuti'),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: _isFollowing ? theme.cardColor : theme.primaryColor,
//                                   foregroundColor: _isFollowing ? theme.textTheme.bodyMedium!.color : theme.colorScheme.onPrimary,
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 20,
//                                     vertical: 12,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                     side:
//                                         _isFollowing
//                                             ? BorderSide(color: theme.dividerColor)
//                                             : BorderSide.none,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 8),
//                             Expanded(
//                               child: OutlinedButton.icon(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => ChatDetailPage(
//                                         chat: _getChatDataForDesigner(designerName, imageAsset), // <-- Data dinamis
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 icon: Icon(Icons.chat_bubble_outline),
//                                 label: Text('Pesan'),
//                                 style: OutlinedButton.styleFrom(
//                                   foregroundColor: theme.primaryColor,
//                                   side: BorderSide(color: theme.primaryColor),
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 20,
//                                     vertical: 12,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       ...sections.asMap().entries.map((entry) {
//                         final int index = entry.key;
//                         final Map<String, dynamic> section = entry.value;

//                         return AccountPageSectionButton(
//                           icon: section['icon'],
//                           isActive: selectedTab == index,
//                           onPressed: () {
//                             setState(() {
//                               selectedTab = index;
//                             });
//                           },
//                         );
//                       }),
//                     ],
//                   ),
//                   Divider(),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//                     child: Builder(
//                       builder: (context) {
//                         if (selectedTab == 0) {
//                           return Center(
//                             child: Column(
//                               children: [
//                                 Icon(
//                                   Icons.image_not_supported_outlined,
//                                   size: 60,
//                                   color: theme.colorScheme.onSurface.withOpacity(0.4),
//                                 ),
//                                 SizedBox(height: 16),
//                                 Text(
//                                   'Belum ada postingan dari desainer ini.',
//                                   style: theme.textTheme.titleMedium?.copyWith(
//                                     color: theme.colorScheme.onSurface.withOpacity(
//                                       0.6,
//                                     ),
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 SizedBox(height: 200),
//                               ],
//                             ),
//                           );
//                         } else if (selectedTab == 1) {
//                           return sections[selectedTab]['page'];
//                         }
//                         return SizedBox.shrink();
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//           // --- AKHIR UI ---
//         },
//       ),
//     );
//   }
// }