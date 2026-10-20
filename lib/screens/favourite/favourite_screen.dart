import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../home/home_screen.dart';
import '../explore/explore_screen.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final List<Map<String, String>> favourites = [
    {
      'name': 'Blue Tokai Coffee',
      'address': '14 Khan Market, New Delhi',
      'rating': '4.6',
      'distance': '0.4 km',
      'icon': 'cafe',
    },
    {
      'name': 'AIIMS Hospital',
      'address': 'Ansari Nagar East, New Delhi',
      'rating': '4.2',
      'distance': '2.8 km',
      'icon': 'hospital',
    },
    {
      'name': 'Bukhara',
      'address': 'ITC Maurya, Chanakyapuri',
      'rating': '4.7',
      'distance': '3.4 km',
      'icon': 'restaurant',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  20,
                  18,
                  16,
                ),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildFavouriteList(),
                ],
              ),
            ),

            BottomNavBar(
              selectedIndex: 2,
              onItemSelected: (index) {
                if (index == 0) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                }

                if (index == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExploreScreen(),
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
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Favourites',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${favourites.length} saved places',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // FAVOURITE LIST
  // ------------------------------------------------------------

  Widget _buildFavouriteList() {
    return Column(
      children: favourites.map((place) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildFavouriteCard(place),
        );
      }).toList(),
    );
  }

  // ------------------------------------------------------------
  // FAVOURITE CARD
  // ------------------------------------------------------------

  Widget _buildFavouriteCard(Map<String, String> place) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          // Place icon
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _getPlaceIcon(place['icon']!),
              color: AppColors.primary,
              size: 21,
            ),
          ),

          const SizedBox(width: 11),

          // Place information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place['name']!,
                  style: const TextStyle(
                    fontSize: 13,
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
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 14,
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

                    const SizedBox(width: 10),

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

          const SizedBox(width: 8),

          // Delete button
          GestureDetector(
            onTap: () {
              setState(() {
                favourites.remove(place);
              });
            },
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.lightGrey,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline,
                color: AppColors.error,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PLACE ICON
  // ------------------------------------------------------------

  IconData _getPlaceIcon(String type) {
    switch (type) {
      case 'cafe':
        return Icons.coffee_outlined;

      case 'hospital':
        return Icons.local_hospital_outlined;

      case 'restaurant':
        return Icons.restaurant_outlined;

      default:
        return Icons.place_outlined;
    }
  }
}