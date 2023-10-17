import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';

class Localization extends StatefulWidget {
  const Localization({super.key});

  @override
  State<Localization> createState() => _Localization();
}

class _Localization extends State<Localization> {
  Locale selectedLocale = const Locale('ar');

  @override
  Widget build(BuildContext context) {
    final List<Locale> supportedLocales = S.delegate.supportedLocales;
    Locale selectedLocale = Localizations.localeOf(context);

    return Scaffold(
      body: LocalizationBar(
        selectedLocale: selectedLocale,
        onLocaleChanged: (locale) {
          setState(() {
            selectedLocale = locale;
          });
        },
      ),
    );
  }
}

class LocaleDropdown extends StatelessWidget {
  final List<Locale> supportedLocales;
  final Locale selectedLocale;
  final void Function(Locale locale) onLocaleChanged;

  const LocaleDropdown({
    Key? key,
    required this.supportedLocales,
    required this.selectedLocale,
    required this.onLocaleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: selectedLocale,
      items: supportedLocales.map((locale) {
        return DropdownMenuItem<Locale>(
          value: locale,
          child: Text(locale.languageCode.toUpperCase()),
        );
      }).toList(),
      onChanged: (locale) {
        onLocaleChanged(locale!);
      },
    );
  }
}

class LocalizationBar extends StatelessWidget {
  final Locale selectedLocale;
  final void Function(Locale locale) onLocaleChanged;

  const LocalizationBar({
    Key? key,
    required this.selectedLocale,
    required this.onLocaleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(S.of(context).appName),
            LocaleDropdown(
              supportedLocales: S.delegate.supportedLocales,
              selectedLocale: selectedLocale,
              onLocaleChanged: onLocaleChanged,
            ),
          ],
        ),
      ),
    );
  }
}
