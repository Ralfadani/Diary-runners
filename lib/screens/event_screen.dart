// lib/screens/event_screen.dart

import 'package:flutter/material.dart';
import 'package:runners_hub/models/event.dart';
import 'package:runners_hub/screens/event_detail_screen.dart';

class EventScreen extends StatelessWidget {
  // Data Dummy Event
  final List<Event> events = [
    Event(
      name: "Jakarta Running Festival ",
      date: "10 November 2025",
      location: "Gelora Bung Karno, Jakarta",
      imageUrl: "assets/images/jrf.jpeg",
      description:
          "Event lari terbesar tahun ini di Jakarta! Rute steril melewati landmark ikonik kota Jakarta. Tersedia kategori 5K, 10K, Half Marathon, dan Full Marathon. Dapatkan medali finisher eksklusif dan jersey lari premium.",
    ),
    Event(
      name: "Pocari Sweat Run",
      date: "20 November 2025",
      location: "Gedung Sate, Bandung",
      imageUrl: "assets/images/pocari.jpeg",
      description:
          "Nikmati udara sejuk Bandung sambil berlari santai sejauh 5K. Acara ini cocok untuk pemula dan keluarga. Akan ada festival kuliner di garis finish!",
    ),
    Event(
      name: "Borobudur Marathon",
      date: "15 Januari 2026",
      location: "Magelang, Jawa Tengah",
      imageUrl: "assets/images/bormar.jpeg",
      description:
          "Lari dengan pemandangan Candi Borobudur yang megah. Salah satu event marathon paling bergengsi di Indonesia dengan rute pedesaan yang asri.",
    ),
    Event(
      name: "Maybank Bali Marathon",
      date: "5 Desember 2025",
      location: "Pantai Kuta, Bali",
      imageUrl: "assets/images/maybank.jpeg",
      description:
          "Rasakan sensasi berlari di atas pasir putih Pantai Kuta saat matahari terbenam. Pesta pantai menanti Anda setelah garis finish.",
    ),
  ];

  EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Abu-abu muda modern
      appBar: AppBar(
        title: const Text(
          'Jadwal Event',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.deepOrange),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final event = events[index];
          return _buildEventCard(context, event);
        },
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- GAMBAR EVENT ---
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  // --- PERBAIKAN DI SINI ---
                  // Ubah Image.network menjadi Image.asset
                  Image.asset(
                    event.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // Image.asset tidak memiliki errorBuilder bawaan yang sama persis
                    // tapi jika file tidak ada, dia akan melempar error di console.
                    // Pastikan file benar-benar ada di folder assets.
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, color: Colors.grey),
                          Text("Gambar tidak ditemukan",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  // Badge Tanggal di atas gambar
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 12, color: Colors.deepOrange),
                          const SizedBox(width: 4),
                          Text(
                            event.date
                                .split(" ")
                                .take(2)
                                .join(" "), // Ambil tgl & bulan saja
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- INFORMASI TEXT ---
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Lokasi
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Tombol "Lihat Detail"
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Buka Pendaftaran",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                      Row(
                        children: [
                          Text(
                            "Detail",
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.arrow_forward,
                              size: 16, color: Colors.deepOrange),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
