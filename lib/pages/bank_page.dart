import 'package:flutter/material.dart';
import 'payment_page.dart';
import '../components/bank_option_component.dart';

class BankPage extends StatefulWidget {
  final int amount;

  const BankPage({
    super.key,
    required this.amount,
  });

  @override
  State<BankPage> createState() => _BankPageState();
}

class _BankPageState extends State<BankPage> {
  String selectedPayment = '';

  final List<Map<String, dynamic>> payments = [
    {
      'name': 'Transfer Bank',
      'icon': '🏦',
      'description': 'Mandiri, BCA, BNI, dan lainnya',
      'options': [
        {'name': 'BCA Mobile', 'icon': 'images/bca.png', 'url': 'https://www.bca.co.id'},
        {'name': 'BNI M-Banking', 'icon': 'images/bni.png', 'url': 'https://www.bni.co.id'},
        {'name': 'BRI Mobile', 'icon': 'images/bri.png', 'url': 'https://www.bri.co.id'},
        {'name': 'Mandiri', 'icon': 'images/mandiri.png', 'url': 'https://www.bankmandiri.co.id'},
      ],
    },
    {
      'name': 'E-Wallet',
      'icon': '📱',
      'description': 'OVO, DANA, ShopeePay',
      'options': [
        {'name': 'OVO', 'icon': 'images/ovo.png', 'url': 'https://www.ovo.id'},
        {'name': 'Dana', 'icon': 'images/dana.png', 'url': 'https://www.dana.id'},
        {'name': 'Shopee Pay', 'icon': 'images/shopeepay.png', 'url': 'https://shopee.co.id'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'PEMBAYARAN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: theme.textTheme.displayLarge!.fontSize,
            color: theme.textTheme.displayLarge!.color,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              itemCount: payments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final Map<String, dynamic> method = payments[index];
                final isSelected = selectedPayment == method['name'];

                return BankOption(
                  isSelected: isSelected,
                  icon: method['icon'],
                  name: method['name'],
                  description: method['description'],
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedPayment = '';
                      } else {
                        selectedPayment = method['name']!;
                      }
                    });
                  },
                );
              },
            ),
          ),
          if (selectedPayment.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  final Map<String, dynamic> selected = payments.firstWhere((e) => e['name'] == selectedPayment);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PaymentPage(
                      amount: widget.amount,
                      options: selected['options'],
                    )),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: theme.textTheme.headlineSmall!.color,
                  foregroundColor: theme.textTheme.displaySmall!.color,
                  textStyle: theme.textTheme.displayMedium,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Lanjutkan'),
              ),
          ),
        ],
      ),
    );
  }
}
