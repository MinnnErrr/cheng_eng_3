import 'package:cheng_eng_3/ui/screens/customer/towing/towing_submit_screen.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:huawei_map/huawei_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;

class TowingMapScreen extends ConsumerStatefulWidget {
  const TowingMapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TowingMapScreenState();
}

class _TowingMapScreenState extends ConsumerState<TowingMapScreen> {
  final _addressCtrl = TextEditingController();
  final _latitudeCtrl = TextEditingController();
  final _longitudeCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //map
  bool _hasLocationPermission = false;
  HuaweiMapController? mapController;

  // Loading states
  bool _gettingLocation = false;
  bool _isSearchingAddress = false;

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    HuaweiMapInitializer.initializeMap();

    // Use Future.delayed to ensure context is ready for SnackBars
    Future.delayed(Duration.zero, () {
      _checkLocationRequirements();
    });
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    _latitudeCtrl.dispose();
    _longitudeCtrl.dispose();
    super.dispose();
  }

  Future<void> _checkLocationRequirements() async {
    loc.Location location = loc.Location();
    bool serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        if (mounted) {
          showAppSnackBar(
            context: context,
            content: 'GPS must be turned on to use the map.',
            isError: true,
          );
        }
        return;
      }
    }

    var status = await Permission.locationWhenInUse.status;

    if (status.isPermanentlyDenied) {
      if (mounted) _showSettingsDialog();
      return;
    }

    if (!status.isGranted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.locationWhenInUse,
      ].request();

      if (statuses[Permission.locationWhenInUse] != PermissionStatus.granted) {
        if (mounted) {
          showAppSnackBar(
            context: context,
            content: 'Permission denied. Map feature unavailable',
          );
        }
        return;
      }
    }

    if (mounted) {
      setState(() {
        _hasLocationPermission = true;
      });
      _getUserLocation();
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text(
          "Location permission is permanently denied. Please enable it in settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  Future<void> _getUserLocation() async {
    try {
      setState(() {
        _gettingLocation = true;
      });

      loc.Location location = loc.Location();
      loc.LocationData currentLocation = await location.getLocation();

      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        final userLatLng = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );

        // ✅ FIXED: Call _getAddressFromCoordinates instead of _updateMarkerPosition.
        // This ensures the Address Text Field is auto-filled when GPS finds you.
        await _getAddressFromCoordinates(userLatLng);

        // (Note: _getAddressFromCoordinates handles the marker update internally)
      }
    } catch (e) {
      if (!mounted) return;
      showAppSnackBar(
        context: context,
        content: 'Failed to get current location',
      );
    } finally {
      if (mounted) {
        setState(() {
          _gettingLocation = false;
        });
      }
    }
  }

  void _updateMarkerPosition(LatLng coordinate) {
    setState(() {
      _latitudeCtrl.text = coordinate.lat.toString();
      _longitudeCtrl.text = coordinate.lng.toString();

      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: coordinate,
          infoWindow: const InfoWindow(title: 'Selected Location'),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: coordinate, zoom: 18),
      ),
    );
  }

  Future<void> _getAddressFromCoordinates(LatLng pos) async {
    // 1. First, move the pin immediately (UI feels faster)
    _updateMarkerPosition(pos);

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
          place.postalCode,
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((e) => e != null && e.isNotEmpty).join(", ");

        if (mounted) {
          setState(() {
            final address = parts.isNotEmpty ? parts : 'Unknown Location';
            _addressCtrl.text = address;
          });
        }
      } else {
        if (!mounted) return;
        showAppSnackBar(
          context: context,
          content: 'Address not found',
          isError: true,
        );
      }
    } catch (e) {
      // It's okay to fail silently here sometimes (e.g. no internet),
      // but keeping snackbar is fine for debugging.
      debugPrint("Error getting address: $e");
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
        LatLng newPos = LatLng(loc.latitude, loc.longitude);

        _updateMarkerPosition(newPos);
      } else {
        if (!mounted) return;
        showAppSnackBar(
          context: context,
          content: "Coordinates not found.",
          isError: true,
        );
      }
    } catch (e) {
      debugPrint("Error getting coordinates: $e");
    } finally {
      if (mounted) setState(() => _isSearchingAddress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a location'),
      ),
      // Prevent keyboard from pushing/distorting the map
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 10,
                  children: [
                    TextFormField(
                      controller: _addressCtrl,
                      decoration: InputDecoration(
                        labelText: "Current Address",
                        border: const OutlineInputBorder(),
                        suffixIcon: _isSearchingAddress
                            ? const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () => _getCoordinatesFromAddress(
                                  _addressCtrl.text,
                                ),
                              ),
                      ),
                      onFieldSubmitted: (val) =>
                          _getCoordinatesFromAddress(val),
                    ),
                    textFormField(
                      controller: _latitudeCtrl,
                      label: 'Latitude',
                      readOnly: true,
                    ),
                    textFormField(
                      controller: _longitudeCtrl,
                      label: 'Longitude',
                      readOnly: true,
                    ),

                    Expanded(
                      child: HuaweiMap(
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(3.1466, 101.6958),
                          zoom: 15,
                        ),
                        markers: _markers,
                        myLocationEnabled: _hasLocationPermission,
                        myLocationButtonEnabled: false,
                        onMapCreated: (controller) {
                          mapController = controller;
                        },
                        onClick: (LatLng latLng) {
                          _getAddressFromCoordinates(latLng);
                        },
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _getUserLocation,
                          child: const Text('My Location'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_latitudeCtrl.text.trim().isEmpty ||
                                _longitudeCtrl.text.trim().isEmpty) {
                              showAppSnackBar(
                                context: context,
                                content: "Please select a location first",
                                isError: true,
                              );
                              return;
                            }

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TowingSubmitScreen(
                                  address: _addressCtrl.text.trim(),
                                  latitude: double.parse(
                                    _latitudeCtrl.text.trim(),
                                  ),
                                  longitude: double.parse(
                                    _longitudeCtrl.text.trim(),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_gettingLocation)
            Container(
              // ✅ CHANGED: Used withOpacity for better compatibility
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        "Getting current location...",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
