// lib/screens/detail_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:runners_hub/screens/settings_screen.dart';
import 'package:runners_hub/screens/login_screen.dart';
import 'package:runners_hub/screens/register_screen.dart';
import 'package:runners_hub/services/auth_service.dart';

class DetailProfileScreen extends StatefulWidget {
  const DetailProfileScreen({Key? key}) : super(key: key);

  @override
  _DetailProfileScreenState createState() => _DetailProfileScreenState();
}

class _DetailProfileScreenState extends State<DetailProfileScreen> {
  // State variables
  bool _isLoading = true;
  bool _isLoggedIn = false;

  // Data Pengguna
  String fullName = "Runner User";
  String email = "runner@example.com";
  String weight = "65";
  String height = "172";
  String age = "24";

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check login status and load user data
  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (isLoggedIn) {
      final name = await AuthService.getUserName();
      final userEmail = await AuthService.getUserEmail();
      setState(() {
        _isLoggedIn = true;
        fullName = name;
        email = userEmail;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk refresh halaman saat kembali dari login
  void _refresh() {
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.deepOrange),
        ),
      );
    }

    return _isLoggedIn
        ? _buildUserProfile() // Tampilan SUDAH Login
        : _buildGuestView(); // Tampilan BELUM Login
  }

  // ==========================================
  // TAMPILAN 1: BELUM LOGIN (GUEST VIEW)
  // ==========================================
  Widget _buildGuestView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Profil",
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle_outlined,
                  size: 80, color: Colors.grey[400]),
              const SizedBox(height: 24),
              const Text("Masuk ke Akunmu",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(
                  "Login untuk melihat progres latihan, data profil, dan riwayat event kamu.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()))
                        .then((_) => _refresh());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text("LOGIN",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()))
                        .then((_) => _refresh());
                  },
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.deepOrange),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text("DAFTAR AKUN BARU",
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // TAMPILAN 2: SUDAH LOGIN (PROFIL + PORTOFOLIO)
  // ==========================================================
  Widget _buildUserProfile() {
    return DefaultTabController(
      length: 4, // 1 Tab tambahan untuk Manajemen Sepatu
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: true,
                // --- PERBAIKAN 1: Tinggi diperbesar agar muat ---
                expandedHeight: 450.0,
                // -----------------------------------------------
                iconTheme: const IconThemeData(color: Colors.black87),
                title: innerBoxIsScrolled
                    ? const Text('Profil',
                        style: TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.bold))
                    : null,
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings_outlined,
                        color: Colors.black87),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsScreen()));
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: _buildProfileHeaderContent(context),
                ),
                bottom: const TabBar(
                  isScrollable: true, // Agar muat untuk 4 tab di layar kecil
                  indicatorColor: Colors.deepOrange,
                  labelColor: Colors.deepOrange,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'Statistik', icon: Icon(Icons.show_chart)),
                    Tab(text: 'Log Lari', icon: Icon(Icons.history)),
                    Tab(text: 'Galeri', icon: Icon(Icons.photo_library)),
                    Tab(text: 'Sepatu', icon: Icon(Icons.run_circle_outlined)),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildStatistikTab(),
              _buildLogLariTab(context),
              _buildGaleriPbTab(context),
              _buildPeralatanTab(context), // Tab Baru
            ],
          ),
        ),
      ),
    );
  }

  // Isi Header Profil
  Widget _buildProfileHeaderContent(BuildContext context) {
    return Container(
      // --- PERBAIKAN 2: Padding Bawah ditambah (80) agar tidak tertutup TabBar ---
      padding: const EdgeInsets.fromLTRB(20, 80, 20, 80),
      // --------------------------------------------------------------------------
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Foto & Nama
          Column(
            children: [
              Hero(
                tag: 'profile-avatar-hero',
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.deepOrange, width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80"),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(fullName,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              const SizedBox(height: 4),
              Text(email,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 24),

          // Statistik Fisik (Kartu)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5))
              ],
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem("Tinggi", "$height cm"),
                Container(height: 30, width: 1, color: Colors.grey[200]),
                _buildStatItem("Berat", "$weight kg"),
                Container(height: 30, width: 1, color: Colors.grey[200]),
                _buildStatItem("Umur", "$age th"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.black87)),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  // =========================================================
  // WIDGET TAB 1: STATISTIK REKAP
  // =========================================================
  Widget _buildStatistikTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Pencapaian',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: _buildRunStatItem(
                            '356', 'km', 'Total Jarak', Icons.trending_up)),
                    Expanded(
                        child: _buildRunStatItem(
                            '85', 'kali', 'Total Lari', Icons.directions_run)),
                    Expanded(
                        child: _buildRunStatItem(
                            '120', 'jam', 'Total Durasi', Icons.timer)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Progres Bulanan',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 12),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart_rounded,
                      size: 48, color: Colors.grey[300]),
                  const SizedBox(height: 8),
                  Text("Grafik Progres Akan Muncul Disini",
                      style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRunStatItem(
      String value, String unit, String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.deepOrange, size: 20),
        ),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.black87)),
        Text(unit,
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey[400])),
      ],
    );
  }

  // =========================================================
  // WIDGET TAB 2: LOG LARI HARIAN
  // =========================================================
  Widget _buildLogLariTab(BuildContext context) {
    final List<Map<String, String>> runs = [
      {
        'date': '15 Nov 2025',
        'distance': '5.0 km',
        'time': '30:45',
        'pace': '6:09 /km',
        'status': 'Selesai'
      },
      {
        'date': '12 Nov 2025',
        'distance': '10.2 km',
        'time': '1:05:10',
        'pace': '6:23 /km',
        'status': 'Selesai'
      },
      {
        'date': '08 Nov 2025',
        'distance': '3.0 km',
        'time': '18:00',
        'pace': '6:00 /km',
        'status': 'Selesai'
      },
      {
        'date': '05 Nov 2025',
        'distance': '21.1 km',
        'time': '2:15:30',
        'pace': '6:24 /km',
        'status': 'Race'
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: runs.length,
      itemBuilder: (context, index) {
        final run = runs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2))
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: run['status'] == 'Race'
                    ? Colors.amber.withOpacity(0.1)
                    : Colors.deepOrange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.directions_run,
                  color: run['status'] == 'Race'
                      ? Colors.amber[700]
                      : Colors.deepOrange),
            ),
            title: Text('${run['distance']}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(run['date']!,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.timer_outlined,
                        size: 12, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text('${run['time']}  •  ${run['pace']}',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
        );
      },
    );
  }

  // =========================================================
  // WIDGET TAB 3: GALERI FOTO & PB
  // =========================================================
  Widget _buildGaleriPbTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🏅 Personal Best (PB)',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 16),
          _buildPersonalBestCard('5K', '25:00', 'Runner Fest 2025'),
          _buildPersonalBestCard('10K', '53:15', 'Jakarta Marathon 2024'),
          _buildPersonalBestCard(
              'Half Marathon', '2:01:45', 'Borobudur Marathon 2025'),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('📷 Galeri Foto',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              TextButton.icon(
                onPressed: () => _showUploadPhotoDialog(context),
                icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                label: const Text('Upload'),
                style: TextButton.styleFrom(foregroundColor: Colors.deepOrange),
              )
            ],
          ),
          const SizedBox(height: 12),
          _buildPhotoGrid(),
        ],
      ),
    );
  }

  Widget _buildPersonalBestCard(String distance, String time, String event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.emoji_events_rounded,
                color: Colors.amber, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$distance - $time',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(event,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid() {
    final List<String> imageUrls = [
      'https://picsum.photos/id/237/200/200',
      'https://picsum.photos/id/10/200/200',
      'https://picsum.photos/id/35/200/200',
      'https://picsum.photos/id/100/200/200',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            imageUrls[index],
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                  color: Colors.grey[100],
                  child: const Center(
                      child:
                          CircularProgressIndicator(color: Colors.deepOrange)));
            },
            errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[100],
                child: const Icon(Icons.broken_image_outlined,
                    color: Colors.grey)),
          ),
        );
      },
    );
  }

  void _showUploadPhotoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Upload Foto Lari'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded,
                  color: Colors.deepOrange),
              title: const Text('Ambil dari Kamera'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kamera dibuka (Simulasi)')));
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library_rounded, color: Colors.blue),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Galeri dibuka (Simulasi)')));
              },
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // WIDGET TAB 4: PERALATAN / SEPATU
  // =========================================================
  Widget _buildPeralatanTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Koleksi Sepatu Lari',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              TextButton.icon(
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Buka form Tambah Sepatu Baru...')));
                },
                icon: const Icon(Icons.add_circle_outline, size: 18),
                label: const Text('Tambah'),
                style: TextButton.styleFrom(foregroundColor: Colors.deepOrange),
              )
            ],
          ),
          const SizedBox(height: 16),
          // Sepatu 1 (Aktif)
          _buildShoeItemCard(
              name: 'Nike Air Zoom Pegasus 40',
              type: 'Daily Trainer',
              mileage: 350.5,
              maxMileage: 500.0,
              isActive: true),
          const SizedBox(height: 12),
          // Sepatu 2 (Warning)
          _buildShoeItemCard(
              name: 'Adidas Adizero Boston 12',
              type: 'Speed/Tempo',
              mileage: 512.0,
              maxMileage: 400.0,
              isActive: false),
          const SizedBox(height: 24),
          // Keterangan Integrasi BI
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.blue[800], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Sistem Business Intelligence kami menghitung usia keausan busa (midsole) sepatu Anda berdasarkan ambang batas jarak yang telah mempertimbangkan berat badan Anda ($weight kg).',
                    style: TextStyle(fontSize: 12, color: Colors.blue[900], height: 1.4),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildShoeItemCard({
    required String name,
    required String type,
    required double mileage,
    required double maxMileage,
    required bool isActive,
  }) {
    double progress = mileage / maxMileage;
    bool isWarning = progress >= 1.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isActive ? Colors.deepOrange.withOpacity(0.5) : Colors.grey.shade200,
            width: isActive ? 2 : 1),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('DIPAKAI (AKTIF)',
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold)),
                )
            ],
          ),
          const SizedBox(height: 4),
          Text(type, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kondisi Sol/Busa',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text('${mileage.toStringAsFixed(1)} / ${maxMileage.toInt()} km',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isWarning ? Colors.red : Colors.black87)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(
                isWarning ? Colors.red : (progress > 0.8 ? Colors.orange : Colors.green),
              ),
            ),
          ),
          if (isWarning) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 14),
                const SizedBox(width: 4),
                Text('Sepatu ini berisiko mencederai kaki Anda jika dipakai lari.',
                    style: TextStyle(color: Colors.red[700], fontSize: 11)),
              ],
            )
          ]
        ],
      ),
    );
  }
} // Tutup class state
