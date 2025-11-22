// lib/widgets/destinations_section.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/destination.dart';
import '../services/api_service.dart';

class DestinationsSection extends StatelessWidget {
  final List<Destination> destinations;
  const DestinationsSection({super.key, required this.destinations});

  // Adjust this when running on a real device (use your PC's LAN IP).
  String get _mobileDefaultBase => 'http://10.0.2.2:3000'; // Android emulator

  @override
  Widget build(BuildContext context) {
    final baseForImages = kIsWeb ? 'http://localhost:3000' : _mobileDefaultBase;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Top Destinations',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          TextButton(onPressed: () {}, child: const Text('See all'))
        ]),
        const SizedBox(height: 8),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: destinations.length,
            itemBuilder: (context, i) {
              final d = destinations[i];

              // Raw value from your JSON
              final raw = d.image ?? '';

              // Debug print original image field
              // ignore: avoid_print
              print('▶ d.image for ${d.city}: "$raw"');

              // Decide how to render:
              // 1) If path is an app asset (starts with 'assets/'), use Image.asset
              final isAsset = raw.startsWith('assets/');

              // 2) If path is an absolute URL (http/https) or server-root path (/images/...), use ApiService.imageUrl resolution
              final looksLikeNetwork = raw.startsWith('http://') ||
                  raw.startsWith('https://') ||
                  raw.startsWith('/');

              // 3) Otherwise treat as filename or relative path and resolve with ApiService
              final resolvedForNetwork = isAsset
                  ? ''
                  : ApiService.imageUrl(
                // If JSON gives a full URL use it; ApiService will return normalized form.
                raw,
                baseUrlForStatic: baseForImages,
              );

              // Debug print resolved url or asset path
              // ignore: avoid_print
              print('▶ Resolved image for ${d.city}: "${isAsset ? raw : resolvedForNetwork}"');

              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: SizedBox(
                          height: 140,
                          width: double.infinity,
                          child: isAsset
                              ? _buildAssetImage(raw)
                              : _buildNetworkImage(resolvedForNetwork),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.city, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(d.duration, style: const TextStyle(color: Colors.grey)),
                              Text(d.price, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                            ]),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildAssetImage(String assetPath) {
    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // ignore: avoid_print
        print('Asset image error for $assetPath -> $error');
        return _placeholder();
      },
    );
  }

  Widget _buildNetworkImage(String imageUrl) {
    // If ApiService returned empty string, show placeholder fallback
    final fallbackPlaceholder = 'https://via.placeholder.com/400';
    final urlToUse = (imageUrl.isEmpty) ? fallbackPlaceholder : imageUrl;

    return CachedNetworkImage(
      imageUrl: urlToUse,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
          child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator())),
      errorWidget: (context, url, error) {
        // ignore: avoid_print
        print('Network image load error for $url -> $error');
        return _placeholder();
      },
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.broken_image, size: 36, color: Colors.grey),
      ),
    );
  }
}
