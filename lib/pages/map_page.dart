import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:totalexam/reference/Config/index.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  Location _locationController = new Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng _pGooglePlex = LatLng(37.42089848578818, -122.08862900733948);
  static const LatLng _pApplePark = LatLng(37.42158866471894 , -122.08064675331116);
  LatLng? _currentP = null;

  Map<PolylineId, Polyline> polylines = {};
  
  @override
  void initState() {
    super.initState();
    getLocationUpdates().then(
      (_) => {
        getPolylinePoints().then((coordinates) => {
            generatePolyLineFromPoints(coordinates)
        }),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null 
          ? const Center(
              child: Text("Loading..."),
            )
          : GoogleMap(
            onMapCreated: ((GoogleMapController controller) => 
              _mapController.complete(controller)),
              initialCameraPosition: CameraPosition(
                target: _pGooglePlex!,
                zoom: 15,             //지도의 근접 정도
              ),
              markers: {
                Marker(
                  markerId: MarkerId("_currentLocation") ,
                  icon: BitmapDescriptor.defaultMarker,
                  position: _currentP!
                ),
                Marker(
                  markerId: MarkerId("_sourceLocation") ,
                  icon: BitmapDescriptor.defaultMarker,
                  position: _pGooglePlex),
                Marker(
                markerId: MarkerId("_destinationLocation") ,
                icon: BitmapDescriptor.defaultMarker,
                position: _pApplePark),
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGreanted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGreanted = await _locationController.hasPermission();
    if(_permissionGreanted == PermissionStatus.denied) {
      _permissionGreanted = await _locationController.requestPermission();
      if (_permissionGreanted != PermissionStatus.granted) {
        return;
      }
    }

    //사용자 위치 변하면 업데이트
    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if(currentLocation.latitude != null && 
         currentLocation.longitude != null) {
          setState(() {
            _currentP = 
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            print(_currentP);
            _cameraToPosition(_currentP!);

            });
      }
    }); 
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: Config.GOOGLE_MAPS_API_KEY, 
      request: PolylineRequest(
        origin: PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
        destination: PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
        mode: TravelMode.driving,
      ),
    );
      if(result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print(result.errorMessage);
      }
      return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurple,
      points: polylineCoordinates,
      width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }
}