// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `patient and doctor assistanat`
  String get app_title {
    return Intl.message(
      'patient and doctor assistanat',
      name: 'app_title',
      desc: '',
      args: [],
    );
  }

  /// `Flutter localization`
  String get title {
    return Intl.message(
      'Flutter localization',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Home Assisstant Doctor`
  String get appName {
    return Intl.message(
      'Home Assisstant Doctor',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Welcome  !`
  String get welcome {
    return Intl.message(
      'Welcome  !',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `I'm Hilal, your healthcare companion. `
  String get hilal {
    return Intl.message(
      'I\'m Hilal, your healthcare companion. ',
      name: 'hilal',
      desc: '',
      args: [],
    );
  }

  /// `First, I want to know your preferred language.`
  String get chooselang {
    return Intl.message(
      'First, I want to know your preferred language.',
      name: 'chooselang',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `login`
  String get login {
    return Intl.message(
      'login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get language {
    return Intl.message(
      'English',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Welcom to our application`
  String get home_screen_greeting {
    return Intl.message(
      'Welcom to our application',
      name: 'home_screen_greeting',
      desc: '',
      args: [],
    );
  }

  /// ` Password`
  String get password {
    return Intl.message(
      ' Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Second Name`
  String get lastName {
    return Intl.message(
      'Second Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get nothaveAcc {
    return Intl.message(
      'Don\'t have an account?',
      name: 'nothaveAcc',
      desc: '',
      args: [],
    );
  }

  /// `Do you have an account?`
  String get haveAcc {
    return Intl.message(
      'Do you have an account?',
      name: 'haveAcc',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signNw {
    return Intl.message(
      'Sign up',
      name: 'signNw',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup {
    return Intl.message(
      'Sign Up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `E-mail`
  String get mail {
    return Intl.message(
      'E-mail',
      name: 'mail',
      desc: '',
      args: [],
    );
  }

  /// `login`
  String get loginNw {
    return Intl.message(
      'login',
      name: 'loginNw',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Burns`
  String get burns {
    return Intl.message(
      'Burns',
      name: 'burns',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
