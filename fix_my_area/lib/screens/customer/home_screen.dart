import 'dart:async';
import 'package:fix_my_area/models/user_model.dart';
import 'package:fix_my_area/screens/customer/provider_profile_screen.dart';
import 'package:fix_my_area/screens/customer/service_providers_screen.dart';
import 'package:fix_my_area/services/auth_service.dart';
import 'package:fix_my_area/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final LocationService _locationService = LocationService();
  final Completer<GoogleMapController> _mapController = Completer();

  Future<UserModel?>? _userDetailsFuture;
  Set<Marker> _mapMarkers = {};
  CameraPosition _initialCameraPosition =
      const CameraPosition(target: LatLng(-1.9441, 30.0619), zoom: 13);

  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredCategories = [];

  final List<Map<String, dynamic>> _allServiceCategories = [
    {'name': 'Plumbing', 'icon': Icons.plumbing},
    {'name': 'Electrical', 'icon': Icons.electrical_services},
    {'name': 'Cleaning', 'icon': Icons.cleaning_services},
    {'name': 'Tutoring', 'icon': Icons.school},
    {'name': 'Painting', 'icon': Icons.format_paint},
    {'name': 'Moving', 'icon': Icons.local_shipping},
  ];

  @override
  void initState() {
    super.initState();
    _userDetailsFuture = _authService.getUserDetails();
    _filteredCategories = _allServiceCategories;
    _loadMapData();
  }

  void _filterServices(String query) {
    setState(() {
      _searchQuery = query;
      _filteredCategories = query.isEmpty
          ? _allServiceCategories
          : _allServiceCategories
              .where((c) =>
                  c['name'].toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  Future<void> _loadMapData() async {
    // Get user's current location
    Position? currentPosition = await _locationService.getCurrentPosition();
    if (currentPosition != null && mounted) {
      setState(() {
        _initialCameraPosition = CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 14.0,
        );
      });
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(_initialCameraPosition),
      );
    }

    // Load real provider markers
    final providers = await _authService.getAllProviders();
    final Set<Marker> markers = {};
    for (final provider in providers) {
      if (provider.location != null) {
        markers.add(
          Marker(
            markerId: MarkerId(provider.uid),
            position: LatLng(
              provider.location!.latitude,
              provider.location!.longitude,
            ),
            infoWindow: InfoWindow(
              title: provider.name,
              snippet: 'Tap to view profile',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProviderProfileScreen(provider: provider),
                ),
              ),
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),
          ),
        );
      }
    }

    if (mounted) {
      setState(() => _mapMarkers = markers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        FutureBuilder<UserModel?>(
          future: _userDetailsFuture,
          builder: (context, snapshot) {
            return Text(
              'Hi, ${snapshot.data?.name ?? '...'} 👋',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          'What service do you need today?',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        TextField(
          onChanged: _filterServices,
          decoration: InputDecoration(
            hintText: 'Search for a service...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: _filteredCategories.length,
          itemBuilder: (context, index) {
            final category = _filteredCategories[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ServiceProvidersScreen(categoryName: category['name']),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                        )
                      ],
                    ),
                    child: Icon(
                      category['icon'],
                      size: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['name'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        _buildMapPreview(),
      ],
    );
  }

  Widget _buildMapPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Providers Near You',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                }
              },
              markers: _mapMarkers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
            ),
          ),
        ),
      ],
    );
  }
}
