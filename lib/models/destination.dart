// lib/models/destination.dart
class Destination {
  final int id;
  final String city;
  final String price;
  final String duration;
  final String image;

  Destination({
    required this.id,
    required this.city,
    required this.price,
    required this.duration,
    required this.image,
  });

  factory Destination.fromJson(Map<String, dynamic> j) {
    // parse id robustly (int, double, or numeric string)
    int parseId(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      final s = v.toString();
      return int.tryParse(s) ?? 0;
    }

    return Destination(
      id: parseId(j['id']),
      city: (j['city'] ?? '') as String,
      price: (j['price'] ?? '') as String,
      duration: (j['duration'] ?? '') as String,
      image: (j['image'] ?? '') as String,
    );
  }
}
