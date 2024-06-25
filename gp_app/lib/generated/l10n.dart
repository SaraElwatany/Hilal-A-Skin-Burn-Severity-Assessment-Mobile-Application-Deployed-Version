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
      'I\'m Hilal, Your skin burn care companion. ',
      name: 'hilal',
      desc: '',
      args: [],
    );
  }

  /// `First, I want to know your preferred language.`
  String get chooselang {
    return Intl.message(
      'First, join to us by creating an account or press emergency if you are in hurry.',
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

  /// `Upload Image`
  String get upload {
    return Intl.message(
      'Upload Image',
      name: 'upload',
      desc: '',
      args: [],
    );
  }

  /// `Ask Hilal...`
  String get message {
    return Intl.message(
      'Ask Hilal...',
      name: 'message',
      desc: '',
      args: [],
    );
  }

// About us
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

// Intro
  String get Intro {
    return Intl.message(
      "Hello! My name is Hilal, the health companion for burn patients. \nI am here to answer your questions about the treatment \nand management of skin burns that occur at home.",
      name: 'intro',
      desc: '',
      args: [],
    );
  }

  // asadmin
  String get asadmin {
    return Intl.message(
      "Admin",
      name: 'asadmin',
      desc: '',
      args: [],
    );
  }

  // edit
  String get edit {
    return Intl.message(
      "Edit",
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  // confirm
  String get confirm {
    return Intl.message(
      "Confirm",
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  // patients
  String get patients {
    return Intl.message(
      "patients",
      name: 'patients',
      desc: '',
      args: [],
    );
  }

  // Time
  String get time {
    return Intl.message(
      "Time",
      name: 'time',
      desc: '',
      args: [],
    );
  }

// Danger
  String get danger {
    return Intl.message(
      "Danger",
      name: 'danger',
      desc: '',
      args: [],
    );
  }

  // AboutUsMessage
  String get aboutUsMessage {
    return Intl.message(
      "We are student developers from faculty of biomedical engineering in Cairo University. We created this app to help victims of burn injuries at home find proper resources for managing their injury.",
      name: 'aboutUsMessage',
      desc: '',
      args: [],
    );
  }

  // clinictitle
  String get clinictitle {
    return Intl.message(
      "Clinical data on burn",
      name: 'clinictitle',
      desc: '',
      args: [],
    );
  }

  // symptoms
  String get symptoms {
    return Intl.message(
      "Identify your symptom:",
      name: 'symptoms',
      desc: '',
      args: [],
    );
  }

  // symptom_1
  String get symptom_1 {
    return Intl.message(
      "Trembling limbs",
      name: 'symptom_1',
      desc: '',
      args: [],
    );
  }

  // symptom_2
  String get symptom_2 {
    return Intl.message(
      "Diarrhea",
      name: 'symptom_2',
      desc: '',
      args: [],
    );
  }

  // symptom_3
  String get symptom_3 {
    return Intl.message(
      "Cold extremities",
      name: 'symptom_3',
      desc: '',
      args: [],
    );
  }

  // symptom_4
  String get symptom_4 {
    return Intl.message(
      "Nausea",
      name: 'symptom_4',
      desc: '',
      args: [],
    );
  }

  // cause
  String get cause {
    return Intl.message(
      "Cause of burn:",
      name: 'cause',
      desc: '',
      args: [],
    );
  }

  // heat
  String get heat {
    return Intl.message(
      "Fire/Fire flame",
      name: 'heat',
      desc: '',
      args: [],
    );
  }

  // electricity
  String get electricity {
    return Intl.message(
      "Electricity",
      name: 'electricity',
      desc: '',
      args: [],
    );
  }

  // chemical
  String get chemical {
    return Intl.message(
      "Chemical",
      name: 'chemical',
      desc: '',
      args: [],
    );
  }

  // radioactive
  String get radioactive {
    return Intl.message(
      "Radioactive",
      name: 'radioactive',
      desc: '',
      args: [],
    );
  }

  // boiling
  String get boiling {
    return Intl.message(
      "Boiling Liquid",
      name: 'boiling',
      desc: '',
      args: [],
    );
  }

// place
  String get place {
    return Intl.message(
      "Burn Place",
      name: 'place',
      desc: '',
      args: [],
    );
  }

// arm
  String get arm {
    return Intl.message(
      "Arm",
      name: 'arm',
      desc: '',
      args: [],
    );
  }

// leg
  String get leg {
    return Intl.message(
      "Leg",
      name: 'leg',
      desc: '',
      args: [],
    );
  }

// head
  String get head {
    return Intl.message(
      "Head and Neck",
      name: 'head',
      desc: '',
      args: [],
    );
  }

  // chest
  String get chest {
    return Intl.message(
      "Chest and Upper back",
      name: 'chest',
      desc: '',
      args: [],
    );
  }

  // back
  String get back {
    return Intl.message(
      "Abdomen and Lower back",
      name: 'back',
      desc: '',
      args: [],
    );
  }

  // skip
  String get skip {
    return Intl.message(
      "Skip",
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  // emergency
  String get emergency {
    return Intl.message(
      "Emergency",
      name: 'emergency',
      desc: '',
      args: [],
    );
  }

  // select_image
  String get select_image {
    return Intl.message(
      "Select Image",
      name: 'select_image',
      desc: '',
      args: [],
    );
  }

  // doctoes
  String get doctors {
    return Intl.message(
      "Doctors",
      name: 'doctors',
      desc: '',
      args: [],
    );
  }

  // addDoctors
  String get addDoctors {
    return Intl.message(
      "Add Doctor",
      name: 'addDoctors',
      desc: '',
      args: [],
    );
  }

  // doctorInfo
  String get doctorInfo {
    return Intl.message(
      "Doctor Infromation",
      name: 'doctorInfo',
      desc: '',
      args: [],
    );
  }

  // degree
  String get degree {
    return Intl.message(
      "Professional degree",
      name: 'degree',
      desc: '',
      args: [],
    );
  }

  // save
  String get save {
    return Intl.message(
      "Save",
      name: 'save',
      desc: '',
      args: [],
    );
  }

  // instructions
  String get instructions {
    return Intl.message(
      "Instructions",
      name: 'instructions',
      desc: '',
      args: [],
    );
  }

  // goodLigthingTitle
  String get goodLigthingTitle {
    return Intl.message(
      "Good lighting",
      name: 'goodLigthingTitle',
      desc: '',
      args: [],
    );
  }

  // simpleBackgroundTitle
  String get simpleBackgroundTitle {
    return Intl.message(
      "Simple background",
      name: 'simpleBackgroundTitle',
      desc: '',
      args: [],
    );
  }

  // flashligthTitle
  String get flashligthTitle {
    return Intl.message(
      "Avoid using Flash Ligth",
      name: 'flashligthTitle',
      desc: '',
      args: [],
    );
  }

// burnDetailsTitle
  String get burnDetailsTitle {
    return Intl.message(
      "Burning Details",
      name: 'burnDetailsTitle',
      desc: '',
      args: [],
    );
  }

  // burnTouchTitle
  String get burnTouchTitle {
    return Intl.message(
      "Avoid touching Burn Area",
      name: 'burnTouchTitle',
      desc: '',
      args: [],
    );
  }

  // foucsTitle
  String get foucsTitle {
    return Intl.message(
      "Focus",
      name: 'foucsTitle',
      desc: '',
      args: [],
    );
  }

  // privacyTitle
  String get privacyTitle {
    return Intl.message(
      "Respect Privacy",
      name: 'privacyTitle',
      desc: '',
      args: [],
    );
  }

  // areadetection
  String get areadetection {
    return Intl.message(
      "Determine size",
      name: 'areadetection',
      desc: '',
      args: [],
    );
  }

  // areadetection
  String get location {
    return Intl.message(
      "Get current location",
      name: 'location',
      desc: '',
      args: [],
    );
  }

  // areadetection
  String get userlocation {
    return Intl.message(
      "Set you current location",
      name: 'userlocation',
      desc: '',
      args: [],
    );
  }

  // goodLigthingtext
  String get goodLigthingtext {
    return Intl.message(
      "Make sure there is good lighting when taking the photo. Natural lighting during the day is best. Avoid very strong lighting that may cause harsh glare or shadows",
      name: 'goodLigthingtext',
      desc: '',
      args: [],
    );
  }

  // simpleBackgroundText
  String get simpleBackgroundText {
    return Intl.message(
      "Use a neutral, non-distracting background. A plain or white background helps highlight the details of the burn.",
      name: 'simpleBackgroundText',
      desc: '',
      args: [],
    );
  }

  // flashligthText
  String get flashligthText {
    return Intl.message(
      "Flash may change the colors of the burn and make details blurry. Use natural light as much as possible.",
      name: 'flashligthText',
      desc: '',
      args: [],
    );
  }

  // burnDetailsText
  String get burnDetailsText {
    return Intl.message(
      "Take pictures from several angles to show all the details of the burn. Close-up photos to show edges, depth, and any discolouration.",
      name: 'burnDetailsText',
      desc: '',
      args: [],
    );
  }

// burnTouchText
  String get burnTouchText {
    return Intl.message(
      "Do not try to move or touch the burn to improve the view in the image, so as not to aggravate the injury.",
      name: 'burnTouchText',
      desc: '',
      args: [],
    );
  }

  // foucsText
  String get foucsText {
    return Intl.message(
      "Use the auto focus mode on your camera to make sure the image is clear and not blurry. Check the sharpness of the image before sending it.",
      desc: '',
      args: [],
    );
  }

  // privacyText
  String get privacyText {
    return Intl.message(
      "Make sure that no personal features or any sensitive information is visible in the photo.",
      desc: '',
      args: [],
    );
  }

  // areadetectionText
  String get areadetectionText {
    return Intl.message(
      "If the burn is large, you may need to take several pictures from different distances to show the actual size of the burn in relation to other parts of the body.",
      desc: '',
      args: [],
    );
  }

  // firstDegreeMessage
  String get firstDegreeMessage {
    return Intl.message(
      "Your Burn Degree is First Degree Burn.\nThe Following First Aid Protocols are Recommended:\n1.Make sure that you are away from the source of burn.\n2.Douse the area with room temperature tap water.\n3.DO NOT USE ICE, BUTTER, TOOTHPASTE, OR OTHER CHEMICALS.\n4.Take off any accessories (Jewelry, watches, rings, etc.)\n5.Apply Mebo or Dermazine to the burned area, then cover it with a sterile bandage or a clean cloth.\n6.Seek Medical attention if:\n i. If the burned area is larger than the size of your palm, seek medical attention.\n ii. Burns on the face, hands, feet, genitals, or major joints.\n iii. Chemical burns, Electrical burns.\n iv. For any burns that cause severe pain, blistering, or white or charred skin.",
      name: 'firstDegreeMessage',
      desc: '',
      args: [],
    );
  }

  // secondDegreeMessage
  String get secondDegreeMessage {
    return Intl.message(
      '''Your Burn Degree is Second Degree Burn.\n
      The Following First Aid Protocols are Recommended:\n
                1-Make sure that you are away from the source of burn.\n
                2-Douse the area with room temperature tap water.\n
                  DO NOT USE ICE, BUTTER, TOOTHPASTE, OR OTHER CHEMICALS.\n
                3-Take off any accessories (Jewelry, watches, rings, etc.)\n
                4-Apply Mebo or Dermazine to the burned area. Then cover it with a sterile bandage or a clean cloth.\n
                5-Seek Immediate medical attention.\n''',
      name: 'secondDegreeMessage',
      desc: '',
      args: [],
    );
  }

  // thirdDegreeMessage
  String get thirdDegreeMessage {
    return Intl.message(
      ''' Your Burn Degree is Third Degree Burn.\n
        The Following First Aid Protocols are Recommended:\n\n
        1-Make sure that you are away from the source of burn.\n
        2-Douse the area with room temperature tap water.\n
          DO NOT USE ICE, BUTTER, TOOTHPASTE, OR OTHER CHEMICALS.\n
        3-Take off any accessories (Jewelry, watches, rings, etc.)\n
        4-Apply Mebo or Dermazine to the burned area. Then cover it with a sterile bandage or a clean cloth.\n
        5-Seek Immediate medical attention.\n''',
      name: 'thirdDegreeMessage',
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
