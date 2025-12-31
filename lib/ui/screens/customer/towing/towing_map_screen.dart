import 'package:cheng_eng_3/ui/screens/customer/towing/towing_submit_screen.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:huawei_map/huawei_map.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class TowingMapScreen extends ConsumerStatefulWidget {
  const TowingMapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TowingMapScreenState();
}

class _TowingMapScreenState extends ConsumerState<TowingMapScreen> {
  final _addressCtrl = TextEditingController();
  // We keep coordinates in state, no need for UI controllers unless debugging
  double? _selectedLat;
  double? _selectedLng;

  bool _hasLocationPermission = false;
  HuaweiMapController? mapController;

  bool _gettingLocation = false;
  bool _isSearchingAddress = false;

  bool _isMapReady = false;

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    HuaweiMapInitializer.initializeMap();
    _checkLocationRequirements();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isMapReady = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    super.dispose();
  }

  // ... (Keep _checkLocationRequirements, _showSettingsDialog, _getUserLocation exactly as they are) ...
  // Keeping them brief here to focus on the UI changes.

  Future<void> _checkLocationRequirements() async {
    // ... [Your existing logic] ...
    // Just ensure _getUserLocation() calls the map update
    loc.Location location = loc.Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }
    var status = await Permission.locationWhenInUse.status;
    if (status.isPermanentlyDenied) {
      if (mounted) _showSettingsDialog();
      return;
    }
    if (!status.isGranted) {
      final statuses = await [
        Permission.location,
        Permission.locationWhenInUse,
      ].request();
      if (statuses[Permission.locationWhenInUse] != PermissionStatus.granted)
        return;
    }
    if (mounted) {
      setState(() => _hasLocationPermission = true);
      _getUserLocation();
    }
  }

  void _showSettingsDialog() {
    /* ... Same as your code ... */
  }

  Future<void> _getUserLocation() async {
    try {
      setState(() => _gettingLocation = true);
      loc.Location location = loc.Location();
      loc.LocationData current = await location.getLocation();

      if (current.latitude != null && current.longitude != null) {
        final pos = LatLng(current.latitude!, current.longitude!);
        await _getAddressFromCoordinates(pos);
        // Animate camera to user
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 16)),
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      if (mounted) setState(() => _gettingLocation = false);
    }
  }

  void _updateMarkerPosition(LatLng coordinate) {
    setState(() {
      _selectedLat = coordinate.lat;
      _selectedLng = coordinate.lng;

      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: coordinate,
          icon: BitmapDescriptor.defaultMarker,
          // You can use a custom icon here later if you want
        ),
      );
    });

    // Smooth animation
    mapController?.animateCamera(
      CameraUpdate.newLatLng(coordinate),
    );
  }

  Future<void> _getAddressFromCoordinates(LatLng pos) async {
    _updateMarkerPosition(pos); // Move pin instantly

    try {
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        pos.lat,
        pos.lng,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        final street = place.thoroughfare?.isNotEmpty == true
            ? place.thoroughfare
            : place.street;
        final name = place.subThoroughfare?.isNotEmpty == true
            ? place.subThoroughfare
            : place.name;

        final parts = [
          name,
          street,
          place.subLocality,
          place.locality,
        ].where((e) => e != null && e.isNotEmpty).join(", ");

        if (mounted) {
          setState(() {
            _addressCtrl.text = parts.isNotEmpty ? parts : "Unknown Location";
          });
        }
      }
    } catch (e) {
      debugPrint("Error geocoding: $e");
    }
  }

  Future<void> _getCoordinatesFromAddress(String address) async {
    if (address.isEmpty) return;
    setState(() => _isSearchingAddress = true);
    FocusScope.of(context).unfocus();

    try {
      List<geo.Location> locations = await geo.locationFromAddress(address);
      if (locations.isNotEmpty) {
        final loc = locations[0];
        final pos = LatLng(loc.latitude, loc.longitude);
        _updateMarkerPosition(pos);
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 16)),
        );
      } else {
        if (mounted) {
          showAppSnackBar(
            context: context,
            content: "Address not found",
            isError: true,
          );
        }
      }
    } catch (e) {
      debugPrint("Error search: $e");
    } finally {
      if (mounted) setState(() => _isSearchingAddress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Allow map to go behind status bar for immersion
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Dark icon on light map usually, or a small background circle
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false, // Prevent map resize
      body: Stack(
        children: [
          // 1. FULL SCREEN MAP
          Positioned.fill(
            child: _isMapReady
                ? HuaweiMap(
                    initialCameraPosition: CameraPosition(
                      target: (_selectedLat != null && _selectedLng != null)
                          ? LatLng(_selectedLat!, _selectedLng!)
                          : const LatLng(3.1466, 101.6958),
                      zoom: 15,
                    ),
                    markers: _markers,
                    myLocationEnabled: _hasLocationPermission,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: (controller) {
                      mapController = controller;

                      if (_selectedLat != null && _selectedLng != null) {
                        controller.animateCamera(
                          CameraUpdate.newLatLng(
                            LatLng(_selectedLat!, _selectedLng!),
                          ),
                        );
                      }
                    },
                    onClick: (LatLng latLng) {
                      _getAddressFromCoordinates(latLng);
                    },
                  )
                : Container(
                    color: Colors.white,
                  ), // ✅ Show white bg while loading
          ),

          // 2. FLOATING SEARCH BAR (Top)
          Positioned(
            top: MediaQuery.of(context).padding.top + 60, // Below AppBar
            left: 20,
            right: 20,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _addressCtrl,
                decoration: InputDecoration(
                  hintText: "Search location...",
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  suffixIcon: _isSearchingAddress
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () =>
                              _getCoordinatesFromAddress(_addressCtrl.text),
                        ),
                ),
                onSubmitted: (val) => _getCoordinatesFromAddress(val),
              ),
            ),
          ),

          // 3. BOTTOM SHEET (Actions)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Location Status
                  if (_selectedLat != null)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _addressCtrl.text.isEmpty
                                ? "Selected Location"
                                : _addressCtrl.text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      // My Location Button (Square)
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: FilledButton.tonal(
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _getUserLocation,
                          child: _gettingLocation
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.my_location),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Confirm Button (Expanded)
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            if (_selectedLat == null || _selectedLng == null) {
                              showAppSnackBar(
                                context: context,
                                content:
                                    "Please tap the map to select a location",
                                isError: true,
                              );
                              return;
                            }
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TowingSubmitScreen(
                                  address: _addressCtrl.text.trim(),
                                  latitude: _selectedLat!,
                                  longitude: _selectedLng!,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Confirm Location",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
