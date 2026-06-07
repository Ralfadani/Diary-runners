class Activity {
  final String id;
  final DateTime date;
  final double distance; // in km
  final String duration; // e.g. "30:00"
  final String pace; // e.g. "6'00\""
  final int calories;
  final String imageUrl; // Map snapshot or photo
  final String title; // e.g. "Morning Run"

  Activity({
    required this.id,
    required this.date,
    required this.distance,
    required this.duration,
    required this.pace,
    required this.calories,
    required this.imageUrl,
    required this.title,
  });
}
