// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:runners_hub/screens/edit_profile_screen.dart';
import 'package:runners_hub/screens/security_screen.dart';
import 'package:runners_hub/screens/physical_data_screen.dart';
import 'package:runners_hub/screens/notification_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isSmartwatchConnected = false;
  String? _connectedDeviceName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFFF8F9FD),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION SMARTWATCH ---
            const Text(
              'PERANGKAT',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            _buildSmartwatchCard(),
            const SizedBox(height: 32),

            // --- SECTION AKUN ---
            const Text(
              'AKUN',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Edit Profil',
                    subtitle: 'Nama, Foto, Bio',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProfileScreen()));
                    },
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.lock_outline_rounded,
                    title: 'Keamanan',
                    subtitle: 'Kata sandi & PIN',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SecurityScreen()));
                    },
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.monitor_weight_outlined,
                    title: 'Data Fisik',
                    subtitle: 'Berat, Tinggi, Gender',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PhysicalDataScreen()));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- SECTION APLIKASI ---
            const Text(
              'APLIKASI',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifikasi',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationSettingsScreen()));
                    },
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.language_rounded,
                    title: 'Bahasa',
                    trailingText: 'Indonesia',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Tema',
                    trailingText: 'Terang',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Versi 1.0.0',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildSmartwatchCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: _isSmartwatchConnected
            ? const LinearGradient(
                colors: [
                  Color(0xFF11998e),
                  Color(0xFF38ef7d)
                ], // Green Gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [
                  Color(0xFF2C3E50),
                  Color(0xFF4CA1AF)
                ], // Dark Blue Gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _isSmartwatchConnected
                ? const Color(0xFF38ef7d).withOpacity(0.4)
                : const Color(0xFF2C3E50).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isSmartwatchConnected
                      ? Icons.watch_rounded
                      : Icons.watch_off_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isSmartwatchConnected
                          ? _connectedDeviceName ?? "Smartwatch"
                          : "Belum Terhubung",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isSmartwatchConnected
                          ? "Terhubung & Sinkron"
                          : "Sambungkan untuk melacak detak jantung",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (!_isSmartwatchConnected)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showConnectDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2C3E50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                child: const Text(
                  "SAMBUNGKAN PERANGKAT",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Text("Baterai",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 10)),
                        SizedBox(height: 4),
                        Text("84%",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSmartwatchConnected = false;
                        _connectedDeviceName = null;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: const Column(
                        children: [
                          Text("Status",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 10)),
                          SizedBox(height: 4),
                          Text("Putuskan",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.deepOrange, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          if (trailingText != null) const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade100,
      indent: 70,
      endIndent: 20,
    );
  }

  void _showConnectDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 400,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Pilih Perangkat",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildDeviceItem("Garmin Forerunner 245", Icons.watch),
                  _buildDeviceItem(
                      "Apple Watch Series 8", Icons.watch_outlined),
                  _buildDeviceItem("Mi Band 7", Icons.watch_later_outlined),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceItem(String name, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            _isSmartwatchConnected = true;
            _connectedDeviceName = name;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Terhubung ke $name"),
              backgroundColor: Colors.green,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: const Text("Sambungkan",
            style: TextStyle(fontSize: 12, color: Colors.white)),
      ),
    );
  }
}
