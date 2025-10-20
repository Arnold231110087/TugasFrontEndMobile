import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'sales_page.dart';
import '../components/account_page_section_button_component.dart';
import 'chat_detail_page.dart';

class DesignerAccountPage extends StatefulWidget {
  final String designerName;
  final String imageAsset;
  final String sales;
  final double rating;
  final String followers;

  const DesignerAccountPage({
    super.key,
    required this.designerName,
    required this.imageAsset,
    required this.sales,
    required this.rating,
    required this.followers,
  });

  @override
  State<DesignerAccountPage> createState() => _DesignerAccountPageState();
}

class _DesignerAccountPageState extends State<DesignerAccountPage> {
  int selectedTab = 0;
  bool _isFollowing = false;

  final List<Map<String, dynamic>> sections = [
    {'icon': Icons.post_add, 'title': 'Postingan', 'page': null},
    {'icon': Icons.sell, 'title': 'Penjualan', 'page': SalesPage()},
  ];

  Map<String, dynamic> _getChatDataForDesigner() {
    return {
      'username': widget.designerName,
      'profileImage': widget.imageAsset,
      'messages': <Map<String, dynamic>>[], 
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final ThemeData theme = Theme.of(context);

    final double salesNumber =
        double.tryParse(widget.sales.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    final double followersNumber =
        double.tryParse(widget.followers.replaceAll(RegExp(r'[^0-9.]'), '')) ??
        0.0;

    final Map<String, double> stats = {
      'penjualan': salesNumber,
      'pengikut': followersNumber,
      'mengikuti': 0.0,
    };

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.designerName.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: theme.textTheme.displayLarge!.fontSize,
            color: theme.textTheme.displayLarge!.color,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(widget.imageAsset),
                        radius: 40,
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.designerName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: theme.textTheme.bodyMedium!.fontSize,
                                color: theme.textTheme.bodyMedium!.color,
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                ...stats.entries
                                    .expand<Widget>(
                                      (entry) => [
                                        Column(
                                          children: [
                                            Text(
                                              entry.value.toStringAsFixed(0),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    theme
                                                        .textTheme
                                                        .bodyMedium!
                                                        .fontSize,
                                                color:
                                                    theme
                                                        .textTheme
                                                        .bodyMedium!
                                                        .color,
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
                                    )
                                    .toList()
                                  ..removeLast(),
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
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_isFollowing) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Berhenti mengikuti?'),
                                    content: Text(
                                      'Apakah Anda yakin ingin berhenti mengikuti ${widget.designerName}?',
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                          'Batal',
                                          style: TextStyle(
                                            color:
                                                theme
                                                    .textTheme
                                                    .bodyMedium!
                                                    .color,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Ya',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isFollowing = false;
                                          });
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Anda berhenti mengikuti ${widget.designerName}',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              setState(() {
                                _isFollowing = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Anda mengikuti ${widget.designerName}',
                                  ),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            _isFollowing ? Icons.check : Icons.person_add_alt_1,
                          ),
                          label: Text(_isFollowing ? 'Diikuti' : 'Ikuti'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _isFollowing
                                    ? theme.cardColor
                                    : theme.primaryColor,
                            foregroundColor:
                                _isFollowing
                                    ? theme.textTheme.bodyMedium!.color
                                    : theme.colorScheme.onPrimary,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side:
                                  _isFollowing
                                      ? BorderSide(color: theme.dividerColor)
                                      : BorderSide.none,
                            ),
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
                                builder:
                                    (context) => ChatDetailPage(
                                      chat: _getChatDataForDesigner(),
                                    ),
                              ),
                            );
                          },
                          icon: Icon(Icons.chat_bubble_outline),
                          label: Text('Pesan'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.primaryColor,
                            side: BorderSide(color: theme.primaryColor),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                    },
                  );
                }),
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Builder(
                builder: (context) {
                  if (selectedTab == 0) {
                    return Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: 60,
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Belum ada postingan dari desainer ini.',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 200),
                        ],
                      ),
                    );
                  } else if (selectedTab == 1) {
                    return sections[selectedTab]['page'];
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
