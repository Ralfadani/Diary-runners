// lib/screens/notification_screen.dart

import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Dummy Data Notifikasi
  final List<Map<String, dynamic>> _notifications = [
    {
      "id": "1",
      "title": "Jadwal Lari Hari Ini",
      "body": "Jangan lupa jadwal lari 5km sore ini pukul 16:30.",
      "time": "2 Jam yang lalu",
      "type": "reminder", // reminder, promo, system
      "isRead": false,
    },
    {
      "id": "2",
      "title": "Selamat! Target Tercapai",
      "body": "Kamu berhasil mencapai target mingguan 20km. Pertahankan!",
      "time": "1 Hari yang lalu",
      "type": "system",
      "isRead": true,
    },
    {
      "id": "3",
      "title": "Promo Sepatu Lari 50%",
      "body": "Diskon spesial untuk member premium di toko mitra kami.",
      "time": "2 Hari yang lalu",
      "type": "promo",
      "isRead": true,
    },
    {
      "id": "4",
      "title": "Versi Baru Tersedia",
      "body": "Update aplikasi sekarang untuk fitur tracking yang lebih akurat.",
      "time": "3 Hari yang lalu",
      "type": "system",
      "isRead": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Notifikasi",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in _notifications) {
                  n['isRead'] = true;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Semua ditandai sudah dibaca")),
              );
            },
            child: const Text("Baca Semua", style: TextStyle(color: Colors.deepOrange)),
          )
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final item = _notifications[index];
                return _buildNotificationItem(item);
              },
            ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> item) {
    IconData icon;
    Color color;

    // Tentukan Icon berdasarkan tipe
    switch (item['type']) {
      case 'reminder':
        icon = Icons.alarm;
        color = Colors.orange;
        break;
      case 'promo':
        icon = Icons.local_offer;
        color = Colors.purple;
        break;
      default:
        icon = Icons.info;
        color = Colors.blue;
    }

    return Dismissible(
      key: Key(item['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          _notifications.removeWhere((element) => element['id'] == item['id']);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item['isRead'] ? Colors.white : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
          border: item['isRead'] 
              ? Border.all(color: Colors.transparent)
              : Border.all(color: Colors.deepOrange.withOpacity(0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['title'],
                          style: TextStyle(
                            fontWeight: item['isRead'] ? FontWeight.w600 : FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!item['isRead'])
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.deepOrange,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['body'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['time'],
                    style: TextStyle(color: Colors.grey[400], fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("Tidak ada notifikasi", style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }
}