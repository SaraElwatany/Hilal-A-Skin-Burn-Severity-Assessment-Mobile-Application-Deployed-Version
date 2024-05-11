import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/screens/about_us.dart';
import 'package:gp_app/screens/camera.dart';
import 'package:gp_app/screens/instruction.dart';
import 'package:gp_app/widgets/localization_icon.dart';
import 'package:gp_app/widgets/Icons.dart';

class MainPageScreen extends StatefulWidget {
  const MainPageScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LocalizationIcon(),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            MainIcons(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraScreen()),
                );
              },
              imagePath: 'assets/images/flame.png',
              text: S.of(context).burns,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                MainIcons(
                   width: 150,
                  height: 150,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutUs()),
                    );
                  },
                  imagePath: 'assets/images/AboutUs.png',
                  text: (S.of(context).about),
                ),
                 const SizedBox(
              width: 10,
            ),
                  MainIcons(
              width: 150,
              height: 150,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Instructions()),
                );
              },
              imagePath: 'assets/images/instructions.png',
              text: (S.of(context).instructions),
               textSize: 25,
            ),
              ],
            ),
            
           
          ],
        ),
      ),
    );
  }
}
