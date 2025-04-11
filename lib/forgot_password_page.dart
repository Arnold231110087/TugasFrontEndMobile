import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lupa Password")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Masukkan email untuk mereset password:"),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Link Dikirim"),
                    content: Text("Link reset password telah dikirim ke email kamu."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
                        child: Text("OK"),
                      )
                    ],
                  ),
                );
              },
              child: Text("Kirim Link Reset"),
            ),
          ],
        ),
      ),
    );
  }
}
