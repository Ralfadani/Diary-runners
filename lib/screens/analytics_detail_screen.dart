import 'package:flutter/material.dart';
import 'package:runners_hub/models/shoe.dart';
import 'package:runners_hub/services/analytics_service.dart';

class AnalyticsDetailScreen extends StatelessWidget {
  const AnalyticsDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simulasi Data untuk Dashboard BI
    final myShoe = Shoe(
      id: "s_01",
      brand: "Nike",
      modelName: "Pegasus 40",
      maxDistanceConfigured: 500,
      currentDistance: 455,
      type: "Daily Trainer",
    );
    final double myWeightKg = 85.0;

    final diagnosticInsight = AnalyticsService.generateTimeOfDayInsight();
    final wearInsight = AnalyticsService.calculateShoeWearInsight(myShoe, myWeightKg);
    final smartRecommendation = AnalyticsService.generateSmartRecommendation(myShoe, myWeightKg);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text(
          'BI Analytics Dashboard',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. DESCRIPTIVE SECTION: Ringkasan Performa
            _buildSectionHeader("Descriptive Analytics", "Ringkasan data historis"),
            const SizedBox(height: 16),
            _buildDescriptiveStatsGrid(),
            
            const SizedBox(height: 32),

            // 2. DIAGNOSTIC SECTION: Analisis Pola (Waktu vs Pace)
            _buildSectionHeader("Diagnostic Analytics", "Analisis sebab-akibat"),
            const SizedBox(height: 16),
            _buildDiagnosticChart(diagnosticInsight),

            const SizedBox(height: 32),

            // 3. PRESCRIPTIVE SECTION: Kesehatan Alat & Saran
            _buildSectionHeader("Prescriptive Analytics", "Rekomendasi tindakan"),
            const SizedBox(height: 16),
            _buildShoeHealthMeter(wearInsight, myShoe),
            const SizedBox(height: 16),
            _buildPrescriptiveCard(smartRecommendation),

            const SizedBox(height: 40),
            
            // Footer untuk kesan Akademik/Profesional
            Center(
              child: Text(
                "Data dianalisis menggunakan Mesin BI Diary Runners\nBerdasarkan log aktivitas 30 hari terakhir.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[400], fontSize: 10, height: 1.5),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Colors.deepOrange,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptiveStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard("Total Jarak", "124.5", "KM", Icons.route_rounded, Colors.blue),
        _buildStatCard("Avg Pace", "5'45\"", "/KM", Icons.speed_rounded, Colors.orange),
        _buildStatCard("Total Lari", "18", "X", Icons.directions_run_rounded, Colors.green),
        _buildStatCard("Kalori", "12,400", "KCAL", Icons.local_fire_department_rounded, Colors.red),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, String unit, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
              Text(
                "$unit • $label",
                style: TextStyle(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticChart(AnalyticsInsight insight) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.analytics_rounded, color: Colors.orange, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                "Korelasi Waktu vs Pace",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Simulasi Chart Batang Sederhana
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildChartBar("Pagi", 5.5, Colors.orange), // Pace 5'30"
              _buildChartBar("Siang", 6.8, Colors.grey.shade300), // Pace 6'48"
              _buildChartBar("Sore", 6.2, Colors.blue), // Pace 6'12"
              _buildChartBar("Malam", 6.5, Colors.indigo), // Pace 6'30"
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            insight.description,
            style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(String label, double paceValue, Color color) {
    // Makin kecil pace (makin cepat), bar makin tinggi untuk visualisasi "Performa"
    double height = (8 - paceValue) * 30; 
    if (height < 20) height = 20;

    return Column(
      children: [
        Text(
          "${paceValue.toStringAsFixed(1)}'",
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 8),
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildShoeHealthMeter(AnalyticsInsight insight, Shoe shoe) {
    double progress = shoe.currentDistance / shoe.maxDistanceConfigured;
    if (progress > 1.0) progress = 1.0;
    
    Color statusColor = Colors.green;
    if (progress > 0.8) statusColor = Colors.red;
    else if (progress > 0.6) statusColor = Colors.orange;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Health Perangkat (BI Engine)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  progress > 0.8 ? "KRITIS" : "STABIL",
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "${shoe.brand} ${shoe.modelName}",
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 12),
          // Progress Bar Visual
          Stack(
            children: [
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [statusColor.withOpacity(0.6), statusColor]),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${shoe.currentDistance.toInt()} KM", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text("${shoe.maxDistanceConfigured.toInt()} KM", style: TextStyle(fontSize: 12, color: Colors.grey[400])),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: statusColor, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    insight.description,
                    style: TextStyle(fontSize: 11, color: Colors.grey[800], height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptiveCard(AnalyticsInsight insight) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text(
                "Saran & Rekomendasi Pintar",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            insight.title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            insight.description,
            style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9), height: 1.5),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text("Lihat Detail", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
