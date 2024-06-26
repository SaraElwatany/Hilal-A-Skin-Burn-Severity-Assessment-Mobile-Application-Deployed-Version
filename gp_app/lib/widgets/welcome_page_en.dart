

// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:gp_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';

class WelcomePageEN extends StatelessWidget{
  const WelcomePageEN({super.key});

  @override
  Widget build(BuildContext context) {
   return  Align(
  alignment: Alignment.centerLeft,
  child: Container(
    padding: const EdgeInsets.only(left: 20,top: 100, right: 20), // Adjust the left padding
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).welcome,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 50,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
           Text(
            S.of(context).hilal,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
           Text(
            S.of(context).chooselang,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    ),
  ),
);
          
 

    
   

  }
}