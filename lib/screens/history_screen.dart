import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:runners_hub/models/activity.dart';
import 'package:runners_hub/screens/detail_activity_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Dummy Data
  final List<Activity> _activities = [
    Activity(
      id: '1',
      date: DateTime.now().subtract(const Duration(days: 0, hours: 2)),
      distance: 5.02,
      duration: "32:15",
      pace: "6'25\"",
      calories: 345,
      imageUrl: "assets/images/maps.jpeg",
      title: "Lari Pagi Santai",
    ),
    Activity(
      id: '2',
      date: DateTime.now().subtract(const Duration(days: 1, hours: 14)),
      distance: 3.50,
      duration: "20:10",
      pace: "5'45\"",
      calories: 210,
      imageUrl: "assets/images/maps.jpeg",
      title: "Interval Run",
    ),
    Activity(
      id: '3',
      date: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
      distance: 10.00,
      duration: "1:05:30",
      pace: "6'33\"",
      calories: 780,
      imageUrl: "assets/images/maps.jpeg",
      title: "Long Run Sunday",
    ),
    Activity(
      id: '4',
      date: DateTime.now().subtract(const Duration(days: 5, hours: 10)),
      distance: 2.50,
      duration: "15:00",
      pace: "6'00\"",
      calories: 150,
      imageUrl: "assets/images/maps.jpeg",
      title: "Recovery Run",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text(
          "Riwayat Latihan",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _activities.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final activity = _activities[index];
          return _buildActivityCard(activity);
        },
      ),
    );
  }

  Widget _buildActivityCard(Activity activity) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetailActivityScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // 1. Header: Date & Time
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.directions_run_rounded,
                        color: Colors.deepOrange, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEEE, d MMM • HH:mm', 'id_ID')
                            .format(activity.date),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                ],
              ),
            ),

            const Divider(height: 1, indent: 16, endIndent: 16),

            // 2. Body: Map & Stats
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Map Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset(
                        activity.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Stats Grid
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem("Jarak", "${activity.distance}", "km"),
                        _buildStatItem("Waktu", activity.duration, ""),
                        _buildStatItem("Pace", activity.pace, "/km"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[500],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: 2),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
