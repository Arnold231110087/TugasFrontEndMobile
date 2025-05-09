import 'package:flutter/material.dart';
import '../utils/rupiah_format.dart';
import '../components/payment_option.dart';

class PaymentPage extends StatefulWidget {
  final List<Map<String, String>> options;
  final int amount;

  const PaymentPage({
    super.key,
    required this.options,
    required this.amount,
  });

  @override
  State<PaymentPage> createState() => _BankPageState();
}

class _BankPageState extends State<PaymentPage> {
  String selectedPayment = '';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Map<String, String>> options = widget.options;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'METODE PEMBAYARAN',
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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: ListView(
                children: [
                  Text(
                    rupiahFormat(widget.amount),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: theme.textTheme.headlineLarge!.color,
                    ),
                  ),
                  SizedBox(height: 32),
                  ...options.expand<Widget>((option) => [
                    PaymentOption(
                      isSelected: option['name'] == selectedPayment,
                      name: option['name']!,
                      icon: option['icon']!,
                      url: option['url']!,
                      onTap: () {
                        setState(() {
                          if (option['name'] == selectedPayment) {
                            selectedPayment = '';
                          } else {
                            selectedPayment = option['name']!;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                  ]).toList()..removeLast(),
                ],
              ),
            ),
          ),
          if (selectedPayment.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => PaymentDetailPage(category: selected['category']!)),
                  // );
                },
                style: TextButton.styleFrom(
                  backgroundColor: theme.textTheme.headlineSmall!.color,
                  foregroundColor: theme.textTheme.displaySmall!.color,
                  textStyle: theme.textTheme.displayMedium,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Bayar'),
              ),
          ),
        ],
      ),
    );
  }
}
