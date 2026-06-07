import 'package:flutter/material.dart';

class PerformanceAnalyticsScreen extends StatelessWidget {
  const PerformanceAnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text("Performance Intelligence",
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. DESCRIPTIVE ANALYTICS ---
            _buildSectionTitle("Descriptive Analytics", "Beban Latihan Mingguan"),
            const SizedBox(height: 12),
            _buildChartMockup(),

            const SizedBox(height: 32),

            // --- 2. DIAGNOSTIC ANALYTICS ---
            _buildSectionTitle("Diagnostic Analytics", "Analisis Korelasi Performa"),
            const SizedBox(height: 12),
            _buildInsightCard(
              icon: Icons.monitor_heart_outlined,
              color: Colors.blue,
              title: "Heart Rate vs Pace",
              description:
                  "Pace kamu menurun 15% pada lari terakhir. Ini wajar karena rute yang kamu ambil memiliki elevasi (tanjakan) 2x lebih tinggi dari biasanya. Detak jantung rata-rata kamu stabil di Zona 3 (Aerobic).",
            ),

            const SizedBox(height: 32),

            // --- 3. PREDICTIVE ANALYTICS ---
            _buildSectionTitle("Predictive Analytics", "Estimasi Waktu Lomba (Race Predictor)"),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildPredictionCard("5K", "24:30")),
                const SizedBox(width: 16),
                Expanded(child: _buildPredictionCard("10K", "52:15")),
                const SizedBox(width: 16),
                Expanded(child: _buildPredictionCard("HM", "2:05:00")),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "*Berdasarkan VO2Max estimasi dan konsistensi pace 4 minggu terakhir.",
              style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
            ),

            const SizedBox(height: 32),

            // --- 4. PRESCRIPTIVE ANALYTICS ---
            _buildSectionTitle("Prescriptive Analytics", "Rekomendasi Pemulihan"),
            const SizedBox(height: 12),
            _buildInsightCard(
              icon: Icons.health_and_safety_outlined,
              color: Colors.green,
              title: "Saran Latihan Besok",
              description:
                  "Risiko Cedera Terkendali. Beban latihanmu optimal minggu ini. Kami merekomendasikan lari pemulihan (Recovery Run) sejauh 3-5KM dengan pace santai (7:30/km) besok untuk membuang asam laktat.",
            ),
            
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String type, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(type.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.deepOrange, letterSpacing: 1.2)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87)),
      ],
    );
  }

  Widget _buildChartMockup() {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_rounded, size: 64, color: Colors.deepOrange.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            "Volume Latihan Naik 20% Dibanding Minggu Lalu",
            style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  Widget _buildPredictionCard(String distance, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(distance, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Text(time, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildInsightCard({required IconData icon, required Color color, required String title, required String description}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87)),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
