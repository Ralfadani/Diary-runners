// lib/screens/more_screen.dart

import 'package:flutter/material.dart';
import 'package:runners_hub/screens/detail_profile_screen.dart';
import 'package:runners_hub/screens/outfit_screen.dart';
import 'package:runners_hub/screens/routes_screen.dart';
import 'package:runners_hub/screens/event_screen.dart';
import 'package:runners_hub/screens/settings_screen.dart';
import 'package:runners_hub/services/auth_service.dart';
import 'package:runners_hub/screens/welcome_screen.dart';
import 'package:runners_hub/screens/analytics_detail_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Menu Lainnya",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          // --- [BARU] SECTION PROFIL ---
          _buildProfileHeader(context),
          const SizedBox(height: 24),

          // --- GROUP 1: LATIHAN ---
          _buildSectionHeader("Latihan & Aktivitas"),
          _buildSectionContainer([
            _buildListTile(
              context,
              icon: Icons.map_outlined,
              color: Colors.purple,
              title: "Jelajah Rute Lari",
              subtitle: "Cari trek lari di sekitarmu",
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RoutesScreen())),
            ),
            _buildDivider(),
            _buildListTile(
              context,
              icon: Icons.emoji_events_rounded,
              color: Colors.orange,
              title: "Acara & Kompetisi",
              subtitle: "Daftar event lari terbaru",
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EventScreen())),
            ),
            _buildDivider(),
            _buildListTile(
              context,
              icon: Icons.analytics_rounded,
              color: Colors.blueAccent,
              title: "Business Intelligence",
              subtitle: "Detail analitik & rekomendasi",
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AnalyticsDetailScreen())),
            ),
          ]),

          const SizedBox(height: 24),

          // --- GROUP 2: GEAR ---
          _buildSectionHeader("Gear & Perangkat"),
          _buildSectionContainer([
            _buildListTile(
              context,
              icon: Icons.checkroom_rounded,
              color: Colors.teal,
              title: "Perlengkapan Lari",
              subtitle: "Kelola sepatu & pakaian",
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OutfitScreen())),
            ),
            _buildDivider(),
            _buildListTile(
              context,
              icon: Icons.watch_rounded,
              color: Colors.black87,
              title: "Hubungkan Smartwatch",
              subtitle: "Garmin, Strava, Apple Watch",
              onTap: () => _showConnectDialog(context),
            ),
          ]),

          const SizedBox(height: 24),

          // --- GROUP 3: SISTEM & INFO ---
          _buildSectionHeader("Sistem & Info"),
          _buildSectionContainer([
            _buildListTile(
              context,
              icon: Icons.settings_rounded,
              color: Colors.grey,
              title: "Pengaturan",
              subtitle: "Notifikasi, Bahasa, Privasi",
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen())),
            ),
            _buildDivider(),
            _buildListTile(
              context,
              icon: Icons.info_outline_rounded,
              color: Colors.blueGrey,
              title: "Tentang Aplikasi",
              subtitle: "Versi, Info Developer",
              onTap: () => _showAboutDialog(context),
            ),
            _buildDivider(),
            _buildListTile(
              context,
              icon: Icons.logout_rounded,
              color: Colors.redAccent,
              title: "Keluar",
              onTap: () async {
                // Tampilkan dialog konfirmasi
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: const Text('Keluar dari Akun?'),
                    content: const Text(
                      'Anda yakin ingin keluar dari akun ini?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Batal'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Keluar'),
                      ),
                    ],
                  ),
                );

                // Jika user konfirmasi logout
                if (shouldLogout == true) {
                  await AuthService.logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                      (route) => false,
                    );
                  }
                }
              },
            ),
          ]),

          const SizedBox(height: 40),

          const Center(
              child: Text("Diary Runners v1.0.0",
                  style: TextStyle(color: Colors.grey, fontSize: 12))),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // =========================================
  // [BARU] WIDGET PROFIL HEADER
  // =========================================
  Widget _buildProfileHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke Profile Screen
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DetailProfileScreen()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Foto Profil
            Hero(
              tag:
                  'profile-avatar-hero-more', // Tag unik agar tidak konflik hero
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.deepOrange.withOpacity(0.5), width: 2),
                ),
                child: const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.orangeAccent,
                  // Jika ada foto: backgroundImage: NetworkImage('...'),
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Info User
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Runner User",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Lihat Profil & Pencapaian",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Tombol Panah
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.chevron_right, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }

  // --- LOGIKA POPUP ABOUT ---
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.directions_run, color: Colors.deepOrange),
              SizedBox(width: 8),
              Text("Diary Runners"),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Versi 1.0.0 (Beta)",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                  "Aplikasi teman lari terbaikmu. Dibuat dengan ❤️ menggunakan Flutter."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup",
                  style: TextStyle(color: Colors.deepOrange)),
            ),
          ],
        );
      },
    );
  }

  // --- LOGIKA POPUP SMARTWATCH ---
  void _showConnectDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Pilih Perangkat",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildDeviceItem(Icons.watch, "Garmin Connect", Colors.blue),
              const SizedBox(height: 16),
              _buildDeviceItem(Icons.directions_run, "Strava", Colors.orange),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeviceItem(IconData icon, String name, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          const Text("Connect",
              style: TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ],
      ),
    );
  }

  // --- WIDGET UI HELPERS ---
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8),
      child: Text(title.toUpperCase(),
          style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5)),
    );
  }

  Widget _buildSectionContainer(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2))
          ]),
      child: Column(children: children),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required Color color,
      required String title,
      String? subtitle,
      required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 22)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                    if (subtitle != null)
                      Text(subtitle,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.grey[300], size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
        height: 1, thickness: 1, color: Colors.grey[100], indent: 68);
  }
}
