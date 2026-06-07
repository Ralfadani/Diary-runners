// lib/screens/routes_screen.dart

import 'package:flutter/material.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({Key? key}) : super(key: key);

  @override
  _RoutesScreenState createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  // Mock data untuk simulasi kartu rute "Made for you"
  final List<Map<String, dynamic>> _routes = [
    {
      "title": "Jalan Terogong Raya-Jalan Met...",
      "difficulty": "Moderate",
      "difficultyColor": Colors.blue[600],
      "distance": "10,78 km",
      "elevation": "55 m",
      "time": "1h 23m",
      "imageUrl": "https://images.unsplash.com/photo-1519331379826-f10be5486c6f?q=80&w=500&auto=format&fit=crop" // Foto taman/jalan
    },
    {
      "title": "Lebak Bulus - Cilandak Loop",
      "difficulty": "Easy",
      "difficultyColor": Colors.green[600],
      "distance": "5,40 km",
      "elevation": "12 m",
      "time": "45m",
      "imageUrl": "https://images.unsplash.com/photo-1502484433198-82db50a78953?q=80&w=500&auto=format&fit=crop"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171B26), // Warna dasar Map Dark Mode
      body: Stack(
        children: [
          // 1. Map Painting (Simulasi Jalan dan Rute tanpa Maps API sungguhan)
          Positioned.fill(
            child: CustomPaint(
              painter: MapPainter(),
            ),
          ),
          
          // 2. Overlay pada Peta (Chip 94% Paved & Titik Lokasi Biru)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.38,
            left: MediaQuery.of(context).size.width * 0.28,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10)],
              ),
              child: Row(
                children: [
                   Container(
                     width: 16, height: 4, 
                     decoration: BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(2))
                   ),
                   const SizedBox(width: 8),
                   const Text("94% Paved", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          ),

          // Titik Lokasi Saya (Blue Dot)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.44 - 14, 
            left: MediaQuery.of(context).size.width * 0.55 - 14,
            child: Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(color: Colors.blueAccent.withOpacity(0.6), blurRadius: 20, spreadRadius: 5)
                ],
              ),
            ),
          ),

          // 3. UI Bagian Atas (Search Bar & Filter)
          SafeArea(
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 12),
                _buildFilterChips(),
              ],
            ),
          ),

          // 4. Tombol Aksi Melayang di Kanan
          Positioned(
            right: 16,
            bottom: 180, // Ditempatkan tepat di atas kartu rute
            child: Column(
              children: [
                _buildSideButton(icon: Icons.layers_outlined, badge: "10"),
                const SizedBox(height: 12),
                _buildSideButton(text: "3D"),
                const SizedBox(height: 12),
                _buildSideButton(icon: Icons.my_location_rounded),
                const SizedBox(height: 12),
                _buildSideButton(icon: Icons.edit_rounded),
              ],
            ),
          ),

          // 5. Kartu Rute "Made for you" di Bawah
          Positioned(
            bottom: 20,
            left: 0, right: 0,
            child: SizedBox(
              height: 150,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.92),
                physics: const BouncingScrollPhysics(),
                itemCount: _routes.length,
                itemBuilder: (context, index) {
                  final route = _routes[index];
                  return _buildRouteCard(
                     title: route['title'],
                     difficulty: route['difficulty'],
                     difficultyColor: route['difficultyColor'],
                     distance: route['distance'],
                     elevation: route['elevation'],
                     time: route['time'],
                     imageUrl: route['imageUrl'],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET PENDUKUNG ---

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D21).withOpacity(0.95),
          borderRadius: BorderRadius.circular(27),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
             const SizedBox(width: 8),
             // Ikon Sepatu Orange
             Container(
               height: 40, width: 40,
               decoration: const BoxDecoration(
                 color: Color(0xFF2C2C2C),
                 shape: BoxShape.circle,
               ),
               child: const Icon(Icons.directions_run_rounded, color: Colors.deepOrange, size: 22),
             ),
             const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.deepOrange, size: 16),
             const SizedBox(width: 12),
             
             // Teks Pencarian
             Expanded(
               child: Text("Search locations", style: TextStyle(color: Colors.grey[400], fontSize: 16)),
             ),
             
             // Pemisah Horizontal
             Container(height: 24, width: 1, color: Colors.grey[700]),
             const SizedBox(width: 12),
             
             // Tombol Saved
             const Icon(Icons.bookmark_border_rounded, color: Colors.white, size: 20),
             const SizedBox(width: 4),
             const Text("Saved", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
             const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ["Routes", "Length", "Elevation", "Surface", "Difficulty"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: filters.map((filter) {
          bool isRoutes = filter == "Routes";
           return Container(
             margin: const EdgeInsets.only(right: 8),
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
             decoration: BoxDecoration(
               color: const Color(0xFF1A1D21).withOpacity(0.9),
               borderRadius: BorderRadius.circular(20),
               border: isRoutes ? Border.all(color: Colors.deepOrange, width: 1.5) : Border.all(color: Colors.grey[800]!, width: 1),
             ),
             child: Row(
               children: [
                 Text(filter, style: TextStyle(color: isRoutes ? Colors.deepOrange : Colors.white, fontWeight: isRoutes ? FontWeight.w800 : FontWeight.w600, fontSize: 13)),
                 if (isRoutes) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.deepOrange, size: 16),
                 ]
               ],
             ),
           );
        }).toList(),
      ),
    );
  }

  Widget _buildSideButton({IconData? icon, String? text, String? badge}) {
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D21).withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (icon != null) Icon(icon, color: Colors.white, size: 24),
          if (text != null) Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
          if (badge != null)
             Positioned(
               right: -2, top: -2,
               child: Container(
                 padding: const EdgeInsets.all(5),
                 decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                 child: Text(badge, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 10)),
               ),
             ),
        ],
      ),
    );
  }

  Widget _buildRouteCard({
     required String title, required String difficulty, required Color? difficultyColor,
     required String distance, required String elevation, required String time, required String imageUrl,
  }) {
     return Container(
       margin: const EdgeInsets.only(right: 12),
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
         color: const Color(0xFF15181C),
         borderRadius: BorderRadius.circular(24),
         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 8))],
       ),
       child: Row(
         children: [
           // TEKS DAN INFORMASI
           Expanded(
             child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                         decoration: BoxDecoration(color: difficultyColor?.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                         child: Text(difficulty, style: TextStyle(color: difficultyColor, fontWeight: FontWeight.w900, fontSize: 11)),
                       ),
                       const SizedBox(width: 8),
                       Expanded(child: Text("$distance • $elevation • $time", style: const TextStyle(color: Colors.white70, fontSize: 12), maxLines: 1)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                       Icon(Icons.my_location_rounded, color: Colors.white54, size: 16),
                       SizedBox(width: 6),
                       Text("Current Location", style: TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                       Icon(Icons.local_fire_department_rounded, color: Colors.deepOrange, size: 16),
                       SizedBox(width: 6),
                       Text("Made for you", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w900, fontSize: 13)),
                    ],
                  ),
                ],
             ),
           ),
           const SizedBox(width: 16),
           
           // GAMBAR THUMBNAIL
           Container(
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(16),
               boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(2, 4))],
             ),
             child: ClipRRect(
               borderRadius: BorderRadius.circular(16),
               child: Image.network(imageUrl, width: 110, height: 110, fit: BoxFit.cover),
             ),
           ),
         ],
       ),
     );
  }
}

// ==========================================================
// DUKUNGAN VISUAL PETA - MOCKUP NATIVE TINGKAT LANJUT
// ==========================================================
class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Latar Belakang Gelap Asli
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = const Color(0xFF171B26));

    // 2. Jalan Raya Minor (Garis Samar)
    final minorPaint = Paint()..color = const Color(0xFF222834)..style = PaintingStyle.stroke..strokeWidth = 1.2;
    for (double i = 0; i < size.width; i += 35) {
      canvas.drawLine(Offset(i, 0), Offset(i + 15, size.height), minorPaint);
      canvas.drawLine(Offset(0, i * 1.5), Offset(size.width, i * 1.5 - 15), minorPaint);
    }
    
    // 3. Jalan Utama (Lebih Terang dan Lebar)
    final majorPaint = Paint()..color = const Color(0xFF323B4A)..style = PaintingStyle.stroke..strokeWidth = 2.5;
    canvas.drawLine(Offset(size.width * 0.1, -50), Offset(size.width * 0.4, size.height), majorPaint); // Toll
    canvas.drawLine(Offset(size.width * 0.65, 0), Offset(size.width * 0.6, size.height), majorPaint); // Jalan Cipete dsb
    canvas.drawLine(Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.45), majorPaint); // Lebak bulus horizontal
    canvas.drawLine(Offset(0, size.height * 0.75), Offset(size.width, size.height * 0.65), majorPaint);

    // 4. Teks Label Jalan/Daerah (Mockup Text)
    _drawText(canvas, "West Cilandak", size.width * 0.45, size.height * 0.42, Colors.white54, 13);
    _drawText(canvas, "Lebak Bulus", size.width * 0.2, size.height * 0.55, Colors.white38, 12);
    _drawText(canvas, "Pondok Indah", size.width * 0.25, size.height * 0.25, Colors.white38, 12);
    
    // Label Ikon Kopi (Meniru Starbucks di gambar)
    _drawText(canvas, "Starbucks", size.width * 0.38, size.height * 0.485, Colors.white70, 11);
    canvas.drawCircle(Offset(size.width * 0.34, size.height * 0.495), 9, Paint()..color = Colors.brown[700]!);
    canvas.drawCircle(Offset(size.width * 0.34, size.height * 0.495), 3, Paint()..color = Colors.white);

    // 5. MENGGAMBAR RUTE LARRI (ORANGE MENYALA)
    double cx = size.width * 0.55;
    double cy = size.height * 0.44;

    final path = Path();
    path.moveTo(cx, cy); // Dimulai dari Titik Biru
    path.lineTo(cx - 20, cy + 50); 
    path.lineTo(cx - 50, cy + 50); // Area West Cilandak / Starbucks
    path.lineTo(cx - 55, cy + 110);
    path.lineTo(cx - 120, cy + 120); 
    path.lineTo(cx - 160, cy + 80);
    path.lineTo(cx - 110, cy - 30);
    path.lineTo(cx - 40, cy + 10);
    path.lineTo(cx, cy); // Tutup
    
    // Rute tambahan menyerupai kerumitan di gambar
    path.moveTo(cx - 55, cy + 110);
    path.lineTo(cx - 20, cy + 105);
    path.lineTo(cx - 30, cy + 170);
    path.lineTo(cx - 80, cy + 180);
    path.lineTo(cx - 95, cy + 135);

    // Efek Cahaya / Glow
    final glowPaint = Paint()
      ..color = const Color(0xFFFF5722).withOpacity(0.25)
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Inti Garis
    final routePaint = Paint()
      ..color = const Color(0xFFFF5722)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, routePaint);
  }

  void _drawText(Canvas canvas, String text, double x, double y, Color color, double size) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: size, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}