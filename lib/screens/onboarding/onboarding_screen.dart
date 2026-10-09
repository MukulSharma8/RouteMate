
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  final List<String> titles = [
    'Add all your stops',
    'We find the best order',
    'Go with one tap',
  ];

  final List<String> descriptions = [
    'Search real places and line up every errand, meeting or sight in one trip.',
    'RouteMate reorders your stops to save time, distance and fuel.',
    'Review distance and time, then hand off to Google Maps to navigate.',
  ];

  final List<IconData> icons = [
    Icons.location_on_outlined,
    Icons.alt_route,
    Icons.navigation_outlined,
  ];

  void nextPage() {
    if (currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to your home screen here.
    }
  }

  void skipOnboarding() {
    // Navigate to your home screen here.
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: skipOnboarding,
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Color(0xFF0F172A)),
                ),
              ),
            ),

            // Onboarding pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: titles.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Route illustration placeholder
                              Container(
                                width: double.infinity,
                                height: constraints.maxHeight * 0.43,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE4EFFF),
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.route,
                                    size: 90,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 40),

                              // Feature icon
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE4EFFF),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  icons[index],
                                  color: const Color(0xFF2563EB),
                                  size: 26,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Title
                              Text(
                                titles[index],
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Description
                              Text(
                                descriptions[index],
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            // Page indicators and button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              child: Row(
                children: [
                  // Page indicators
                  Expanded(
                    child: Row(
                      children: List.generate(
                        3,
                            (index) => Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? const Color(0xFF2563EB)
                                : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Next button
                  ElevatedButton(
                    onPressed: nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      currentPage == 2 ? 'Get started' : 'Next',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
