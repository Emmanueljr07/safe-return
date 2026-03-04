import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart'
    show placemarkFromCoordinates, Placemark;
import 'package:url_launcher/url_launcher.dart';

class LastSeenLocation extends StatefulWidget {
  const LastSeenLocation({
    super.key,
    required this.screenHeight,
    required this.onLocationPicked,
  });

  final double screenHeight;
  final void Function(double lat, double lng, String address)? onLocationPicked;
  @override
  State<LastSeenLocation> createState() => _LastSeenLocationState();
}

class _LastSeenLocationState extends State<LastSeenLocation> {
  String currentLocation = '2491 Mission St, San Francisco';

  // Placeholder height, adjust as needed
  LocationData? _pickedLocation;

  var _isGettingLocation = false;

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    // Get current location
    locationData = await location.getLocation();

    setState(() {
      _isGettingLocation = false;
    });

    debugPrint(locationData.latitude.toString());
    debugPrint(locationData.longitude.toString());

    // Update state with picked location
    setState(() {
      _pickedLocation = locationData;
    });

    // Get address from coordinates
    String address = await getAddressFromLatLng(
      locationData.latitude!,
      locationData.longitude!,
    );
    debugPrint(address);

    // update current location text
    setState(() {
      currentLocation = address;
    });

    // Send picked location back to parent widget
    if (_pickedLocation != null) {
      widget.onLocationPicked!(
        locationData.latitude!,
        locationData.longitude!,
        address,
      );
    }
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];

      return "${place.street}, ${place.locality}, ${place.country}";
    } catch (e) {
      return "Could not find address";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Last seen location
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Last Known Location',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            _isGettingLocation
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : TextButton.icon(
                    onPressed: () {
                      // Handle use current location
                      _getCurrentLocation();
                    },
                    icon: const Icon(Icons.my_location, size: 16),
                    label: const Text('Use Current'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                  ),
          ],
        ),
        const SizedBox(height: 8),

        // Map placeholder with pin icon
        if (_pickedLocation == null)
          Container(
            width: double.infinity,
            height: widget.screenHeight * 0.15,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Map placeholder
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // Pin icon
                const Icon(Icons.location_on, color: Colors.blue, size: 48),
              ],
            ),
          ),

        // Map with marker if location is picked
        if (_pickedLocation != null)
          Container(
            width: double.infinity,
            height: widget.screenHeight * 0.15,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  _pickedLocation!.latitude ?? 51.509364,
                  _pickedLocation!.longitude ?? -0.128928,
                ),
                initialZoom: 18.0,
              ),
              children: [
                TileLayer(
                  // This loads the actual map images
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.karu',
                ),
                RichAttributionWidget(
                  showFlutterMapAttribution: false,
                  // Include a stylish prebuilt attribution widget that meets all requirments
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(
                        Uri.parse('https://openstreetmap.org/copyright'),
                      ), // (external)
                    ),
                    // Also add images...
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        _pickedLocation!.latitude ?? 0,
                        _pickedLocation!.longitude ?? 0,
                      ),
                      width: 80,
                      height: 80,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),

        // Current location text with change button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              const Icon(Icons.navigation, color: Colors.grey, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  currentLocation,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle change location
                },
                child: const Text(
                  'Change',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}
