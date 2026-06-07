import 'package:runners_hub/models/shoe.dart';

class AnalyticsInsight {
  final String title;
  final String description;
  final String type; // 'descriptive', 'prescriptive', 'diagnostic'

  AnalyticsInsight({
    required this.title, 
    required this.description, 
    required this.type
  });
}

class AnalyticsService {
  // 1. Analisis Kausal: Waktu vs Performa (Diagnostic Insight)
  static AnalyticsInsight generateTimeOfDayInsight() {
    // Pada prototipe ini, kita asumsikan mesin BI telah memproses log aktivitas (diary).
    return AnalyticsInsight(
      title: "Pola Performa Lari Optimal",
      description: "Dari catatan Diary Anda bulan ini, pace Anda rata-rata 15% lebih cepat (5'30\"/km) ketika berlari di pagi hari (05.00-08.00) dibandingkan sore hari.",
      type: "diagnostic",
    );
  }

  // 2. Analisis Preskriptif: Deteksi Keausan Sepatu berbasis Berat Badan
  static AnalyticsInsight calculateShoeWearInsight(Shoe shoe, double userWeightKg) {
    // Standar pengujian ketahanan busa (midsole) sepatu adalah pada berat 65kg.
    double baseWeight = 65.0;
    double weightDifference = userWeightKg - baseWeight;
    
    // Algoritma: Setiap kelebihan berat 5kg di atas 65kg, daya tahan sepatu (max) tereduksi 2.5%
    double maxDistance = shoe.maxDistanceConfigured;
    if (weightDifference > 0) {
      double reductionFactor = (weightDifference / 5.0) * 0.025;
      maxDistance = maxDistance * (1.0 - reductionFactor);
    }

    double wearPercent = shoe.currentDistance / maxDistance;
    double remaining = maxDistance - shoe.currentDistance;

    if (wearPercent >= 0.85) {
      return AnalyticsInsight(
        title: "Peringatan Kelayakan Sepatu!",
        description: "Berdasarkan berat badan Anda ($userWeightKg Kg), sepatu ${shoe.brand} ${shoe.modelName} Anda telah mendekati batas akhir peredam kejut (sisa ${remaining.toStringAsFixed(1)} KM). Segera ganti untuk mencegah risiko Plantar Fasciitis.",
        type: "prescriptive",
      );
    } else {
      return AnalyticsInsight(
        title: "Status Perangkat Lari",
        description: "Bantalan sepatu ${shoe.brand} ${shoe.modelName} Anda masih prima. Perkiraan sisa jarak tempuh aman menurut perhitungan biologis: ${remaining.toStringAsFixed(1)} KM.",
        type: "descriptive",
      );
    }
  }

  // 3. Sistem Rekomendasi Pintar (Smart Recommendation) -> Menggabungkan Event & Outfit
  static AnalyticsInsight generateSmartRecommendation(Shoe shoe, double userWeightKg) {
    final wearInsight = calculateShoeWearInsight(shoe, userWeightKg);
    
    if (wearInsight.title.contains("Peringatan")) {
       return AnalyticsInsight(
         title: "Rekomendasi Outfit & Sepatu",
         description: "Sepatu utama Anda akan segera aus. Coba lihat koleksi 'Daily Trainer' terbaru dengan peredam maksimal yang cocok untuk postur tubuh Anda di toko terdekat.",
         type: "prescriptive",
       );
    }
    
    return AnalyticsInsight(
         title: "Rekomendasi Event",
         description: "Karena Anda nyaman berjalan di jarak 5KM, kami merekomendasikan event 'City Fun Run 5K' minggu depan. Anda sudah lebih dari siap!",
         type: "prescriptive",
       );
  }
}
