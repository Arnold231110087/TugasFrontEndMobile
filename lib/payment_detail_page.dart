import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentDetailPage extends StatefulWidget {
  final String category;

  const PaymentDetailPage({Key? key, required this.category}) : super(key: key);

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  String? selectedMethod;

  final List<Map<String, String>> paymentOptions = [
    {'name': 'BCA Mobile', 'category': 'bank', 'icon': 'images/bca.png', 'url': 'https://www.bca.co.id'},
    {'name': 'BNI M-Banking', 'category': 'bank', 'icon': 'images/bni.png', 'url': 'https://www.bni.co.id'},
    {'name': 'BRI Mobile', 'category': 'bank', 'icon': 'images/bri.png', 'url': 'https://www.bri.co.id'},
    {'name': 'Mandiri', 'category': 'bank', 'icon': 'images/mandiri.png', 'url': 'https://www.bankmandiri.co.id'},
    {'name': 'OVO', 'category': 'ewallet', 'icon': 'images/ovo.png', 'url': 'https://www.ovo.id'},
    {'name': 'Dana', 'category': 'ewallet', 'icon': 'images/dana.png', 'url': 'https://www.dana.id'},
    {'name': 'Shopee Pay', 'category': 'ewallet', 'icon': 'images/shopeepay.png', 'url': 'https://shopee.co.id'},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = paymentOptions
        .where((option) => option['category'] == widget.category)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        title: const Text('Halaman Pembayaran'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rp 350.000,00",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A))),
                  SizedBox(height: 8),
                  Divider(),
                  Text("Metode pembayaran",
                      style: TextStyle(
                          fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...filtered.map((method) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMethod = method['name'];
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: selectedMethod == method['name']
                          ? const Color(0xFF1E3A8A)
                          : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(method['icon']!, width: 40),
                      const SizedBox(width: 12),
                      Expanded(child: Text(method['name']!)),
                      Icon(
                        selectedMethod == method['name']
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: selectedMethod == method['name']
                            ? const Color(0xFF1E3A8A)
                            : Colors.grey,
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: selectedMethod == null
                  ? null
                  : () async {
                      final method = paymentOptions.firstWhere(
                          (e) => e['name'] == selectedMethod);
                      final url = method['url'];
                      if (await canLaunchUrl(Uri.parse(url!))) {
                        await launchUrl(Uri.parse(url));
                      }
                      // Setelah kembali, arahkan ke halaman sukses
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PaymentSuccessPage()),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Bayar", style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}

class PaymentSuccessPage extends StatefulWidget {
  const PaymentSuccessPage({Key? key}) : super(key: key);

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool showCheck = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.2)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        showCheck = true;
      });
      _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void finish() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showCheck)
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Icon(
                    Icons.check,
                    size: 60,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            const Text(
              'Pembayaran Berhasil!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: finish,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1E3A8A),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Selesai'), 
            )
          ],
        ),
      ),
    );
  }
}
