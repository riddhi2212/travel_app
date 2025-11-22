import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/destination.dart';
import '../models/testimonial.dart';
import '../widgets/hero_section.dart';
import '../widgets/services_section.dart';
import '../widgets/destinations_section.dart';
import '../widgets/steps_section.dart';
import '../widgets/testimonials_section.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();
  late Future<List<Destination>> destF;
  late Future<List<Testimonial>> testiF;

  @override
  void initState() {
    super.initState();
    destF = api.fetchDestinations();
    testiF = api.fetchTestimonials();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              destF = api.fetchDestinations();
              testiF = api.fetchTestimonials();
            });
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeroSection(width: w),
                const SizedBox(height: 18),
                const ServicesSection(),
                const SizedBox(height: 18),
                // Destinations (API)
                FutureBuilder<List<Destination>>(
                  future: destF,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const SizedBox(height: 160, child: Center(child: CircularProgressIndicator()));
                    } else if (snap.hasError) {
                      return Container(height:160, alignment: Alignment.center, child: Text('Error: ${snap.error}'));
                    } else if (!snap.hasData || snap.data!.isEmpty) {
                      return const SizedBox(height:160, child: Center(child: Text('No destinations found')));
                    } else {
                      return DestinationsSection(destinations: snap.data!);
                    }
                  },
                ),
                const SizedBox(height: 18),
                const StepsSection(),
                const SizedBox(height: 18),
                FutureBuilder<List<Testimonial>>(
                  future: testiF,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const SizedBox(height: 180, child: Center(child: CircularProgressIndicator()));
                    } else if (snap.hasError) {
                      return Container(height:180, alignment: Alignment.center, child: Text('Error: ${snap.error}'));
                    } else if (!snap.hasData || snap.data!.isEmpty) {
                      return const SizedBox(height:180, child: Center(child: Text('No testimonials found')));
                    } else {
                      return TestimonialsSection(testimonials: snap.data!);
                    }
                  },
                ),
                const SizedBox(height: 22),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
