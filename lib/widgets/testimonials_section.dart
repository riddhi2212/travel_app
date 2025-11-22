import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/testimonial.dart';
import '../services/api_service.dart';

class TestimonialsSection extends StatefulWidget {
  final List<Testimonial> testimonials;
  const TestimonialsSection({super.key, required this.testimonials});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  late final PageController _controller;
  late Timer _timer;
  int _idx = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.95, initialPage: 0);
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_idx + 1) % widget.testimonials.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.testimonials;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Testimonials',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),

        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: list.length,
            onPageChanged: (i) => setState(() => _idx = i),
            itemBuilder: (context, i) {
              final t = list[i];

              // Detect asset vs network
              final String raw = t.avatar ?? '';
              final bool isAsset = raw.startsWith('assets/');
              final String networkUrl = isAsset ? '' : ApiService.imageUrl(raw);

              ImageProvider? avatarProvider;

              if (isAsset) {
                avatarProvider = AssetImage(raw);
              } else if (networkUrl.isNotEmpty) {
                avatarProvider = NetworkImage(networkUrl);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: avatarProvider,
                          onBackgroundImageError: (error, stackTrace) {
                            // ignore: avoid_print
                            print("Avatar load failed: $error");
                          },
                          child: avatarProvider == null
                              ? const Icon(Icons.person,
                              size: 30, color: Colors.grey)
                              : null,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(t.role,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 8),
                              Text(t.message,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis),

                              const Spacer(),

                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  RatingBarIndicator(
                                    rating: t.rating.toDouble(),
                                    itemBuilder: (context, index) =>
                                    const Icon(Icons.star,
                                        color: Colors.amber),
                                    itemCount: 5,
                                    itemSize: 14,
                                  ),
                                  Text(t.date ?? '',
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey)),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(list.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _idx == i ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                _idx == i ? const Color(0xFF5E6282) : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }),
        ),
      ],
    );
  }
}
