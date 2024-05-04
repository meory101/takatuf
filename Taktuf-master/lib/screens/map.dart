import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:takatuf/components/rec_button.dart';
import 'package:takatuf/theme/colors.dart';
import 'package:takatuf/theme/fonts.dart';
 

class AppMap extends StatefulWidget {
  const AppMap({super.key});

  @override
  State<AppMap> createState() => _AppMapState();
}

class _AppMapState extends State<AppMap> {
  GoogleMapController? mapController;
  Position? cl;
  var lat;
  var long;
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
    cl = await Geolocator.getCurrentPosition().then((value) => (value));

    lat = cl?.latitude;
    long = cl?.longitude;

    _kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      tilt: 0.5,
      zoom: 30.4746,
    );
    if (!mounted) return;
    setState(() {
      mymarker = {
        Marker(markerId: MarkerId("1"), position: LatLng(lat, long)),
        Marker(
            onDragEnd: ((LatLng) => {print(LatLng)}),
            markerId: MarkerId("1"),
            position: LatLng(lat, long))
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
          : Stack(
              children: [
                GoogleMap(
                  onTap: (LatLng) async {
                    setState(() {
                      mymarker.add(
                          Marker(markerId: MarkerId("1"), position: LatLng));
                      lat = LatLng.latitude;
                      long = LatLng.longitude;
                    });
                  },
                  markers: mymarker,
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex!,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                ),
                Positioned(
                  left: 30,
                  bottom: 30,
                  child: RecButton(
                      fun: () {
                        Navigator.of(context).pop("${lat}" + '/' + '${long}');
                      },
                      label: Text(
                        'Done',
                        style: AppFonts.white_12,
                      ),
                      width: 100,
                      height: 50,
                      color: AppColors.DarkBlue),
                ),
              ],
            ),
    );
  }
}
