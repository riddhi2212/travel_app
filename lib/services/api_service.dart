// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/destination.dart';
import '../models/testimonial.dart';

class ApiService {
  /// Default base URL. IMPORTANT:
  /// - Web: use 'http://localhost:3000'
  /// - Android emulator: use 'http://10.0.2.2:3000'
  /// - Real device: use 'http://<YOUR_PC_IP>:3000'
  /// You can override by passing baseUrl to the constructor.
  static const String _defaultBase = 'http://localhost:3000';

  final Uri baseUri;
  final Duration _timeout;

  ApiService({String? baseUrl, Duration? timeout})
      : baseUri = Uri.parse(baseUrl ?? _defaultBase),
        _timeout = timeout ?? const Duration(seconds: 10);

  /// Helper to build endpoint Uri safely.
  Uri _endpoint(String path) {
    // path should be relative like 'destinations' or 'images/foo.jpg'
    return baseUri.resolve(path);
  }

  Future<List<Destination>> fetchDestinations() async {
    final uri = _endpoint('destinations');
    try {
      final r = await http.get(uri).timeout(_timeout);
      if (r.statusCode == 200) {
        final dynamic decoded = jsonDecode(r.body);
        if (decoded is List) {
          return decoded.map((e) => Destination.fromJson(e)).toList();
        } else {
          throw Exception('Unexpected JSON (not a List) from $uri');
        }
      } else {
        throw Exception('Failed to load destinations (${r.statusCode}): ${r.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Testimonial>> fetchTestimonials() async {
    final uri = _endpoint('testimonials');
    try {
      final r = await http.get(uri).timeout(_timeout);
      if (r.statusCode == 200) {
        final dynamic decoded = jsonDecode(r.body);
        if (decoded is List) {
          return decoded.map((e) => Testimonial.fromJson(e)).toList();
        } else {
          throw Exception('Unexpected JSON (not a List) from $uri');
        }
      } else {
        throw Exception('Failed to load testimonials (${r.statusCode}): ${r.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> subscribe(String email) async {
    final uri = _endpoint('subscribers');
    final payload = jsonEncode({'email': email});
    try {
      final r = await http
          .post(uri, headers: {'Content-Type': 'application/json'}, body: payload)
          .timeout(_timeout);
      return r.statusCode == 201;
    } catch (e) {
      rethrow;
    }
  }

  /// Safe image URL builder. NEVER throws.
  /// Returns empty string if path is null/empty or invalid.
  ///
  /// Behavior:
  ///  - If [path] is a full URL (starts with http/https) it returns that (normalized).
  ///  - If [path] starts with '/', resolves against baseUri (root).
  ///  - Otherwise resolves to 'images/<path>' (common server layout).
  static String imageUrl(String? path, {String? baseUrlForStatic}) {
    try {
      if (path == null) return '';
      final p = path.trim();
      if (p.isEmpty) return '';

      // If already absolute URL, validate and return normalized form
      if (p.startsWith('http://') || p.startsWith('https://')) {
        final parsed = Uri.tryParse(p);
        return parsed?.toString() ?? '';
      }

      // Determine baseUri to use for resolution
      final base = Uri.parse(baseUrlForStatic ?? _defaultBase);

      // If path starts with a leading slash, resolve from root
      if (p.startsWith('/')) {
        final resolved = base.resolve(p);
        return resolved.toString();
      }

      // Otherwise assume it's a filename under /images/
      final resolved = base.resolve('images/$p');
      return resolved.toString();
    } catch (e) {
      // ignore errors and return empty string
      // ignore: avoid_print
      print('ApiService.imageUrl error: $e');
      return '';
    }
  }
}
