// lib/models/testimonial.dart
class Testimonial {
  final int id;
  final String name;
  final String role;
  final String message;
  final String avatar;
  final int rating;
  final String? date;

  Testimonial({
    required this.id,
    required this.name,
    required this.role,
    required this.message,
    required this.avatar,
    required this.rating,
    this.date,
  });

  factory Testimonial.fromJson(Map<String, dynamic> j) {
    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      final s = v.toString();
      return int.tryParse(s) ?? 0;
    }

    return Testimonial(
      id: parseInt(j['id']),
      name: (j['name'] ?? '') as String,
      role: (j['role'] ?? '') as String,
      message: (j['message'] ?? '') as String,
      avatar: (j['avatar'] ?? '') as String,
      rating: parseInt(j['rating']),
      date: j['date']?.toString(),
    );
  }
}
