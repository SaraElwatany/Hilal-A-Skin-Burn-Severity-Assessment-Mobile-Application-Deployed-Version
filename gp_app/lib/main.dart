import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale selectedLocale = const Locale('ar');

  @override
  Widget build(BuildContext context) {
    // final List<Locale> supportedLocales = S.delegate.supportedLocales;
    // final Locale selectedLocale = Localizations.localeOf(context);

    return MaterialApp(
      locale: selectedLocale,
      title: 'Home Assisstant Doctor',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 147, 229, 250),
          brightness: Brightness.dark,
          surface: const Color.fromARGB(255, 29, 49, 78),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 251, 251),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
                color: Colors.black,
              ),
            ),
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: const SplashScreen(),
      //  home: SplashScreen(
      //   selectedLocale: _selectedLocale,
      //   onLocaleChanged: (locale) {
      //     setState(() {
      //       _selectedLocale = locale;
      //     });
      //   },
      // ),
    );
  }
}

// class LocaleDropdown extends StatelessWidget {
//   final List<Locale> supportedLocales;
//   final Locale selectedLocale;
//   final void Function(Locale locale) onLocaleChanged;

//   const LocaleDropdown({
//     Key? key,
//     required this.supportedLocales,
//     required this.selectedLocale,
//     required this.onLocaleChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<Locale>(
//       value: selectedLocale,
//       items: supportedLocales.map((locale) {
//         return DropdownMenuItem<Locale>(
//           value: locale,
//           child: Text(locale.languageCode.toUpperCase()),
//         );
//       }).toList(),
//       onChanged: (locale) {
//         onLocaleChanged(locale!);
//       },
//     );
//   }
// }

// class SplashScreen extends StatelessWidget {
//   final Locale selectedLocale;
//   final void Function(Locale locale) onLocaleChanged;

//   const SplashScreen({
//     Key? key,
//     required this.selectedLocale,
//     required this.onLocaleChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(S.of(context).appName),
//             LocaleDropdown(
//               supportedLocales: S.delegate.supportedLocales,
//               selectedLocale: selectedLocale,
//               onLocaleChanged: onLocaleChanged,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
