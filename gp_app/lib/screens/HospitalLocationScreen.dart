import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HospitalLocationScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String hospitalNameEn;
  final String hospitalNameAr;

  const HospitalLocationScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.hospitalNameEn,
    required this.hospitalNameAr,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LatLng hospitalLocation = LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hospitalNameEn,
              style: TextStyle(fontSize: 18),
            ),
            Text(
              hospitalNameAr,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: hospitalLocation,
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("hospitalLocation"),
            position: hospitalLocation,
          ),
        },
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';

// class HospitalLocationScreen extends StatefulWidget {
//   final String url;

//   const HospitalLocationScreen(this.url, {Key? key}) : super(key: key);

//   @override
//   _HospitalLocationScreenState createState() => _HospitalLocationScreenState();
// }

// class _HospitalLocationScreenState extends State<HospitalLocationScreen> {
//   GoogleMapController? mapController;
//   LatLng? hospitalLocation;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     requestLocationPermission();
//   }

//   void requestLocationPermission() async {
//     var permissionStatus = await Permission.location.request();

//     if (permissionStatus.isGranted) {
//       parseUrlAndSetHospitalLocation();
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Location Permission Required'),
//           content:
//               Text('Please grant location permission to use this feature.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   void parseUrlAndSetHospitalLocation() {
//     if (widget.url
//         .startsWith('https://www.google.com/maps/search/?api=1&query=')) {
//       final coordinates = widget.url.split('=')[1].split(',');
//       if (coordinates.length == 2) {
//         final lat = double.tryParse(coordinates[0]);
//         final lng = double.tryParse(coordinates[1]);
//         if (lat != null && lng != null) {
//           setState(() {
//             hospitalLocation = LatLng(lat, lng);
//             isLoading = false;
//           });
//         }
//       }
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Invalid Location URL'),
//           content: Text('The provided URL does not contain valid coordinates.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Hospital Location',
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : (hospitalLocation != null
//               ? GoogleMap(
//                   onMapCreated: (GoogleMapController controller) {
//                     mapController = controller;
//                   },
//                   initialCameraPosition: CameraPosition(
//                     target: hospitalLocation!,
//                     zoom: 14,
//                   ),
//                   markers: {
//                     Marker(
//                       markerId: MarkerId("hospitalLocation"),
//                       position: hospitalLocation!,
//                       icon: BitmapDescriptor.defaultMarker,
//                     ),
//                   },
//                 )
//               : Center(
//                   child: Text('Failed to load hospital location.'),
//                 )),
//     );
//   }
// }
