import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:takatuf/theme/colors.dart';
 
class ShowMap extends StatefulWidget {
 final double lat;
 final double long;
  ShowMap({required this.lat, required this.long});

  @override
  State<ShowMap> createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  GoogleMapController? mapController;
  Position? cl;

  CameraPosition? _kGooglePlex;
  late Set<Marker> mymarker;

  getlocation() async {
    PermissionStatus status = await Permission.location.request();
    if (status == PermissionStatus.denied) {
      await Geolocator.requestPermission();
    }
    if (status == PermissionStatus.granted) {
      await getLatLong();
    }
  }

  getLatLong() async {
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.lat, widget.long),
      tilt: 0.5,
      zoom: 30.4746,
    );
    setState(() {
      mymarker = {
        Marker(
            markerId: MarkerId("1"), position: LatLng(widget.lat, widget.long)),
        Marker(
            onDragEnd: ((LatLng) => {print(LatLng)}),
            markerId: MarkerId("1"),
            position: LatLng(widget.lat, widget.long))
      };
    });
  }

  void initState() {
    getlocation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _kGooglePlex == null
          ? Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.DarkBlue,
                ),
              ),
            )
          : GoogleMap(
              onTap: (LatLng) async {
                setState(() {
                  mymarker
                      .add(Marker(markerId: MarkerId("1"), position: LatLng));
                });
              },
              markers: mymarker,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex!,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
    );
  }
}
