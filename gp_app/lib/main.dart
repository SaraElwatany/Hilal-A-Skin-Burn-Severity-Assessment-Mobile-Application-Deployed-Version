import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // locale: Locale('ar'),
      title: 'Home Assisstant Doctor',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 147, 229, 250),
          brightness: Brightness.dark,
          surface: const Color.fromARGB(255, 29, 49, 78),
        ),
        scaffoldBackgroundColor:const Color.fromARGB(255, 255, 251, 251),
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: const TextStyle(
            fontWeight: FontWeight.bold,
           fontSize: 50,
           color: Colors.black
          )
        )
      ),
       localizationsDelegates:const  [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
      home: const SplashScreen(),
    );
  }
}