import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _workoutReminders = true;
  bool _eventUpdates = true;
  bool _promoNews = false;
  bool _communityAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text("Notifikasi",
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSwitchTile(
              "Pengingat Latihan",
              "Notifikasi jadwal lari harianmu",
              _workoutReminders,
              (val) => setState(() => _workoutReminders = val)),
          const Divider(),
          _buildSwitchTile(
              "Update Event",
              "Info terbaru tentang event yang diikuti",
              _eventUpdates,
              (val) => setState(() => _eventUpdates = val)),
          const Divider(),
          _buildSwitchTile(
              "Promo & Berita",
              "Penawaran spesial dan artikel lari",
              _promoNews,
              (val) => setState(() => _promoNews = val)),
          const Divider(),
          _buildSwitchTile(
              "Komunitas",
              "Saat ada yang menyukai atau komentar",
              _communityAlerts,
              (val) => setState(() => _communityAlerts = val)),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
      String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      activeThumbColor: Colors.deepOrange,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      value: value,
      onChanged: onChanged,
    );
  }
}
