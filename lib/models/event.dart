// lib/models/event.dart

class Event {
  final String name;
  final String date;
  final String location;
  final String imageUrl;
  final String description;

  Event({
    required this.name,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.description,
  });
}