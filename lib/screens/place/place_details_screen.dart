import 'package:flutter/material.dart';
import 'package:routemate/core/constants/app_colors.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final String placeName;
  final String address;
  final String rating;
  final String distance;
  final String category;

  const PlaceDetailsScreen({
    super.key,
    required this.placeName,
    required this.address,
    required this.rating,
    required this.distance,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildMapArea(context),
                    _buildPlaceInformation(),
                  ],
                ),
              ),
            ),

            _buildDirectionsButton(),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // MAP AREA
  // ------------------------------------------------------------

  Widget _buildMapArea(BuildContext context) {
    return SizedBox(
      height: 215,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.lightGrey,
            child: CustomPaint(
              painter: SimpleMapPainter(),
            ),
          ),

          // Back button
          Positioned(
            top: 14,
            left: 14,
            child: _buildCircleButton(
              icon: Icons.arrow_back_ios_new,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),

          // Favourite button
          Positioned(
            top: 14,
            right: 14,
            child: _buildCircleButton(
              icon: Icons.favorite,
              iconColor: AppColors.error,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Added to favourites'),
                  ),
                );
              },
            ),
          ),

          // Current location marker
          Positioned(
            top: 76,
            left: 174,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

          // Place marker
          Positioned(
            top: 32,
            left: 110,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.coffee_outlined,
                color: AppColors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // CIRCLE BUTTON
  // ------------------------------------------------------------

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = AppColors.textPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: iconColor,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // PLACE INFORMATION
  // ------------------------------------------------------------

  Widget _buildPlaceInformation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),

          // Category
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Place name
          Text(
            placeName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 4),

          // Address
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 15,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Rating and distance
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  title: 'Rating',
                  icon: Icons.star,
                  iconColor: AppColors.primary,
                  value: rating,
                  extraText: '(1,284)',
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _buildInfoCard(
                  title: 'Distance',
                  icon: Icons.navigation_outlined,
                  iconColor: AppColors.primary,
                  value: distance,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Opening time and phone
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.access_time_outlined,
                      size: 17,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Open · Closes 11 PM',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  children: const [
                    Icon(
                      Icons.phone_outlined,
                      size: 17,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '+91 114567 8901',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
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
  // INFORMATION CARD
  // ------------------------------------------------------------

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String value,
    String? extraText,
  }) {
    return Container(
      height: 64,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: iconColor,
              ),

              const SizedBox(width: 5),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              if (extraText != null) ...[
                const SizedBox(width: 4),
                Text(
                  extraText,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // GET DIRECTIONS BUTTON
  // ------------------------------------------------------------

  Widget _buildDirectionsButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
      child: SizedBox(
        width: double.infinity,
        height: 51,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.navigation_outlined,
            color: AppColors.white,
          ),
          label: const Text(
            'Get Directions',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// SIMPLE MAP PLACEHOLDER
// ------------------------------------------------------------

class SimpleMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = AppColors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Horizontal roads
    canvas.drawLine(
      Offset(0, size.height * 0.25),
      Offset(size.width, size.height * 0.25),
      roadPaint,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.52),
      Offset(size.width, size.height * 0.52),
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
      Offset(size.width * 0.45, size.height),
      roadPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.68, 0),
      Offset(size.width * 0.70, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}