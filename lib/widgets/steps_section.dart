import 'package:flutter/material.dart';

class StepsSection extends StatelessWidget {
  const StepsSection({super.key});

  Widget step(String label, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(radius: 26, backgroundColor: const Color(0xFFEEF2FF), child: Icon(icon, color: const Color(0xFF5E6282))),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('How it works', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(children: [
          step('Choose', Icons.search),
          step('Book', Icons.payment),
          step('Enjoy', Icons.flight_takeoff),
        ]),
      ],
    );
  }
}
