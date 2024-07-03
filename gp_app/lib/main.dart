import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/manager/voice_note_manager/audio_recorder_file.dart';
import 'package:gp_app/manager/voice_note_manager/voive_noter_cubit.dart';
import 'package:gp_app/screens/splash_screen.dart';
import 'package:gp_app/apis/apis.dart';
import 'package:provider/provider.dart';
import 'package:gp_app/models/my_state.dart'; // Import the file where you defined your state class

// void main() async {
//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => MyState(),
//       child: const MyApp(),
//     ),
//   );
// }

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => VoiceNotesCubit(AudioRecorderFileHelper())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      title: 'Home Assistant Doctor',
      theme: ThemeData.dark().copyWith(
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
      initialRoute: 'home',
    );
  }
}
