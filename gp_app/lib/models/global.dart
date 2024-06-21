// globals.dart

class Global {
  static String latestPrediction = ''; // Global Variable for the prediction of the associated burn
  static String user_id = '0'; // Global Variable for doctor's ID
  static String userProfession = ''; // Global Variable for User's Profession Detection from Login Screen
  static bool adminPassword = false; // Global Variable for admin password, default value false

  // Private constructor
  Global._();

  // Method to update variables from JSON data
  static void updateFromJson(Map<String, dynamic> data) {
    latestPrediction = data['latestPrediction'] ?? '';
    user_id = data['user_id'] ?? '0';
    userProfession = data['userProfession'] ?? '';
    adminPassword = data['adminPassword'] ?? false;
  }


  // Singleton instance
  static final Global instance = Global._();
}
