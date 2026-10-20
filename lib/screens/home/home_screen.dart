import 'package:flutter/material.dart';
import 'package:routemate/core/constants/app_colors.dart';
import 'package:routemate/screens/explore/explore_screen.dart';
import 'package:routemate/screens/favourite/favourite_screen.dart';
import 'package:routemate/screens/place/place_details_screen.dart';

import '../../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Cafes',
      'icon': Icons.coffee_outlined,
    },
    {
      'name': 'Restaurants',
      'icon': Icons.restaurant_outlined,
    },
    {
      'name': 'Hospitals',
      'icon': Icons.local_hospital_outlined,
    },
    {
      'name': 'ATMs',
      'icon': Icons.account_balance_outlined,
    },
    {
      'name': 'Petrol Pumps',
      'icon': Icons.local_gas_station_outlined,
    },
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
    }, {
      'name': 'IndianOilPetrolPump',
      'address': 'Aurobindo Marg',
      'rating': '4.0',
      'distance': '0.7 km',
    }, {
      'name': 'Cafe Lota',
      'address': 'Pragati Maidan',
      'rating': '4.5',
      'distance': '0.7 km',
    }, {
      'name': 'Bukhara',
      'address': 'ITC Maurya, Chanakyapuri',
      'rating': '4.7',
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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 18),
                  _buildSearchBar(),
                  const SizedBox(height: 18),
                  _buildCategories(),
                  const SizedBox(height: 18),
                  _buildPlanRouteCard(),
                  const SizedBox(height: 18),
                  _buildNearbyTitle(),
                  const SizedBox(height: 10),
                  _buildNearbyPlaces(),
                ],
              ),
            ),
            BottomNavBar(
              selectedIndex: 0,
              onItemSelected: (index) {
                if (index == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExploreScreen(),
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
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.gradientStart,
                AppColors.gradientEnd,
              ],
            ),
          ),
          child: const Icon(
            Icons.route,
            color: AppColors.white,
            size: 23,
          ),
        ),

        const SizedBox(width: 9),

        const Text(
          'Route Mate',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const Spacer(),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Current location',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
            Row(
              children: const [
                Icon(
                  Icons.location_on_outlined,
                  size: 13,
                  color: AppColors.primary,
                ),
                SizedBox(width: 2),
                Text(
                  'Lodhi Colony, Delhi',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // SEARCH BAR
  // ------------------------------------------------------------

  Widget _buildSearchBar() {
    return Container(
      height: 43,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search cafes, ATMs, hospitals...',
          hintStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: AppColors.textPrimary,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 11,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // CATEGORIES
  // ------------------------------------------------------------

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 10),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 14),
                child: _buildCategoryItem(
                  category['name'],
                  category['icon'],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String name, IconData icon) {
    return SizedBox(
      width: 52,
      child: Column(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 21,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PLAN A ROUTE CARD
  // ------------------------------------------------------------

  Widget _buildPlanRouteCard() {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        gradient: const LinearGradient(
          colors: [
            AppColors.gradientStart,
            AppColors.gradientEnd,
          ],
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Plan a Route',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Get directions to any place nearby',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.navigation_outlined,
              color: AppColors.primary,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // NEARBY TITLE
  // ------------------------------------------------------------

  Widget _buildNearbyTitle() {
    return Row(
      children: [
        const Text(
          'Nearby places',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const Spacer(),

        GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
          child: const Text(
            'View map',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // NEARBY PLACES
  // ------------------------------------------------------------

  Widget _buildNearbyPlaces() {
    return Column(
      children: nearbyPlaces.map((place) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PlaceDetailsScreen(
                        placeName: place['name']!,
                        address: place['address']!,
                        rating: place['rating']!,
                        distance: place['distance']!,
                        category: 'Cafes',
                      ),
                ),
              );
            },
            child: _buildPlaceCard(place),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPlaceCard(Map<String, String> place) {
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
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.place_outlined,
              color: AppColors.primary,
              size: 21,
            ),
          ),

          const SizedBox(width: 11),

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
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
        ],
      ),
    );
  }
}