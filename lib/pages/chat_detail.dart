import 'package:flutter/material.dart';

class ChatDetailPage extends StatelessWidget {
  final String name;
  final Color primaryColor = const Color(0xFF1E3A8A);

  const ChatDetailPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final isKevin = name == "Kevin Durant";
    final avatarAsset = isKevin ? 'images/profile3.png' : 'images/profile5.png';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3FF),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(avatarAsset),
              radius: 16,
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              // Tambahkan aksi sesuai pilihan
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
                  leading:
                      const Icon(Icons.notifications_off, color: Colors.black54),
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
          _buildInputBar(context),
        ],
      ),
    );
  }

  Widget _buildMessages(bool isKevin, String avatarAsset) {
    if (isKevin) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _bubble('Saya ingin sebuah logo yang unik', false, avatarAsset),
          _bubble('Boleh kang, ingin logo seperti apa?', true, avatarAsset),
          _bubble('Logo yang unik untuk team esport...', false, avatarAsset),
          _bubble('Sip, untuk harganya 350 rb ya...', true, avatarAsset),
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

  Widget _bubble(String text, bool isSender, String avatarAsset) {
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSender) ...[
          CircleAvatar(
            backgroundImage: AssetImage(avatarAsset),
            radius: 16,
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSender ? const Color(0xFF4F6CD9) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              text,
              style:
                  TextStyle(color: isSender ? Colors.white : Colors.black87),
            ),
          ),
        ),
      ],
    );
  }

  Widget _transactionBox() {
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
              const SizedBox(width: 8),
              Expanded(
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
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      color: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.price_change, color: Colors.white),
            onPressed: () {
              _showTransactionModal(context);
            },
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

  void _showTransactionModal(BuildContext context) {
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
              // Proses harga di controller.text
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Ajukan'),
          ),
        ],
      ),
    );
  }
}
