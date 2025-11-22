import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  final double width;
  const HeroSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    final titleSize = (width * 0.065).clamp(18.0, 28.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Background image (replace with asset if you want)
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Image.network(
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1200&auto=format&fit=crop&ixlib=rb-4.0.3&s=1a2b3c',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.25), Colors.black.withOpacity(0.05)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            left: 18,
            bottom: 20,
            right: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Explore the world\nwith comfort',
                    style: TextStyle(color: Colors.white, fontSize: titleSize, fontWeight: FontWeight.bold, height: 1.05)
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1A501),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Find your next trip', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
