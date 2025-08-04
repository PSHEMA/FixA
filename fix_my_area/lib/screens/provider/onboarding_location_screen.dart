import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proci/screens/provider/main_scaffold_provider.dart';
import 'package:proci/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OnboardingLocationScreen extends StatefulWidget {
  const OnboardingLocationScreen({super.key});

  @override
  State<OnboardingLocationScreen> createState() => _OnboardingLocationScreenState();
}

class _OnboardingLocationScreenState extends State<OnboardingLocationScreen> {
  // Map Location Variables
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _pickedLocation;
  static const CameraPosition _kigaliPosition = CameraPosition(
    target: LatLng(-1.9441, 30.0619), 
    zoom: 12.0
  );

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  Future<void> _finishOnboarding() async {
    // Validate map selection
    if (_pickedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please tap on the map to set your business location.'))
      );
      return;
    }
    
    // Save precise GeoPoint location
    await AuthService().updateUserProfile({
      'location': GeoPoint(_pickedLocation!.latitude, _pickedLocation!.longitude)
    });

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainScaffoldProvider()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 2: Business Location'),
      ),
      body: Column(
        children: [
          // Information Banner
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                Icon(
                  Icons.place,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Tap on the map to place a pin on your precise business location. This will help customers find you.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          
          // Map Area
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _kigaliPosition,
              onMapCreated: (controller) => _mapController.complete(controller),
              onTap: _selectLocation,
              markers: _pickedLocation == null 
                  ? {} 
                  : {
                      Marker(
                        markerId: const MarkerId('business_location'),
                        position: _pickedLocation!,
                        infoWindow: const InfoWindow(title: 'Your Business Location'),
                      )
                    },
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapToolbarEnabled: false,
            ),
          ),
          
          // Finish Setup Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Finish Setup'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _finishOnboarding,
            ),
          ),
        ],
      ),
    );
  }
}