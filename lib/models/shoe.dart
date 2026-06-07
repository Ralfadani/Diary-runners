class Shoe {
  final String id;
  final String brand;
  final String modelName;
  final double maxDistanceConfigured; // dalam KM, batas standar aus (ex: 500 KM)
  final double currentDistance; // dalam KM, akumulasi jarak lari
  final String type; // contoh: "Daily Trainer", "Racing"

  Shoe({
    required this.id,
    required this.brand,
    required this.modelName,
    required this.maxDistanceConfigured,
    required this.currentDistance,
    required this.type,
  });

  // Kalkulasi sederhana sisa keausan tanpa hitungan berat
  double get wearPercentage => (currentDistance / maxDistanceConfigured).clamp(0.0, 1.0);
}
