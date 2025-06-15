import 'package:flutter/material.dart';
import '../components/account_status_component.dart';
import '../components/delete_account_component.dart';

class AccountStatusPage extends StatelessWidget {
  const AccountStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Status Akun"),
        backgroundColor: theme.colorScheme.background,
        foregroundColor: theme.textTheme.bodyLarge?.color,
      ),
      backgroundColor: theme.colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            AccountStatusInfo(
              joinDate: 'Bergabung sejak: 12 Januari 2023',
              linkedAccount: 'Email: user@example.com',
            ),
            SizedBox(height: 32),
            DeleteAccountSection(),
          ],
        ),
      ),
    );
  }
}
