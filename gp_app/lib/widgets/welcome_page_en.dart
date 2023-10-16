

// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:gp_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WelcomePageEN extends StatelessWidget{
  const WelcomePageEN({super.key});

  @override
  Widget build(BuildContext context) {
   return  Align(
  alignment: Alignment.centerLeft,
  child: Container(
    padding: const EdgeInsets.only(left: 20,top: 80), // Adjust the left padding
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome  !',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 50,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "I'm Hilal, your healthcare companion. ",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        const Text(
          "First, I want to know your preferred language. ",
          style: TextStyle(fontSize: 18),
        ),
      ],
    ),
  ),
);
          
 

    
   

  }
}