import 'dart:async';
import 'package:proci/models/user_model.dart';
import 'package:proci/screens/customer/provider_profile_screen.dart';
import 'package:proci/screens/customer/service_providers_screen.dart';
import 'package:proci/services/auth_service.dart';
import 'package:proci/services/location_service.dart';
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
  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(-1.9441, 30.0619), 
    zoom: 12
  );

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
    // Load both user location and provider markers
    _loadMapData();
  }

  Future<void> _loadMapData() async {
    // 1. Center map on user's current location
    Position? currentPosition = await _locationService.getCurrentPosition();
    if (currentPosition != null && mounted) {
      final newPosition = CameraPosition(
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: 14.0,
      );
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
      setState(() {
        _initialCameraPosition = newPosition;
      });
    }
    
    // 2. Load all providers and create markers for them
    final providers = await _authService.getAllProviders();
    final Set<Marker> markers = {};
    for (final provider in providers) {
      // Only create a marker if the provider has set their location
      if (provider.location != null) {
        markers.add(
          Marker(
            markerId: MarkerId(provider.uid),
            position: LatLng(provider.location!.latitude, provider.location!.longitude),
            infoWindow: InfoWindow(
              title: provider.name,
              snippet: 'Tap to view profile',
              onTap: () => Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (_) => ProviderProfileScreen(provider: provider)
                )
              )
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          )
        );
      }
    }
    if(mounted) setState(() => _mapMarkers = markers);
  }

  void _filterServices(String query) {
    setState(() {
      _filteredCategories = query.isEmpty
          ? _allServiceCategories
          : _allServiceCategories
              .where((c) => c['name'].toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  Widget _buildServiceCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceProvidersScreen(categoryName: category['name']),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                category['icon'],
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                category['name'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              FutureBuilder<UserModel?>(
                future: _userDetailsFuture,
                builder: (context, snapshot) {
                  return Text(
                    'Hi, ${snapshot.data?.name ?? '...'} 👋',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                'What service do you need today?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: _filterServices,
                  decoration: InputDecoration(
                    hintText: 'Search for a service...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Services Section
              Text(
                'Popular Services',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: _filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = _filteredCategories[index];
                  return _buildServiceCard(category);
                },
              ),
              const SizedBox(height: 32),

              // Map Section with Provider Markers
              Text(
                'Providers Near You',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
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
                    // THE PAYOFF: The map now displays all the provider markers
                    markers: _mapMarkers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}