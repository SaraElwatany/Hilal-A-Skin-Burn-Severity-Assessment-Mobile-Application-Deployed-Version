import 'package:flutter/material.dart';
// import 'package:gp_app/widgets/welcome_page_ar.dart';
import 'package:gp_app/widgets/welcome_page_en.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/screens/login_screen.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:gp_app/router/custom_router.dart';
import 'package:gp_app/main.dart';
import 'package:gp_app/classes/language.dart';
// import 'package:gp_app/classes/language_constants.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() {
    return _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage> {
  // final GlobalKey<FormState> _key = GlobalKey<FormState>();

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
      body: Column(
        children: [
          // Text(S.of(context).appName),
          const WelcomePageEN(),
          //  const WelcomePageAR(),
          // const Localization(),
          const SizedBox(height: 70),
          Center(
            // Backend:Button to go to Login page
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  fixedSize: const Size(166, 69)),
              child: Text(
                S.of(context).start,
                style: const TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 255, 251, 251),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
