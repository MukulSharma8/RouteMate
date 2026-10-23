import 'dart:convert';

import 'package:http/http.dart' as http;

class PlacesService {
  final String apiKey;

  PlacesService({required this.apiKey});

  Future<List<Map<String, dynamic>>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required String placeType,
  }) async {
    final url = Uri.parse(
      'https://places.googleapis.com/v1/places:searchNearby',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': apiKey,
        'X-Goog-FieldMask':
        'places.id,'
            'places.displayName,'
            'places.formattedAddress,'
            'places.location,'
            'places.rating',
      },
      body: jsonEncode({
        'includedTypes': [placeType],
        'maxResultCount': 7,
        'rankPreference': 'DISTANCE',
        'locationRestriction': {
          'circle': {
            'center': {
              'latitude': latitude,
              'longitude': longitude,
            },
            'radius': 5000.0,
          },
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Places API failed: ${response.statusCode}\n${response.body}',
      );
    }

    final data = jsonDecode(response.body);

    return List<Map<String, dynamic>>.from(
      data['places'] ?? [],
    );
  }
}