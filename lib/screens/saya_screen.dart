// lib/screens/progress_screen.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // State untuk filter waktu (0: Minggu, 1: Bulan, 2: Tahun)
  int _selectedPeriodIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Statistik & Progres',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black54, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black54),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Fitur share akan segera hadir!")));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Filter Waktu (Segmented Control)
            _buildPeriodSelector(),
            const SizedBox(height: 24),

            // 2. Grafik Aktivitas (Custom Bar Chart)
            const Text("Aktivitas Lari",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildWeeklyChartCard(),
            const SizedBox(height: 24),

            // 3. Grid Statistik Ringkasan
            const Text("Ringkasan Performa",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildStatsGrid(),
            const SizedBox(height: 24),

            // 4. Rekor Pribadi (Personal Records)
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Rekor Terbaik",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Lihat Semua",
                    style: TextStyle(color: Colors.deepOrange, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),
            _buildPersonalRecordCard(
                "Lari Terjauh", "15.2 km", "12 Okt 2024", Icons.map),
            const SizedBox(height: 12),
            _buildPersonalRecordCard("Pace Terbaik (5k)", "4'50\" /km",
                "20 Sep 2024", Icons.timer_outlined),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // =========================================
  // WIDGET: SELECTOR PERIODE
  // =========================================
  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          _buildPeriodBtn("Minggu Ini", 0),
          _buildPeriodBtn("Bulan Ini", 1),
          _buildPeriodBtn("Tahun Ini", 2),
        ],
      ),
    );
  }

  Widget _buildPeriodBtn(String text, int index) {
    bool isSelected = _selectedPeriodIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriodIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2))
                  ]
                : [],
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black87 : Colors.grey[600],
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  // =========================================
  // WIDGET: CHART MINGGUAN (CUSTOM)
  // =========================================
  Widget _buildWeeklyChartCard() {
    // Data Dummy: Jarak lari per hari (Senin - Minggu)
    final List<double> weeklyData = [3.5, 0.0, 5.2, 4.0, 0.0, 8.5, 2.0];
    final List<String> days = ["S", "S", "R", "K", "J", "S", "M"];
    final double maxVal = weeklyData.reduce(math.max);

    return Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Jarak",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(height: 4),
                  Text("23.2 km",
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text("+12%",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          // Area Bar Chart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              // Hitung tinggi relatif bar terhadap max value
              // Minimal tinggi 4 pixel supaya bar kosong tetap terlihat sedikit
              double heightPercentage =
                  (weeklyData[index] / (maxVal == 0 ? 1 : maxVal));
              double barHeight = 100 * heightPercentage;

              bool isToday = index == 6; // Anggap hari ini Minggu

              return Column(
                children: [
                  // Tooltip nilai (opsional, muncul kalau tinggi cukup)
                  if (weeklyData[index] > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        weeklyData[index].toString(),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),

                  // Batang Chart
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: 12, // Lebar batang lebih ramping
                    height: barHeight == 0 ? 4 : barHeight,
                    decoration: BoxDecoration(
                      color: isToday
                          ? Colors.deepOrange
                          : (weeklyData[index] > 0
                              ? Colors.deepOrange.withOpacity(0.3)
                              : Colors.grey[200]),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    days[index],
                    style: TextStyle(
                      color: isToday ? Colors.black87 : Colors.grey,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            }),
          )
        ],
      ),
    );
  }

  // =========================================
  // WIDGET: GRID STATISTIK
  // =========================================
  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(
          child: _statCardItem(
            title: "Kalori",
            value: "1,240",
            unit: "kcal",
            icon: Icons.local_fire_department_rounded,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statCardItem(
            title: "Durasi",
            value: "3h 20m",
            unit: "",
            icon: Icons.timer,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _statCardItem({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              // Indikator kecil (hiasan)
              Icon(Icons.arrow_outward, color: Colors.grey[300], size: 16),
            ],
          ),
          const SizedBox(height: 16),
          Text(value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          RichText(
            text: TextSpan(
              text: title,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              children: [
                if (unit.isNotEmpty)
                  TextSpan(
                    text: " ($unit)",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }

  // =========================================
  // WIDGET: KARTU REKOR PRIBADI
  // =========================================
  Widget _buildPersonalRecordCard(
      String title, String value, String date, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.purple, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
              const SizedBox(height: 4),
              Text(date,
                  style: TextStyle(color: Colors.grey[400], fontSize: 10)),
            ],
          )
        ],
      ),
    );
  }
}
