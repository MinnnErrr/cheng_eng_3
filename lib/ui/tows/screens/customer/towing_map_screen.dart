import 'package:cheng_eng_3/ui/tows/screens/customer/towing_submit_screen.dart';
import 'package:cheng_eng_3/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:huawei_map/huawei_map.dart';
import 'package:huawei_location/huawei_location.dart'
    as hms_loc; // ✅ Use HMS Location
import 'package:permission_handler/permission_handler.dart';

class TowingMapScreen extends ConsumerStatefulWidget {
  const TowingMapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TowingMapScreenState();
}

class _TowingMapScreenState extends ConsumerState<TowingMapScreen>
    with WidgetsBindingObserver {
  final hms_loc.FusedLocationProviderClient _locationService =
      hms_loc.FusedLocationProviderClient();

  final _addressCtrl = TextEditingController();

  double? _selectedLat;
  double? _selectedLng;

  bool _hasLocationPermission = false;
  HuaweiMapController? mapController;

  bool _gettingLocation = false;
  bool _isSearchingAddress = false;
  bool _showMapLayer = false;

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initMapAndLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the user comes back to the app (Resumed)
    if (state == AppLifecycleState.resumed) {
      // Check permission/GPS again silently
      _checkPermission(silent: true).then((isReady) {
        if (isReady) {
          setState(() => _hasLocationPermission = true);
          _locationService.initFusedLocationService().then((_) {
            _getUserLocation();
          });
        }
      });
    }
  }

  Future<void> _initMapAndLocation() async {
    try {
      HuaweiMapInitializer.initializeMap();

      final bool isLocationReady = await _checkPermission();

      setState(() {
        _hasLocationPermission = isLocationReady;
        _showMapLayer =
            true; 
      });

      if (isLocationReady) {
        try {
          await _locationService.initFusedLocationService();
          _getUserLocation(); 
        } catch (e) {
          debugPrint("Location Service Init Error: $e");
        }
      }
    } catch (e) {
      debugPrint("Initialization Error: $e");
      if (!mounted) return;
      showAppSnackBar(
        context: context,
        content: 'Failed to initialize map',
        isError: true,
      );
    }
  }

  Future<bool> _checkPermission({bool silent = false}) async {
    var status = await Permission.location.status;

    if (!status.isGranted && !silent) {
      status = await Permission.location.request();
    }

    if (!mounted) return false;
    if (!status.isGranted) {
      if (!silent) {
        if (status.isPermanentlyDenied) {
          _showSettingsDialog();
        } else {
          showAppSnackBar(
            context: context,
            content: 'Location permission is required.',
            isError: true,
          );
        }
      }
      return false;
    }

    final serviceStatus = await Permission.location.serviceStatus;

    if (!serviceStatus.isEnabled) {
      if (!mounted) return false;
      if (!silent) {
        showAppSnackBar(
          context: context,
          content: 'Please turn on your GPS Location service.',
          isError: true,
        );
      }
      return false;
    }

    return true;
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Location Permission"),
        content: const Text(
          "Location permission is needed to find your position on the map.",
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
            child: const Text("Settings"),
          ),
        ],
      ),
    );
  }

  Future<void> _getUserLocation() async {
    if (!_hasLocationPermission) {
      final isReady = await _checkPermission(silent: false);
      if (isReady) {
        setState(() => _hasLocationPermission = true);
        await _locationService.initFusedLocationService();
      } else {
        return;
      }
    }

    try {
      setState(() => _gettingLocation = true);

      final loc = await _locationService.getLastLocation();

      final pos = LatLng(loc.latitude!, loc.longitude!);
      await _getAddressFromCoordinates(pos);

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 18)),
      );
    } catch (e) {
      debugPrint("Error getting location: $e");
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
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });

    mapController?.animateCamera(
      CameraUpdate.newLatLng(coordinate),
    );
  }

  Future<void> _getAddressFromCoordinates(LatLng pos) async {
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
          CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 18)),
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: _showMapLayer
                ? RepaintBoundary(
                    child: HuaweiMap(
                      initialCameraPosition: CameraPosition(
                        target: (_selectedLat != null && _selectedLng != null)
                            ? LatLng(_selectedLat!, _selectedLng!)
                            : const LatLng(3.1466, 101.6958), 
                        zoom: 15,
                      ),
                      markers: _markers,
                      myLocationEnabled: false,
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
                    ),
                  )
                : Container(
                    color: Colors.white,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
          ),

          // FLOATING SEARCH BAR (Top)
          Positioned(
            top: MediaQuery.of(context).padding.top + 60,
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
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
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

          // BOTTOM SHEET DETAILS
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _addressCtrl.text.isEmpty
                                ? "Selected Location"
                                : _addressCtrl.text,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      // My Location Button 
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
                      // Confirm Button
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
                            "CONFIRM LOCATION",
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
