import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gp_app/screens/welcome_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const WelcomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png'),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'هلال',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
                // const SizedBox(height: 20,),
                Text(
                  'Hilal',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            )));
  }
}
