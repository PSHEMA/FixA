import 'dart:async';
import 'package:fix_my_area/models/user_model.dart';
import 'package:fix_my_area/screens/customer/service_providers_screen.dart';
import 'package:fix_my_area/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  Future<UserModel?>? _userDetailsFuture;
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredCategories = [];

  // Map state
  final Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> _mapMarkers = {};
  static const CameraPosition _kigaliPosition = CameraPosition(
    target: LatLng(-1.9441, 30.0619), // Center of Kigali
    zoom: 13.0,
  );

  final List<Map<String, dynamic>> _allServiceCategories = [
    {'name': 'Plumbing', 'icon': Icons.plumbing}, {'name': 'Electrical', 'icon': Icons.electrical_services},
    {'name': 'Cleaning', 'icon': Icons.cleaning_services}, {'name': 'Tutoring', 'icon': Icons.school},
    {'name': 'Painting', 'icon': Icons.format_paint}, {'name': 'Moving', 'icon': Icons.local_shipping},
  ];

  @override
  void initState() {
    super.initState();
    _userDetailsFuture = _authService.getUserDetails();
    _filteredCategories = _allServiceCategories;
    _loadProviderMarkers();
  }

  void _filterServices(String query) {
    setState(() {
      _searchQuery = query;
      _filteredCategories = query.isEmpty
          ? _allServiceCategories
          : _allServiceCategories.where((c) => c['name'].toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  Future<void> _loadProviderMarkers() async {
    final providers = await _authService.getAllProviders();
    final Set<Marker> markers = {};
    // This is a placeholder for real coordinates. We'll add random locations around Kigali.
    for (var i = 0; i < providers.length; i++) {
      final provider = providers[i];
      final marker = Marker(
        markerId: MarkerId(provider.uid),
        position: LatLng(
          -1.9441 + (i * 0.01) - 0.05, // Placeholder coordinates
          30.0619 + (i * 0.01) - 0.05,
        ),
        infoWindow: InfoWindow(
          title: provider.name,
          snippet: provider.services.join(', '),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
      markers.add(marker);
    }
    setState(() {
      _mapMarkers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        FutureBuilder<UserModel?>(
          future: _userDetailsFuture,
          builder: (context, snapshot) {
            return Text('Hi, ${snapshot.data?.name ?? '...'} 👋', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold));
          },
        ),
        const SizedBox(height: 8),
        Text('What service do you need today?', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600])),
        const SizedBox(height: 24),
        TextField(onChanged: _filterServices, decoration: InputDecoration(hintText: 'Search for a service...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), filled: true, fillColor: Colors.grey[200])),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.9),
          itemCount: _filteredCategories.length,
          itemBuilder: (context, index) {
            final category = _filteredCategories[index];
            return GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceProvidersScreen(categoryName: category['name']))),
              child: Column(children: [
                Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 5)]), child: Icon(category['icon'], size: 32, color: Theme.of(context).primaryColor)),
                const SizedBox(height: 8),
                Text(category['name'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
              ]),
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
        Text('Providers Near You', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kigaliPosition,
              onMapCreated: (GoogleMapController controller) {
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                }
              },
              markers: _mapMarkers,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
            ),
          ),
        ),
      ],
    );
  }
}

