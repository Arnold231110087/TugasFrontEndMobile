import 'package:flutter/material.dart';

class AccountStatusInfo extends StatelessWidget {
  final String joinDate;
  final String linkedAccount;

  const AccountStatusInfo({
      super.key,
      required this.joinDate,
      required this.linkedAccount,
    }

  );

  @override Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text("Informasi Akun", style: TextStyle(fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ), ),
        const SizedBox(height: 12),
          Text(joinDate, style: TextStyle(fontSize: 14,
            height: 1.5,
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ), ),
          const SizedBox(height: 8),
            Text(linkedAccount, style: TextStyle(fontSize: 14,
              height: 1.5,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ), ),
      ],
    );
  }
}