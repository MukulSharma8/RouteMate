import 'package:flutter/material.dart';
import 'package:routemate/core/constants/app_colors.dart';
import 'package:routemate/screens/home/home_screen.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../favourite/favourite_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int selectedCategory = 0;

  final List<String> categories = [
    'Cafes',
    'Restaurants',
    'Hospitals',
    'ATMs',
  ];

  final List<Map<String, String>> nearbyPlaces = [
    {
      'name': 'Blue Tokai Coffee',
      'address': '14 Khan Market, New Delhi',
      'rating': '4.6',
      'distance': '0.4 km',
    },
    {
      'name': 'Saravana Bhavan',
      'address': '46 Janpath, Connaught Place',
      'rating': '4.4',
      'distance': '1.2 km',
    },
    {
      'name': 'AIIMS Hospital',
      'address': 'Ansari Nagar East, New Delhi',
      'rating': '4.2',
      'distance': '2.8 km',
    },
    {
      'name': 'HDFC Bank ATM',
      'address': 'Lodhi Road, Pragati Vihar',
      'rating': '4.0',
      'distance': '0.7 km',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Map
            Expanded(
              child: Stack(
                children: [
                  _buildMap(),

                  _buildSearchBar(),

                  _buildCategoryFilters(),

                  _buildCurrentLocationButton(),

                  _buildPlacesSheet(),
                ],
              ),
            ),
            BottomNavBar(
              selectedIndex: 1,
              onItemSelected: (index) {
                if (index == 0) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                }if (index == 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavouritesScreen(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // MAP
  // ------------------------------------------------------------

  Widget _buildMap() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: ExploreMapPainter(),
      ),
    );
  }

  // ------------------------------------------------------------
  // SEARCH BAR
  // ------------------------------------------------------------

  Widget _buildSearchBar() {
    return Positioned(
      top: 14,
      left: 14,
      right: 14,
      child: Container(
        height: 43,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search on map',
            hintStyle: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 19,
              color: AppColors.textPrimary,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: 11,
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // CATEGORY FILTERS
  // ------------------------------------------------------------

  Widget _buildCategoryFilters() {
    return Positioned(
      top: 67,
      left: 14,
      right: 14,
      child: SizedBox(
        height: 34,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 7),
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                ),
                decoration: BoxDecoration(
                  color: selectedCategory == index
                      ? AppColors.lightBlue
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getCategoryIcon(index),
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      categories[index],
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getCategoryIcon(int index) {
    switch (index) {
      case 0:
        return Icons.coffee_outlined;
      case 1:
        return Icons.restaurant_outlined;
      case 2:
        return Icons.local_hospital_outlined;
      case 3:
        return Icons.account_balance_outlined;
      default:
        return Icons.place_outlined;
    }
  }

  // ------------------------------------------------------------
  // CURRENT LOCATION BUTTON
  // ------------------------------------------------------------

  Widget _buildCurrentLocationButton() {
    return Positioned(
      right: 16,
      bottom: 195,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.my_location,
            color: AppColors.primary,
            size: 20,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // PLACES BOTTOM SHEET
  // ------------------------------------------------------------

  Widget _buildPlacesSheet() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 300,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Small handle
            Container(
              width: 36,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(5),
              ),
            ),

            const SizedBox(height: 10),

            // Places count
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '7 places found',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  14,
                  0,
                  14,
                  10,
                ),
                itemCount: nearbyPlaces.length,
                itemBuilder: (context, index) {
                  return _buildPlaceCard(
                    nearbyPlaces[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // PLACE CARD
  // ------------------------------------------------------------

  Widget _buildPlaceCard(Map<String, String> place) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.coffee_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place['name']!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  place['address']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 13,
                      color: AppColors.primary,
                    ),

                    const SizedBox(width: 3),

                    Text(
                      place['rating']!,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(width: 9),

                    Text(
                      place['distance']!,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BOTTOM NAVIGATION
  // ------------------------------------------------------------

  Widget _buildBottomNavigation() {
    return Container(
      height: 61,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.home_outlined,
            label: 'Home',
            selected: false,
          ),
          _buildNavItem(
            icon: Icons.map_outlined,
            label: 'Explore',
            selected: true,
          ),
          _buildNavItem(
            icon: Icons.favorite_border,
            label: 'Favourites',
            selected: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool selected,
  }) {
    return Container(
      width: 70,
      height: 48,
      decoration: BoxDecoration(
        color: selected
            ? AppColors.lightBlue
            : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 19,
            color: AppColors.primary,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// SIMPLE MAP PAINTER
// ------------------------------------------------------------

class ExploreMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = const Color(0xFFEAF2EE);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Water
    final waterPaint = Paint()
      ..color = const Color(0xFFAEDCF0);

    final waterPath = Path();

    waterPath.moveTo(size.width * 0.72, 0);
    waterPath.lineTo(size.width, 0);
    waterPath.lineTo(size.width, size.height * 0.48);
    waterPath.cubicTo(
      size.width * 0.88,
      size.height * 0.45,
      size.width * 0.75,
      size.height * 0.40,
      size.width * 0.70,
      size.height * 0.28,
    );
    waterPath.close();

    canvas.drawPath(waterPath, waterPaint);

    // Roads
    final roadPaint = Paint()
      ..color = AppColors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Horizontal roads
    canvas.drawLine(
      Offset(0, size.height * 0.16),
      Offset(size.width, size.height * 0.16),
      roadPaint,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.35),
      Offset(size.width, size.height * 0.35),
      roadPaint,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.58),
      Offset(size.width, size.height * 0.58),
      roadPaint,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.78),
      Offset(size.width, size.height * 0.78),
      roadPaint,
    );

    // Vertical roads
    canvas.drawLine(
      Offset(size.width * 0.18, 0),
      Offset(size.width * 0.22, size.height),
      roadPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.42, 0),
      Offset(size.width * 0.44, size.height),
      roadPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.65, 0),
      Offset(size.width * 0.67, size.height),
      roadPaint,
    );

    // Place markers
    _drawMarker(
      canvas,
      Offset(size.width * 0.30, size.height * 0.31),
      Icons.coffee_outlined,
    );

    _drawMarker(
      canvas,
      Offset(size.width * 0.16, size.height * 0.50),
      Icons.restaurant_outlined,
    );

    _drawMarker(
      canvas,
      Offset(size.width * 0.47, size.height * 0.55),
      Icons.coffee_outlined,
    );

    _drawMarker(
      canvas,
      Offset(size.width * 0.70, size.height * 0.18),
      Icons.restaurant_outlined,
    );

    _drawMarker(
      canvas,
      Offset(size.width * 0.63, size.height * 0.83),
      Icons.account_balance_outlined,
    );

    // Current location
    final locationOuter = Paint()
      ..color = AppColors.lightBlue;

    final locationInner = Paint()
      ..color = AppColors.primary;

    canvas.drawCircle(
      Offset(size.width * 0.50, size.height * 0.48),
      18,
      locationOuter,
    );

    canvas.drawCircle(
      Offset(size.width * 0.50, size.height * 0.48),
      9,
      locationInner,
    );
  }

  void _drawMarker(
      Canvas canvas,
      Offset position,
      IconData icon,
      ) {
    final circlePaint = Paint()
      ..color = AppColors.primary;

    canvas.drawCircle(
      position,
      16,
      circlePaint,
    );

    final whitePaint = Paint()
      ..color = AppColors.white;

    canvas.drawCircle(
      position,
      16,
      whitePaint,
      // This only creates the white outer area.
    );

    final bluePaint = Paint()
      ..color = AppColors.primary;

    canvas.drawCircle(
      position,
      14,
      bluePaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return false;
  }
}