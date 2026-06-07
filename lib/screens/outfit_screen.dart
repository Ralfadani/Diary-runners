import 'package:flutter/material.dart';

// --- 1. MODEL DATA (Disatukan di sini) ---
class Outfit {
  final String category;
  final String item;
  final String tip;
  final IconData icon;

  Outfit({
    required this.category,
    required this.item,
    required this.tip,
    required this.icon,
  });
}

// --- 2. ENUM CUACA ---
enum WeatherCondition { hot, cool, rain }

// --- 3. SCREEN UTAMA ---
class OutfitScreen extends StatefulWidget {
  const OutfitScreen({super.key});

  @override
  _OutfitScreenState createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {
  // Status cuaca default (Panas)
  WeatherCondition _currentCondition = WeatherCondition.hot;

  // Data rekomendasi outfit berdasarkan kondisi cuaca
  final Map<WeatherCondition, List<Outfit>> _outfitData = {
    WeatherCondition.hot: [
      Outfit(
          category: 'Atasan',
          item: 'Tank Top / T-shirt Ringan',
          tip: 'Pilih bahan Dri-FIT atau cepat kering.',
          icon: Icons.wb_sunny_outlined),
      Outfit(
          category: 'Bawahan',
          item: 'Celana Pendek 5 inci',
          tip: 'Jarak pendek hingga menengah, memaksimalkan ventilasi.',
          icon: Icons.waves),
      Outfit(
          category: 'Aksesoris',
          item: 'Topi & Kacamata Hitam',
          tip: 'Lindungi dari sinar UV dan cegah keringat menetes ke mata.',
          icon: Icons.face),
      Outfit(
          category: 'Hidrasi',
          item: 'Botol Air Pinggang',
          tip: 'Kunci untuk sesi lari panas yang lebih lama.',
          icon: Icons.local_drink_outlined),
    ],
    WeatherCondition.cool: [
      Outfit(
          category: 'Atasan',
          item: 'T-shirt Lengan Panjang Tipis',
          tip: 'Lapisan tunggal yang cukup untuk menjaga suhu inti tubuh.',
          icon: Icons.ac_unit),
      Outfit(
          category: 'Bawahan',
          item: 'Celana Pendek / Legging 3/4',
          tip: 'Legging menjaga otot tetap hangat saat suhu turun.',
          icon: Icons.sports_gymnastics),
      Outfit(
          category: 'Kaki',
          item: 'Kaus Kaki Tebal (Wool)',
          tip: 'Menghindari jari kaki mati rasa karena dingin.',
          icon: Icons.tungsten),
      Outfit(
          category: 'Opsional',
          item: 'Sarung Tangan Ringan',
          tip: 'Bisa dilepas dan disimpan jika tubuh mulai panas.',
          icon: Icons.handshake_outlined),
    ],
    WeatherCondition.rain: [
      Outfit(
          category: 'Atasan',
          item: 'Jaket Lari Tahan Air',
          tip:
              'Cari yang *water-resistant* dan memiliki ventilasi (hood opsional).',
          icon: Icons.cloudy_snowing),
      Outfit(
          category: 'Bawahan',
          item: 'Celana Pendek atau Celana Ketat',
          tip:
              'Hindari celana longgar yang akan menyerap air dan menjadi berat.',
          icon: Icons.thunderstorm_outlined),
      Outfit(
          category: 'Kepala',
          item: 'Topi Berpinggiran',
          tip: 'Menjaga air hujan agar tidak langsung mengenai wajah/mata.',
          icon: Icons.umbrella_outlined),
      Outfit(
          category: 'Sepatu',
          item: 'Sepatu dengan Grip Kuat',
          tip: 'Waspadai jalan licin. Keringkan sepatu segera setelah lari.',
          icon: Icons.hiking),
    ],
  };

  String _getWeatherLabel(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.hot:
        return '☀️ PANAS (25°C+)';
      case WeatherCondition.cool:
        return '☁️ DINGIN (10°C - 20°C)';
      case WeatherCondition.rain:
        return '🌧️ HUJAN / BERKABUT';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Rekomendasi Outfit',
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          // --- Pilihan Cuaca ---
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPillButton(
                    label: 'Panas',
                    condition: WeatherCondition.hot,
                    icon: Icons.sunny),
                _buildPillButton(
                    label: 'Dingin',
                    condition: WeatherCondition.cool,
                    icon: Icons.cloudy_snowing),
                _buildPillButton(
                    label: 'Hujan',
                    condition: WeatherCondition.rain,
                    icon: Icons.umbrella),
              ],
            ),
          ),

          // --- Daftar Rekomendasi ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Saran Pakaian: ${_getWeatherLabel(_currentCondition)}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange),
                ),
                const SizedBox(height: 12),

                // Generate kartu dari data
                ..._outfitData[_currentCondition]!.map((outfit) {
                  return _buildOutfitCard(outfit);
                }).toList(),

                const SizedBox(height: 20),

                // Tips Umum
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '💡 Tips Umum',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800]),
                      ),
                      const SizedBox(height: 8),
                      _buildGeneralTip(
                          'Hindari bahan katun 100% karena menyerap keringat dan menjadi berat.'),
                      _buildGeneralTip(
                          'Gunakan kaus kaki anti-blister untuk mencegah lecet.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildPillButton(
      {required String label,
      required WeatherCondition condition,
      required IconData icon}) {
    bool isSelected = _currentCondition == condition;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentCondition = condition;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? Colors.deepOrange : Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 18, color: isSelected ? Colors.white : Colors.black54),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutfitCard(Outfit outfit) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(outfit.icon, color: Colors.deepOrange, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(outfit.category.toUpperCase(),
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0)),
                  const SizedBox(height: 4),
                  Text(outfit.item,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text(outfit.tip,
                      style: const TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.black54,
                          fontSize: 13,
                          height: 1.3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, color: Colors.blue[700], size: 16),
          const SizedBox(width: 8),
          Expanded(
              child: Text(tip,
                  style: TextStyle(color: Colors.blue[900], fontSize: 13))),
        ],
      ),
    );
  }
}
