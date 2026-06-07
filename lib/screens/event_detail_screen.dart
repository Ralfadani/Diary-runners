// lib/screens/event_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:runners_hub/models/event.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Membuat gambar bisa sampai ke belakang status bar
      body: Stack(
        children: [
          // --- 1. GAMBAR BACKGROUND (FULL HEIGHT) ---
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 350, // Tinggi gambar header
            child: Image.network(
              event.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image,
                      size: 50, color: Colors.grey),
                );
              },
            ),
          ),

          // --- 2. TOMBOL BACK & TITLE ---
          Positioned(
            top: 40, // Sesuaikan dengan safe area
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tombol Back Custom
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                // Tombol Share / Favorite (Opsional)
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: IconButton(
                    icon: const Icon(Icons.share, color: Colors.black),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          // --- 3. KONTEN DETAIL (SHEET) ---
          Positioned.fill(
            top: 280, // Mulai konten sedikit menumpuk gambar
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                    bottom: 100), // Ruang untuk tombol bawah
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label Kategori (Dummy)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "MARATHON",
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Judul Event
                    Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Info Lokasi & Waktu
                    Row(
                      children: [
                        _buildInfoIcon(Icons.calendar_month, Colors.blue),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Tanggal Pelaksanaan",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            Text(event.date,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildInfoIcon(Icons.location_on, Colors.redAccent),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Lokasi",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              Text(event.location,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 40, thickness: 1),

                    // Deskripsi
                    const Text(
                      "Tentang Event",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.6, // Jarak antar baris agar enak dibaca
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Contoh fitur tambahan
                    const Text(
                      "Fasilitas",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: [
                        _buildChip("Medali Finisher"),
                        _buildChip("Jersey"),
                        _buildChip("Refreshment"),
                        _buildChip("BIB Number"),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),

          // --- 4. STICKY BUTTON DAFTAR ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Pendaftaran berhasil! Sampai jumpa di garis start.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'DAFTAR SEKARANG',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Icon Info
  Widget _buildInfoIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  // Widget Helper untuk Chip Fasilitas
  Widget _buildChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.grey[100],
      labelStyle: TextStyle(color: Colors.grey[800], fontSize: 12),
    );
  }
}
