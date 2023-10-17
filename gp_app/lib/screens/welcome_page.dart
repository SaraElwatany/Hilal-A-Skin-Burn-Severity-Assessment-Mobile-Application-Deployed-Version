import 'package:flutter/material.dart';
import 'package:gp_app/screens/localization.dart';
import 'package:gp_app/widgets/welcome_page_ar.dart';
import 'package:gp_app/widgets/welcome_page_en.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/screens/login_screen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() {
    return _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage> {
  //  String language=Intl.getCurrentLocale();

  // void arabicLam(){
  //   language='ar';
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Image.asset(
            'assets/images/Hilal.png',
          ),
        ),
        leadingWidth: 90,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Image.asset(
              'assets/images/Hilal_ar.png',
              width: 100,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const WelcomePageEN(),
          const WelcomePageAR(),
          // const Localization(),
          const SizedBox(height: 40),
          Center(
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
                )),
          ),
        ],
      ),
    );
  }
}
