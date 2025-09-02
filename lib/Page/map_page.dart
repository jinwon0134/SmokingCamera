import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();

  LatLng? _searchedLocation;
  LatLng? _currentLocation;

  final List<LatLng> smokingZones = [
    LatLng(36.3369, 127.4604),
    LatLng(36.336532, 127.457777),
    LatLng(36.335830, 127.458063),
    LatLng(36.3370133, 127.458858),
    LatLng(36.333558, 127.461979),
    LatLng(36.335536, 127.461502),
    LatLng(36.336378, 127.458901),
    LatLng(36.336235, 127.46079),
    LatLng(36.336480, 127.46165),
    LatLng(36.337579, 127.459528),
  ];

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initMarkers();
    _getCurrentLocation();
  }

  void _initMarkers() {
    for (int i = 0; i < smokingZones.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('smoking_zone_$i'),
          position: smokingZones[i],
          infoWindow: InfoWindow(title: '흡연 구역 #${i + 1}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
        ),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('위치 서비스를 켜주세요.')));
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('위치 권한이 필요합니다.')));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('앱 설정에서 위치 권한을 허용해주세요.')));
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (!mounted) return; // 위젯이 아직 화면에 있는지 체크
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentLocation!,
          infoWindow: const InfoWindow(title: '내 위치'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 16),
      );
    });
  }

  Future<void> _searchLocation(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        if (!mounted) return; // 위젯이 화면에 없으면 setState 호출 금지
        setState(() {
          _searchedLocation = LatLng(loc.latitude, loc.longitude);
          _markers.removeWhere((m) => m.markerId.value == 'searched');
          _markers.add(
            Marker(
              markerId: const MarkerId('searched'),
              position: _searchedLocation!,
              infoWindow: InfoWindow(title: address),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet,
              ),
            ),
          );
        });

        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(_searchedLocation!, 16),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('위치를 찾을 수 없습니다.')));
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('흡연장 찾기'),
        centerTitle: true,
        shape: const Border(bottom: BorderSide(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "대전대학교 서문",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: _searchLocation,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(36.335668, 127.460049),
                zoom: 16,
              ),
              markers: _markers,
              onMapCreated: (controller) => _mapController = controller,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  if (_searchedLocation != null) {
                    print("저장된 위치: $_searchedLocation");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("먼저 위치를 검색해주세요.")),
                    );
                  }
                },
                child: const Text(
                  "위치 저장하기",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
