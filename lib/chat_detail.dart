import 'package:flutter/material.dart';
import 'payment_page.dart'; // Pastikan file ini dibuat

class ChatDetailPage extends StatefulWidget {
  final String name;

  const ChatDetailPage({
    super.key,
    required this.name
  });

  @override
  State < ChatDetailPage > createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State < ChatDetailPage > {
  final Color primaryColor =
  const Color(0xFF1E3A8A);
  bool showRejection = false;

  void _showTransactionModal() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Container(
          padding: const EdgeInsets.all(12),
            color: primaryColor,
            child: const Text('Ajukan Transaksi',
              style: TextStyle(color: Colors.white)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Harga'),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixText: 'Rp ',
                  hintText: 'Masukkan harga',
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Simpan transaksi di controller.text
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Ajukan'),
          ),
        ],
      ),
    );
  }

  Widget _bubble(String text, bool isSender, String avatarAsset) {
    return Row(
      mainAxisAlignment:
      isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSender)...[
            CircleAvatar(backgroundImage: AssetImage(avatarAsset), radius: 16),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSender ?
                    const Color(0xFF4F6CD9): Colors.white,
                      borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isSender ? Colors.white : Colors.black87),
                  ),
            ),
          ),
      ],
    );
  }

  Widget _transactionBox() {
    if (showRejection) {
      return Container(
        padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text.rich(
              TextSpan(
                text: 'Anda telah ',
                style: TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: 'menolak ',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: 'transaksi dari '),
                  TextSpan(
                    text: 'Kevin Durant ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: 'dengan nominal '),
                  TextSpan(
                    text: 'Rp 350.000,00',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0C1F4B),
              borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  text: 'Kevin Durant ',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  children: [
                    TextSpan(
                      text: 'telah mengajukan sebuah transaksi dengan nominal ',
                    ),
                    TextSpan(
                      text: 'Rp 350.000,00',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showRejection = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child:
                            const Text('Tolak', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) =>
                                const PaymentPage()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: const Text('Terima',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                  ],
                )
            ],
          ),
    );
  }

  Widget _buildMessages(bool isKevin, String avatarAsset) {
    if (isKevin) {
      return ListView(
        padding: const EdgeInsets.all(16),
          children: [
            _bubble('Saya ingin sebuah logo yang unik', true, avatarAsset),
            _bubble('Boleh kang, ingin logo seperti apa?', false, avatarAsset),
            _bubble('Logo yang unik untuk team esport...', true, avatarAsset),
            _bubble('Sip, untuk harganya 350 rb ya...', false, avatarAsset),
            _transactionBox(),
          ],
      );
    } else {
      return ListView(
        padding: const EdgeInsets.all(16),
          children: [
            _bubble('Halo mas, saya ingin request logo bisa?', false, avatarAsset),
            _bubble('Bisa atuh kang. Ingin logo seperti apa?', true, avatarAsset),
            _bubble('Silahkan ditulis saja semua aspek...', true, avatarAsset),
            _bubble('Saya ingin logo dengan elemen hijau...', false, avatarAsset),
          ],
      );
    }
  }

  Widget _buildInputBar() {
    return Container(
      color: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.price_change, color: Colors.white),
                onPressed: _showTransactionModal,
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
                onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.mic, color: Colors.white),
                onPressed: () {},
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Ketik obrolan',
                        border: InputBorder.none,
                      ),
                    ),
              ),
            ),
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isKevin = widget.name == "Kevin Durant";
    final avatarAsset = isKevin ? 'images/profile3.png' : 'images/profile5.png';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3FF),
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage(avatarAsset), radius: 16),
              const SizedBox(width: 8),
                Text(widget.name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
          ),
          actions: [
            PopupMenuButton < String > (
              icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  // Tambah aksi jika perlu
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'hapus',
                    child: ListTile(
                      leading: const Icon(Icons.delete, color: Colors.black54),
                        title: const Text('Hapus obrolan'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'senyap',
                    child: ListTile(
                      leading: const Icon(Icons.notifications_off, color: Colors.black54),
                        title: const Text('Mode senyap'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'blokir',
                    child: ListTile(
                      leading: const Icon(Icons.block, color: Colors.black54),
                        title: const Text('Blokir pengguna'),
                    ),
                  ),
                ],
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: _buildMessages(isKevin, avatarAsset)),
            _buildInputBar(),
          ],
        ),
    );
  }
}