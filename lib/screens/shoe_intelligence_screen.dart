import 'package:flutter/material.dart';
import 'package:runners_hub/screens/add_shoe_screen.dart';

class ShoeIntelligenceScreen extends StatelessWidget {
  const ShoeIntelligenceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text("Gear Intelligence",
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.deepPurple),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddShoeScreen()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER: ACTIVE SHOE ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Sepatu Utama Anda", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87)),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddShoeScreen()));
                  },
                  child: const Text("+ Tambah", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 8),
            _buildShoeCard(),
            
            const SizedBox(height: 32),

            // --- BI 1: DIAGNOSTIC ---
            _buildSectionTitle("Diagnostic Analytics", "Indikator Keausan Multivariabel"),
            const SizedBox(height: 12),
            _buildInsightBox(
              icon: Icons.insights_rounded,
              color: Colors.deepOrange,
              title: "Penyesuaian Umur Sepatu (Berat & Medan)",
              content: "Kamu memiliki profil berat badan 85kg dan sering berlari di aspal panas (Pavement). Bantalan sepatu EVA biasanya akan aus 20% lebih cepat dibanding profil standar (65kg). \n\nUmur adaptif bantalan (midsole) sepatu ini diperkirakan akan Kritis pada jarak 400KM, bukan 500KM (klaim pabrikan).",
            ),

            const SizedBox(height: 24),

            // --- BI 2: PRESCRIPTIVE ---
            _buildSectionTitle("Prescriptive Analytics", "Rotasi Sepatu & Recovery Busa"),
            const SizedBox(height: 12),
            _buildInsightBox(
              icon: Icons.loop_rounded,
              color: Colors.blue,
              title: "Saran Rotasi Latihan",
              content: "Sepatu 'Nike Pegasus 40' ini baru saja dipakai untuk lari 15KM kemarin. Busa midsolenya butuh waktu 24 jam untuk mengembang kembali (decompress) secara maksimal.\n\nGunakan sepatu 'Adidas Boston' kamu (jika ada) untuk lari recovery hari ini agar umur Pegasus kamu lebih awet.",
            ),

            const SizedBox(height: 24),

            // --- BI 3: FINANCIAL ---
            _buildSectionTitle("Financial Analytics", "Return of Investment (ROI)"),
            const SizedBox(height: 12),
            _buildROIBox(),

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
        Text(type.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.deepPurple, letterSpacing: 1.2)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87)),
      ],
    );
  }

  Widget _buildShoeCard() {
    double progress = 350 / 400; // 350km dari max dinamis 400km
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.do_not_step, size: 32, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nike Pegasus 40", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("Daily Trainer", style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text("WARNING", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 10)),
              )
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Kesehatan Busa (Midsole)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              Text("${(progress * 100).toInt()}% Aus", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.orange)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: Colors.orange,
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text("Jarak Tempuh: 350 KM / Max Adaptif: 400 KM", style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildInsightBox({required IconData icon, required Color color, required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87))),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildROIBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.attach_money_rounded, color: Colors.green, size: 32),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Biaya Lari: Rp 5.714 / KM", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 6),
                Text(
                  "Harga beli (Rp 2 Juta) dibagi jarak tempuh (350 KM). Capai 400 KM untuk menekan biaya ke Rp 5.000 / KM.",
                  style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.4),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
