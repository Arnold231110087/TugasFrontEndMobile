import 'package:flutter/material.dart';

class PaymentSuccessPage extends StatefulWidget {
  const PaymentSuccessPage({super.key});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool showCheck = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

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
    Navigator.of(context)..pop()..pop()..pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.appBarTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showCheck)
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.textTheme.displaySmall!.color,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 60,
                    color: theme.appBarTheme.backgroundColor,
                  ),
                ),
              ),
            const SizedBox(height: 32),
            Text(
              'Pembayaran Berhasil',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: theme.textTheme.displayLarge!.fontSize,
                color: theme.textTheme.displayLarge!.color,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: finish,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.textTheme.displaySmall!.color,
                foregroundColor: theme.appBarTheme.backgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'Selesai',
                style: TextStyle(fontSize: theme.textTheme.bodyMedium!.fontSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}