class Global {
  static String _latestPrediction = ''; // Global Variable for the prediction of the associated burn
  static int _userId = 0; // Global Variable for doctor's ID
  static String _userProfession = ''; // Global Variable for User's Profession Detection from Login Screen
  static bool _adminPassword = false; // Global Variable for admin password, default value false 'patient'

  // Private constructor
  Global._();

  // Getters and setters for latestPrediction
  static String get latestPrediction => _latestPrediction;
  static set latestPrediction(String value) {
    _latestPrediction = value;
  }

  // Getters and setters for userId
  static int get userId => _userId;
  static set userId(int value) {
    _userId = value;
  }

  // Getters and setters for userProfession
  static String get userProfession => _userProfession;
  static set userProfession(String value) {
    _userProfession = value;
  }

  // Getters and setters for adminPassword
  static bool get adminPassword => _adminPassword;
  static set adminPassword(bool value) {
    _adminPassword = value;
  }

  // Method to update variables from JSON data
  static void updateFromJson(Map<String, dynamic> data) {
    latestPrediction = data['latestPrediction'] ?? latestPrediction;
    userId = data['user_id'] ?? userId;
    userProfession = data['userProfession'] ?? userProfession;
    adminPassword = data['adminPassword'] ?? adminPassword;
  }

  // Singleton instance
  static final Global instance = Global._();
}
