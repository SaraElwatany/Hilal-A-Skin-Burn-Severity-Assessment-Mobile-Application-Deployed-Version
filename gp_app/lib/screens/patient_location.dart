import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gp_app/classes/language.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/main.dart';
import 'package:gp_app/apis/apis.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  _LocationAppState createState() => _LocationAppState();
}

class _LocationAppState extends State<Location> {
  var locationMessage = "";
  LatLng? userLocation;
  double? userLatitude; // Added to store user's latitude
  double? userLongitude; // Added to store user's longitude
  bool isDisposed = false; // Flag to check if widget is disposed

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  void dispose() {
    isDisposed = true; // Set flag to true when the widget is disposed
    super.dispose();
  }

  void getCurrentLocation() async {
    var permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      if (!isDisposed) {
        // Check if widget is not disposed before calling setState
        setState(() {
          userLatitude = position.latitude; // Store latitude
          userLongitude = position.longitude; // Store longitude

          double user_latitude = userLatitude ?? 0.0;
          double user_longitude = userLongitude ?? 0.0;

          get_user_location(user_latitude, user_longitude);

          userLocation = LatLng(position.latitude, position.longitude);

          locationMessage =
              "Latitude position: $userLatitude, Longitude position: $userLongitude"; // Use new variables
        });
      }
    } else {
      if (!isDisposed) {
        // Check if widget is not disposed before calling setState
        setState(() {
          locationMessage = "Location permission denied.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/Hilal.png',
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<Language>(
              underline: const SizedBox(),
              icon: const Icon(
                Icons.language,
                color: Colors.white,
              ),
              onChanged: (Language? language) {
                if (language != null) {
                  MyApp.setLocale(context, Locale(language.languageCode, ''));
                }
              },
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                      value: e,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            e.flag,
                            style: const TextStyle(
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            e.name,
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 600,
              child: userLocation != null
                  ? GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: userLocation!,
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId(
                            "userLocation",
                          ),
                          position: userLocation!,
                        ),
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            SizedBox(
              height: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    locationMessage,
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: getCurrentLocation,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          const Color.fromARGB(255, 29, 49, 78)),
                    ),
                    child: Text(
                      S.of(context).location,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
