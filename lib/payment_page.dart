import 'package:flutter/material.dart';
import 'payment_detail_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedMethod = '';

  final List<Map<String, String>> paymentMethods = [
    {
      'name': 'Transfer Bank',
      'description': 'Mandiri, BCA, BNI, dan lainnya',
      'icon': '🏦',
      'category': 'bank',
    },
    {
      'name': 'E-Wallet',
      'description': 'OVO, DANA, ShopeePay',
      'icon': '📱',
      'category': 'ewallet',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metode Pembayaran'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: paymentMethods.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final method = paymentMethods[index];
                final isSelected = selectedMethod == method['name'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMethod = method['name']!;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1E3A8A) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(method['icon']!, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method['name']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                method['description']!,
                                style: TextStyle(
                                  color: isSelected ? Colors.white70 : Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isSelected ? Icons.check_circle : Icons.radio_button_off,
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedMethod.isNotEmpty
                  ? () {
                      final selected = paymentMethods.firstWhere(
                        (e) => e['name'] == selectedMethod,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentDetailPage(category: selected['category']!),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Lanjutkan',
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
