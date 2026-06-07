// lib/screens/detail_activity_screen.dart

import 'package:flutter/material.dart';
import 'package:runners_hub/screens/main_screen.dart'; // Import Main Screen

class DetailActivityScreen extends StatefulWidget {
  const DetailActivityScreen({Key? key}) : super(key: key);

  @override
  _DetailActivityScreenState createState() => _DetailActivityScreenState();
}

class _DetailActivityScreenState extends State<DetailActivityScreen> {
  String? _selectedShoe; // State untuk menyimpan sepatu yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. APP BAR & PETA
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              "Lari Pagi Santai",
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,

            // Tombol Kembali
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.black87, size: 28),
              onPressed: () {
                _navigateBack(context);
              },
            ),

            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.black87),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Membagikan aktivitas...")));
                },
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gambar Peta (Placeholder)
                  Image.network(
                    "https://images.unsplash.com/photo-1524661135-423995f22d0b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80",
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. KONTEN DETAIL
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER INFO ---
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.orangeAccent,
                        child: Icon(Icons.directions_run,
                            color: Colors.white, size: 20),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Rabu, 26 Nov • 06:30",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                          SizedBox(height: 2),
                          Text("Senayan, Jakarta",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- STATISTIK UTAMA (BESAR) ---
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5))
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMainStat("Jarak", "5.02", "km"),
                        _buildVerticalDivider(),
                        _buildMainStat("Waktu", "32:15", "mnt"),
                        _buildVerticalDivider(),
                        _buildMainStat("Pace", "6'25\"", "/km"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- METRIK DETAIL (GRID) ---
                  const Text("Detail Statistik",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildDetailCard(Icons.local_fire_department_rounded,
                          Colors.orange, "Kalori", "345", "kcal"),
                      _buildDetailCard(Icons.favorite_rounded, Colors.red,
                          "Detak Jantung", "142", "bpm"),
                      _buildDetailCard(Icons.height_rounded, Colors.green,
                          "Elevasi", "24", "m"),
                      _buildDetailCard(Icons.timer_rounded, Colors.blue,
                          "Cadence", "165", "spm"),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // --- WIDGET PILIH SEPATU (BI INTEGRATION) ---
                  _buildShoeSelectionCard(),

                  const SizedBox(height: 24),

                  // --- SPLITS (TABEL LAP) ---
                  const Text("Splits",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(
                      height:
                          12), // Jarak text ke tabel juga sedikit dirapatkan
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSplitHeader(),
                        const Divider(height: 1),
                        _buildSplitRow(1, "6'10\"", "+12 m"),
                        const Divider(height: 1),
                        _buildSplitRow(2, "6'15\"", "-5 m"),
                        const Divider(height: 1),
                        _buildSplitRow(3, "6'30\"", "+2 m"),
                        const Divider(height: 1),
                        _buildSplitRow(4, "6'25\"", "0 m"),
                        const Divider(height: 1),
                        _buildSplitRow(5, "6'05\"", "-8 m"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- TOMBOL SELESAI (KEMBALI KE HOME) ---
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        _navigateBack(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 5,
                      ),
                      child: const Text("SELESAI",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET PILIH SEPATU ---
  Widget _buildShoeSelectionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _selectedShoe == null ? Colors.grey.shade300 : Colors.deepOrange.withOpacity(0.5),
          width: _selectedShoe == null ? 1 : 2,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _selectedShoe == null ? Colors.grey.shade100 : Colors.deepOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.run_circle_outlined, 
              color: _selectedShoe == null ? Colors.grey[500] : Colors.deepOrange, 
              size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedShoe == null ? "Catat Sepatu Lari" : "Sepatu Terpilih",
                  style: TextStyle(
                    fontSize: 12, 
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold
                  )
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedShoe ?? "Belum ada sepatu dipilih",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _selectedShoe == null ? Colors.grey[400] : Colors.black87
                  )
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showShoeSelectionBottomSheet(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedShoe == null ? Colors.deepOrange : Colors.grey.shade200,
              foregroundColor: _selectedShoe == null ? Colors.white : Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text(_selectedShoe == null ? "Pilih" : "Ganti", style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showShoeSelectionBottomSheet(BuildContext context) {
    // Data list sepatu sementara
    final List<Map<String, dynamic>> myShoes = [
      {"name": "Nike Air Zoom Pegasus 40", "type": "Daily Trainer", "mileage": 350.5},
      {"name": "Adidas Adizero Boston 12", "type": "Speed/Tempo", "mileage": 512.0},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   const Text(
                     "Pilih Sepatu",
                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                   ),
                   IconButton(
                     icon: const Icon(Icons.close),
                     onPressed: () => Navigator.pop(context),
                   )
                 ],
               ),
               const SizedBox(height: 8),
               Text("Jarak lari (5.02 km) ini akan otomatis ditambahkan ke sistem peringatan aus sepatu.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4)),
               const SizedBox(height: 20),
               ...myShoes.map((shoe) {
                 return ListTile(
                   contentPadding: EdgeInsets.zero,
                   leading: Container(
                     padding: const EdgeInsets.all(10),
                     decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                     child: const Icon(Icons.snowshoeing, color: Colors.black87),
                   ),
                   title: Text(shoe['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                   subtitle: Text('${shoe['type']}  •  Tercatat: ${shoe['mileage']} km', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                   trailing: const Icon(Icons.chevron_right),
                   onTap: () {
                     setState(() {
                       _selectedShoe = shoe['name'];
                     });
                     Navigator.pop(context);
                     // Notifikasi Hijau Sukses
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                         content: Text("${shoe['name']} dipilih! Jarak lari diakumulasi."),
                         backgroundColor: Colors.green,
                         behavior: SnackBarBehavior.floating,
                       )
                     );
                   },
                 );
               }).toList(),
            ],
          ),
        );
      }
    );
  }

  // --- FUNGSI NAVIGASI YANG AMAN ---
  void _navigateBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  // =========================================
  // WIDGET HELPERS
  // =========================================

  Widget _buildMainStat(String label, String value, String unit) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.black87)),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
            children: [
              TextSpan(
                  text: " ($unit)",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 40, width: 1, color: Colors.grey[200]);
  }

  Widget _buildDetailCard(
      IconData icon, Color color, String title, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(unit,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSplitHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _splitText("KM", isHeader: true),
          _splitText("PACE", isHeader: true),
          _splitText("ELEV", isHeader: true),
        ],
      ),
    );
  }

  Widget _buildSplitRow(int km, String pace, String elev) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
            child: Text(km.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          Text(pace,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87)),
          Text(elev, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _splitText(String text, {bool isHeader = false}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        color: isHeader ? Colors.grey[400] : Colors.black87,
      ),
    );
  }
}
