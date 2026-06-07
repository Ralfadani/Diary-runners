import 'package:flutter/material.dart';

class MyEventDetailScreen extends StatelessWidget {
  final Map<String, dynamic> eventData;

  const MyEventDetailScreen({Key? key, required this.eventData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine goal pace based on time and distance if possible
    // For simplicity, we hardcode some text if not available
    final distanceStr = eventData['category'] ?? "42,20 km";
    final goalTimeStr = eventData['estimatedTime'] ?? "4:31:27";
    final dateStr = eventData['date'] ?? "14 June 2026";
    final title = eventData['name'] ?? "BTN Jakarta International Marathon";
    final eventTypeStr = eventData['type'] ?? "Running";
    final startTimeStr = eventData['startTime'] ?? "See event website for details.";
    final locationStr = eventData['location'] ?? "Jakarta, ID";
    final websiteStr = eventData['website'] ?? "-";
    
    // Simulate countdown string
    final countdownStr = eventData['daysLeft'] != null ? "${eventData['daysLeft']} days" : "3 w 6 d";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // Light background for app
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.deepOrange, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Event Detail",
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Colors.deepOrange, // Orange circle
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.outlined_flag_rounded, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Verified Source", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          style: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          distanceStr,
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.ios_share, color: Colors.deepOrange, size: 24),
                ],
              ),
            ),
            
            // Metrics Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4)
                    )
                  ]
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(countdownStr, style: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w800)),
                                const SizedBox(height: 4),
                                Text("Countdown", style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Container(width: 1, height: 40, color: Colors.grey[200]), // Vertical divider
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("6:26 /km", style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 4),
                                  Text("Goal Pace", style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 1, color: Colors.grey[200]), // Middle divider
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(goalTimeStr, style: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w800)),
                                const SizedBox(height: 4),
                                Text("Goal Time", style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tabs Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text("Overview", style: TextStyle(color: Colors.deepOrange, fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      Container(height: 3, margin: const EdgeInsets.symmetric(horizontal: 40), color: Colors.deepOrange), // Active indicator
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text("Training", style: TextStyle(color: Colors.grey[500], fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      Container(height: 3, margin: const EdgeInsets.symmetric(horizontal: 40), color: Colors.transparent),
                    ],
                  ),
                ),
              ],
            ),
            Container(height: 1, color: Colors.grey[200]), // Tab bottom divider

            // Info text
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "If you share this event with others, they will be able to view these details.",
                style: TextStyle(color: Colors.grey[500], fontSize: 13, fontStyle: FontStyle.italic, height: 1.5),
              ),
            ),

            // List items inside a nice white container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    _buildListItem("Event Type", eventTypeStr),
                    _buildListItem("Date", dateStr),
                    _buildListItem("Local Start Time", startTimeStr),
                    _buildListItem("Location", locationStr),
                    _buildListItemRowWithIcon("Website", Icons.open_in_new_rounded, isLast: true),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(title, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 14)),
              ),
              Expanded(
                flex: 3,
                child: Text(value, style: TextStyle(color: Colors.grey[600], fontSize: 14), textAlign: TextAlign.right),
              ),
            ],
          ),
        ),
        Container(height: 1, color: Colors.grey[100]),
      ],
    );
  }

  Widget _buildListItemRowWithIcon(String title, IconData icon, {bool isLast = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 14)),
              Icon(icon, color: Colors.deepOrange, size: 20),
            ],
          ),
        ),
        if (!isLast) Container(height: 1, color: Colors.grey[100]),
      ],
    );
  }
}
