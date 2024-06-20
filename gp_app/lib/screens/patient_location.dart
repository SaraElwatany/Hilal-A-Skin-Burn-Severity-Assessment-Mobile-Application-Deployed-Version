import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gp_app/classes/language.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/main.dart';
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

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    var permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
        locationMessage =
            "Latitude position: ${position.latitude}, Longitude position: ${position.longitude}";
      });
    } else {
      setState(() {
        locationMessage = "Location permission denied.";
      });
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
