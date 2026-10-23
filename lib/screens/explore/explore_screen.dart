import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routemate/core/constants/app_colors.dart';
import 'package:routemate/screens/home/home_screen.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../favourite/favourite_screen.dart';
import '../../services/places_service.dart';
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  LatLng? _currentLocation;
  Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.741482, 76.768066),
    zoom: 14.4746,
  );

  int selectedCategory = 0;
  final List<String> categories = [
    'Cafes',
    'Restaurants',
    'Hospitals',
    'ATMs',
  ];
  List<Map<String, dynamic>> nearbyPlaces = [];

  final PlacesService _placesService = PlacesService(
    apiKey: 'AIzaSyDr0d9_JB5LUPF233nup6aTnObQunKBpKQ',
  );
  Future<void> _loadNearbyPlaces() async {
    try {
      Position position = await getUserCurrentLocation();

      String placeType;

      switch (selectedCategory) {
        case 0:
          placeType = 'cafe';
          break;
        case 1:
          placeType = 'restaurant';
          break;
        case 2:
          placeType = 'hospital';
          break;
        case 3:
          placeType = 'atm';
          break;
        default:
          placeType = 'cafe';
      }

      print('Searching for: $placeType');
      print('Latitude: ${position.latitude}');
      print('Longitude: ${position.longitude}');

      final places = await _placesService.getNearbyPlaces(
        latitude: position.latitude,
        longitude: position.longitude,
        placeType: placeType,
      );

      print('Google returned ${places.length} places');

      final List<Map<String, dynamic>> formattedPlaces = [];

      for (final place in places) {
        final location = place['location'];

        double? distance;

        if (location != null) {
          final double placeLatitude =
          (location['latitude'] as num).toDouble();

          final double placeLongitude =
          (location['longitude'] as num).toDouble();

          distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            placeLatitude,
            placeLongitude,
          );
        }

        formattedPlaces.add({
          'name': place['displayName']?['text']?.toString()
              ?? 'Unknown place',

          'address': place['formattedAddress']?.toString()
              ?? 'Address unavailable',

          'rating': place['rating']?.toString()
              ?? 'N/A',

          'distance': distance != null
              ? '${(distance / 1000).toStringAsFixed(1)} km'
              : '',
        });
      }

      if (!mounted) return;

      setState(() {
        nearbyPlaces = formattedPlaces;
      });

    } catch (e) {
      print('ERROR loading nearby places: $e');

      if (!mounted) return;

      setState(() {
        nearbyPlaces = [];
      });
    }
  }
  Future<Position> getUserCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check whether location service is turned on
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check current permission
    permission = await Geolocator.checkPermission();

    // Ask for permission if not already granted
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    // Permission permanently denied
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied.');
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
  @override
  void initState() {
    super.initState();
    _loadNearbyPlaces();
  }
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
    return Stack(
      children:[ GoogleMap(
        initialCameraPosition: _kGooglePlex,
        mapType: MapType.normal,
        myLocationEnabled: true,
        compassEnabled: true,
        onMapCreated: (GoogleMapController mapcontroller){
          _controller.complete(mapcontroller);
        },
      ),
        Positioned(
          left: 100,
            top: 300,
            child: FloatingActionButton(
              onPressed: () async {
                print("Location button clicked");

                Position position = await getUserCurrentLocation();

                print("Latitude: ${position.latitude}");
                print("Longitude: ${position.longitude}");

                GoogleMapController mapController =
                await _controller.future;

                print("Map controller ready");

                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(
                        position.latitude,
                        position.longitude,
                      ),
                      zoom: 16,
                    ),
                  ),
                );

                print("Camera moved");
              },
              child: const Icon(Icons.location_history),
            ))
      ],
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
              onTap: () async {
                setState(() {
                  selectedCategory = index;
                });

                await _loadNearbyPlaces();
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${nearbyPlaces.length} places found',
                  style: const TextStyle(
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

  Widget _buildPlaceCard(Map<String, dynamic> place) {
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
              Icons.place_outlined,
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
                  place['name'] ?? 'Unknown place',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  place['address'] ?? 'Address unavailable',
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
                      place['rating'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(width: 9),

                    Text(
                      place['distance'] ?? '',
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