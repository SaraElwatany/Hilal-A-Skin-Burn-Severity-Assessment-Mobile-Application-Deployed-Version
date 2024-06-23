import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gp_app/models/global.dart';
import 'package:gp_app/models/new_user.dart';
import 'package:gp_app/models/patient_list.dart';
import 'package:gp_app/screens/clinical_data.dart';
import 'package:gp_app/models/chat_message.dart';
import 'package:gp_app/models/global.dart';

import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

// Imports for keeping the state of variables
import 'package:provider/provider.dart';
import 'package:gp_app/models/my_state.dart'; // Import the file where you defined your state class
import 'package:shared_preferences/shared_preferences.dart';

// Local Host For ios Emulator => http://127.0.0.1:19999
// Local Host For Android Emulator => http://10.0.2.2:19999
// Local Host For Windows => http://127.0.0.1:19999
// Local Host For Chrome => http://localhost:58931  120.0.6099.111
// https://my-trial-t8wj.onrender.com

// Session Class to store and retrieve states
class SessionManager {
  static const String _userIdKey = 'userId';
  static const String _burnIdKey = 'burnId'; // Add burnId key
  static const String _prediction = 'prediction';
  static const String _latitudeKey = 'latitude'; // Add latitude key
  static const String _longitudeKey = 'longitude'; // Add longitude key

  // Function to Save User ID to the session
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  // Function to Get Burn User ID from the session
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Function to Save Burn ID to the session
  static Future<void> saveBurnId(String burnId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_burnIdKey, burnId);
  }

  // Function to Get Burn ID from the session
  static Future<String?> getBurnId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_burnIdKey);
  }

  static Future<void> saveLatitude(double latitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latitudeKey, latitude);
  }

  static Future<double?> getLatitude() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_latitudeKey);
  }

  static Future<void> saveLongitude(double longitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_longitudeKey, longitude);
  }

  static Future<double?> getLongitude() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_longitudeKey);
  }

  static Future<void> savePrediction(String prediction) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prediction, prediction);
  }

  static Future<String?> getPrediction() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prediction);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_burnIdKey);
    await prefs.remove(_prediction);
    await prefs.remove(_latitudeKey);
    await prefs.remove(_longitudeKey);
  }
}

// Function that sends the username and password to the flask backend (return type as future object with no value == The function completes without returning any value)
Future<String> sendData(
    String email, String password, BuildContext context) async {
  // Set The Global Variables To Null with each login
  final myState = Provider.of<MyState>(context, listen: false);
  String userId = myState.userId;
  myState.updateUserId("0");

  String url = 'https://my-trial-t8wj.onrender.com/login';
  var request = await http.post(Uri.parse(url), body: {
    'email': email,
    'password': password,
  });

  if (request.statusCode == 200 ||
      request.statusCode == 201 ||
      request.statusCode == 204) {
    //if (request.statusCode == 200) {
    // Request was successful
    print(
        'Received a successful response (Status Code: ${request.statusCode})');

    // Request successful, handle the response (valid http response was received == okay statement for http)
    final responseData = jsonDecode(request.body);
    final responseMessage = responseData['response'];

    print('Received response: $responseMessage');

    if (responseMessage == 'Access Allowed') {
      userId = responseData['user_id'];
      print('User ID from Login Route: $userId');
      String UserProfession = responseData['user_profession'];

      print('Login successful');
      print('Profession: $UserProfession');

      // Save userId to SharedPreferences
      await SessionManager.saveUserId(userId);

      return 'Access Allowed';
    } else {
      print('Login Failed due to incorrect email or password');
      return 'Access Denied';
    }
  } else if (request.statusCode == 400) {
    // Bad Request
    print(
        'Bad Request: The server could not understand the request (Status Code: 400)');
    print('Response Body: ${request.body}');
    return 'Access Denied';
  } else if (request.statusCode == 401) {
    // Unauthorized
    print(
        'Unauthorized: The request requires user authentication (Status Code: 401)');
    print('Response Body: ${request.body}');
    return 'Access Denied';
  } else if (request.statusCode == 403) {
    // Forbidden
    print(
        'Forbidden: The server understood the request but refuses to authorize it (Status Code: 403)');
    print('Response Body: ${request.body}');
    return 'Access Denied';
  } else if (request.statusCode == 404) {
    // Not Found
    print(
        'Not Found: The requested resource could not be found (Status Code: 404)');
    print('Response Body: ${request.body}');
    return 'Access Denied';
  } else if (request.statusCode == 500) {
    // Internal Server Error
    print(
        'Internal Server Error: A generic error occurred on the server (Status Code: 500)');
    print('Response Body: ${request.body}');
    return 'Access Denied';
  } else {
    // Request failed, handle the error
    print('Login failed due to failed request');
    print('Response Body: ${request.body}');
    // Other status codes
    print(
        'Received an unexpected response with status code: ${request.statusCode}');
    return 'Access Denied';
  }
}

// Function to pop up a warning whenever the user enters wrong login information
void login_warning(context) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text(
              'Please Enter a valid email or password',
            ),
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text(
                  'Okay',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ));
}

// Function to sign up an account
Future<String> signUp(NewUser userInfo) async {
  var url = 'https://my-trial-t8wj.onrender.com/signup'; //
  print('Before Request');
  var request = await http.post(Uri.parse(url), body: {
    'firstname': userInfo.firstName,
    'lastname': userInfo.lastName,
    'email': userInfo.email,
    'password': userInfo.password,
  });
  print('After Request');

  if (request.statusCode == 200 ||
      request.statusCode == 201 ||
      request.statusCode == 204) {
    print(
        'Received a successful response (Status Code: ${request.statusCode})');
    // Request successful, handle the response (valid http response was received == okay statement for http)
    var responseData = jsonDecode(request.body);
    var responseMessage = responseData['response'];
    String userId = responseData['user_id'];
    print('Received response: $responseMessage');

    if (responseMessage == 'Failed Password and Email') {
      print('Sign up Failed due to wrong password and email');
      return 'Sign up Denied due to password & email';
    } else if (responseMessage == 'Failed Password') {
      print('Sign up Failed due to wrong password');
      return 'Sign up Denied due to password';
    } else if (responseMessage == 'Failed Email') {
      print('Sign up Failed due to wrong email format');
      return 'Sign up Denied due to email';
    } else if (responseMessage == 'Failed: Email already exists') {
      print('Sign up failed, an account with this email already exists');
      return 'Sign up Denied due to duplicate email';
    } else {
      // Request was successful, and the info was correct => Sign Up
      print('Sign up was successful');
      // Save userId to SharedPreferences
      await SessionManager.saveUserId(userId);
      return 'Sign up Allowed';
    }
  } else if (request.statusCode == 400) {
    // Bad Request
    print(
        'Bad Request: The server could not understand the request (Status Code: 400)');
    print('Response Body: ${request.body}');
    return 'Access Denied';
  } else if (request.statusCode == 401) {
    // Unauthorized
    print(
        'Unauthorized: The request requires user authentication (Status Code: 401)');
    print('Response Body: ${request.body}');
    return 'Access Denied';
  } else if (request.statusCode == 403) {
    // Forbidden
    print(
        'Forbidden: The server understood the request but refuses to authorize it (Status Code: 403)');
    print('Response Body: ${request.body}');
    return 'Access Denied';
  } else if (request.statusCode == 404) {
    // Not Found
    print(
        'Not Found: The requested resource could not be found (Status Code: 404)');
    print('Response Body: ${request.body}');
    return 'Access Denied';
  } else if (request.statusCode == 500) {
    // Internal Server Error
    print(
        'Internal Server Error: A generic error occurred on the server (Status Code: 500)');
    print('Response Body: ${request.body}');
    return 'Access Denied';
  } else {
    // Request failed, handle the error
    print('Sign up failed due to failed request');
    print('Response Body: ${request.body}');
    // Other status codes
    print(
        'Received an unexpected response with status code: ${request.statusCode}');
    return 'Sign up Failed';
  }
}

// Function to check if the signed up email is valid
bool isValidEmail(String email) {
  // Regular expression for basic email validation
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  return emailRegex.hasMatch(email);
}

// Function to send the captured image to the prediction
Future<int> sendImageToServer(File imageFile, BuildContext context) async {
  try {
    // Get the state of my widgets
    final myState = Provider.of<MyState>(context, listen: false);
    String userId = myState.userId;
    print('Initial userId: $userId');

    // Encode the image as base64
    String base64Image = base64Encode(imageFile.readAsBytesSync());

    // Create the multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://my-trial-t8wj.onrender.com/uploadImg'),
    );

    // Add the base64-encoded image as a field
    request.fields['user_id'] = (await SessionManager.getUserId()) ?? '';
    request.fields['Image'] = base64Image;

    // Attach the image file
    var pic = await http.MultipartFile.fromPath('file', imageFile.path);
    request.files.add(pic);

    // Send the request and wait for the response
    var response = await http.Response.fromStream(await request.send());

    // Check the response status code
    if (response.statusCode == 200) {
      print('Image sent and prediction received');

      // Parse the JSON response
      var responseData = json.decode(response.body);
      String prediction = responseData['prediction'];
      String receivedBurnId = responseData['burn_id'];

      print('Prediction: $prediction');
      print('Received Burn Id: $receivedBurnId');

      // Save Burn Id & Model's Prediction to SharedPreferences
      await SessionManager.saveBurnId(receivedBurnId);
      await SessionManager.savePrediction(prediction);

      // Return navigate = 1 to indicate success
      return 1;
    } else {
      print('Failed to receive response. Status code: ${response.statusCode}');
      // Return navigate = 0 to indicate failure
      return 0;
    }
  } catch (error) {
    print('Error sending image: $error');
    // Return navigate = 0 to indicate failure
    return 0;
  }
}

// Function to fetch the symptoms and cause of burn from the user
Future addClinicalData(List<Symptoms> symptoms, Symptoms? causeOfBurn,
    BuildContext context) async {
  String url = 'https://my-trial-t8wj.onrender.com/add_burn';
  // Get the User ID From the Shared Preferences
  String userId = (await SessionManager.getUserId()) ?? '';
  // Get the Burn ID From the Shared Preferences
  String burnId = (await SessionManager.getBurnId()) ?? '';

  List<String> clinicalSymptoms = [];
  String cause = '';
  int no_symptoms = symptoms.length;

  print('Symptoms: $symptoms');
  print('Cause: $causeOfBurn');

  // Encode the symtoms after a burn in the form of dictionary
  for (int indx = 0; indx < no_symptoms; indx++) {
    String value = '';

    if (symptoms[indx] == Symptoms.symptom_1) {
      value = 'trembling_limbs';
    } else if (symptoms[indx] == Symptoms.symptom_2) {
      value = 'diarrhea';
    } else if (symptoms[indx] == Symptoms.symptom_3) {
      value = 'cold_extremities';
    } else if (symptoms[indx] == Symptoms.symptom_4) {
      value = 'nausea';
    }

    print(value);
    clinicalSymptoms.add(value);
  }

  // Converting symptoms list to dictionary
  Map<String, dynamic> symptomsMap = {};
  for (int symp = 0; symp < no_symptoms; symp++) {
    symptomsMap[clinicalSymptoms[symp]] = clinicalSymptoms[symp];
  }
  print(symptomsMap);

  // Encode the cause of burn in the form of dictionary
  if (causeOfBurn == Symptoms.electricity) {
    cause = 'electricity';
  } else if (causeOfBurn == Symptoms.heat) {
    cause = 'Fire/Fire Flame';
  } else if (causeOfBurn == Symptoms.chemical) {
    cause = 'chemical';
  } else if (causeOfBurn == Symptoms.radioactive) {
    cause = 'radioactive';
  }

  // Concatenate the clinical data dictionaries
  Map<String, dynamic> causeMap = {'cause': cause};
  Map<String, dynamic> user_id = {'user_id': userId};
  Map<String, dynamic> burn_id = {'burn_id': burnId};

  // Concatenating dictionaries using the spread operator
  Map<String, dynamic> concatenatedDict = {
    ...symptomsMap,
    ...causeMap,
    ...user_id,
    ...burn_id
  };

  print(concatenatedDict);

  try {
    // Try sending a request with the clinical data
    var request = await http.post(
      Uri.parse(url),
      body: concatenatedDict,
    );

    // Request successful, handle the response (valid http response was received == okay statement for http)
    if (request.statusCode == 200) {
      print('Clinical Data Sent successfully');
      // If the call to the server was successful, parse the JSON
      final responseData = jsonDecode(request.body);
      final responseMessage = responseData['response'];

      print('Received response: $responseData');
    } else {
      print('Failed to receive response');
      // Handle failure
    }
  } catch (error) {
    print('Error sending image: $error');
    // Handle error
  }
}

// Skip the acquiring of clinical data for now
// Function to fetch the symptoms and cause of burn from the user
Future skipClinicalData(BuildContext context) async {
  String url = 'https://my-trial-t8wj.onrender.com/add_burn';
  // Get the state of the widgets
  final myState = Provider.of<MyState>(context, listen: false);
  // Get the User ID From the Shared Preferences
  String userId = (await SessionManager.getUserId()) ?? '';
  // Get the Burn ID From the Shared Preferences
  String burnId = (await SessionManager.getBurnId()) ?? '';

  Map<String, dynamic> user_id = {'user_id': userId};
  Map<String, dynamic> burn_id = {'burn_id': burnId};

  // Concatenating dictionaries using the spread operator
  Map<String, dynamic> concatenatedDict = {...user_id, ...burn_id};

  try {
    // Try sending a request with the empty clinical data
    var request = await http.post(Uri.parse(url), body: concatenatedDict);

    // Request successful, handle the response (valid http response was received == okay statement for http)
    if (request.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      final responseData = jsonDecode(request.body);
      final responseMessage = responseData['response'];
    } else {
      print('Failed to receive response');
      // Handle failure
    }
  } catch (error) {
    print('Failed to send request: $error');
    // Handle error
  }
}

// Function to list all users with burns for the doctor
Future<List<Patient>> getPatients() async {
  var url = Uri.parse('https://my-trial-t8wj.onrender.com/get_all_burns');
  var response = await http.post(url);

  // Request was successful, handle the response
  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final responseMessage = responseData['message'];

    final patients_ids = responseData['user_ids'];
    final patients_names = responseData['user_names'];
    final patients_info = responseData['user_info'];

    // Get the length of patients with burns found
    int no_patients = patients_ids.length;

    print('Received Response From get_patients route: $responseMessage');
    print('Received users: $patients_ids');

    List<Patient> patients_list = List.generate(no_patients, (index) {
      return Patient(
          name: patients_names[index],
          info: patients_info[index],
          id: patients_ids[index]);
    });

    return patients_list;
  } else {
    throw Exception('Failed to load patients');
  }
}

// class AudioApi {
//     static final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//     static String? _recordFilePath;

//     static Future<void> initRecorder() async {
//         final status = await Permission.microphone.request();
//         if (status != PermissionStatus.granted) {
//             throw Exception('Microphone permission not granted');
//         }

//         // Open the audio session
//         await _recorder.openAudioSession();
//     }

//     static Future<void> startRecording() async {
//         final dir = await getApplicationDocumentsDirectory();
//         _recordFilePath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
//         await _recorder.startRecorder(toFile: _recordFilePath);
//     }

//     static Future<String?> stopRecording() async {
//         await _recorder.stopRecorder();
//         return _recordFilePath; // Return the file path after stopping the recorder
//     }

//     static Future<void> closeRecorder() async {
//         await _recorder.closeAudioSession();  // Correct method to close the recorder
//     }
// }

Future<List<ChatMessage>> fetchChatHistory(
    String senderId, String receiverId) async {
  var url = Uri.parse(
      'https://my-trial-t8wj.onrender.com/get_chat_history?sender_id=$senderId&receiver_id=$receiverId');
  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => ChatMessage.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load chat history');
    }
  } catch (e) {
    throw Exception('Error fetching chat history: $e');
  }
}

Future<void> _requestMicrophonePermission() async {
  await Permission.microphone.request();
}

Future<void> sendMessageToServer(ChatMessage message) async {
  try {
    var url = Uri.parse('https://my-trial-t8wj.onrender.com/send_message');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'sender_id': message.senderId,
      'receiver_id': message.receiverId,
      'message': message.message,
      'image': message.image,
      'timestamp': message.timestamp.toIso8601String(),
    });

    print('Sending JSON: $body'); // Print the JSON payload for debugging

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      print('Message sent successfully');
    } else {
      print('Failed to send message. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to send message');
    }
  } catch (e) {
    print('Error sending message: $e');
    throw Exception('Error sending message: $e');
  }
}

Future<void> loginUser(String email, String password) async {
  // Example endpoint URL (replace with your Flask server URL)
  String url = 'https://my-trial-t8wj.onrender.com/login';

  // Example request body
  Map<String, String> body = {
    'email': email,
    'password': password,
  };

  try {
    var response = await http.post(
      Uri.parse(url),
      body: body,
    );

    if (response.statusCode == 200) {
      // Successful login, parse JSON response
      Map<String, dynamic> data = json.decode(response.body);
      // Update global.dart variables based on response data
      Global.updateFromJson(data);
    }
  } catch (e) {
    // Handle network or other errors
  }
}

// Function to return the user's location to flask
Future<void> get_user_location(
    double user_latitude, double user_longitude) async {
  var url = Uri.parse('https://my-trial-t8wj.onrender.com/get_user_location');
  // Save User's latitude & longitude to SharedPreferences
  await SessionManager.saveLatitude(user_latitude);
  await SessionManager.saveLongitude(user_longitude);

  // Construct query parameters
  var params = {
    'user_latitude': user_latitude.toString(),
    'user_longitude': user_longitude.toString(),
  };

  var response = await http.post(
    url.replace(queryParameters: params),
  );

  print('Latitude: $user_latitude');

  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 204) {
    // Request successful, handle the response
    final responseData = jsonDecode(response.body);
    final responseMessage = responseData['message'];
    print('Received response: $responseMessage');
    print(
        'Received a successful response (Status Code: ${response.statusCode})');
  } else if (response.statusCode == 400) {
    // Bad Request
    print(
        'Bad Request: The server could not understand the request (Status Code: 400)');
    print('Response Body: ${response.body}');
  } else if (response.statusCode == 401) {
    // Unauthorized
    print(
        'Unauthorized: The request requires user authentication (Status Code: 401)');
    print('Response Body: ${response.body}');
  } else if (response.statusCode == 403) {
    // Forbidden
    print(
        'Forbidden: The server understood the request but refuses to authorize it (Status Code: 403)');
    print('Response Body: ${response.body}');
  } else if (response.statusCode == 404) {
    // Not Found
    print(
        'Not Found: The requested resource could not be found (Status Code: 404)');
    print('Response Body: ${response.body}');
  } else if (response.statusCode == 500) {
    // Internal Server Error
    print(
        'Internal Server Error: A generic error occurred on the server (Status Code: 500)');
    print('Response Body: ${response.body}');
  } else {
    // Request failed, handle the error
    print('Location Not Sent due to failed request');
    print('Response Body: ${response.body}');
    // Other status codes
    print(
        'Received an unexpected response with status code: ${response.statusCode}');
  }
}

Future<void> getHospitals() async {
  var url = Uri.parse('https://my-trial-t8wj.onrender.com/respond_to_user');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      if (responseBody['error'] != null) {
        print('Error: ${responseBody['error']}');
      } else {
        List<dynamic> hospitals = responseBody['hospitals'];

        print('Top 5 Nearest Burn Hospitals:');

        for (var i = 0; i < 5 && i < hospitals.length; i++) {
          var hospital = hospitals[i];

          print('${hospital['english_name']} - ${hospital['arabic_name']}');
          print('Latitude: ${hospital['lat']}, Longitude: ${hospital['lon']}');
          print('---');
        }

        String prediction = responseBody['prediction'];
        print('Prediction: $prediction');
      }
    } else {
      print('Failed to get response. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// Function to ....
Future<void> respondToUser() async {
  var url = Uri.parse('https://my-trial-t8wj.onrender.com/respond_to_user');
  var response = await http.post(url);

  // Request was successful, handle the response
  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final responseMessage = responseData['message'];

    final patients_ids = responseData['patients_ids'];
    final hospitals = responseData['hospitals'];
    final prediction = responseData['ّprediction'];

    print('Received Response From get_patients route: $responseMessage');
  }
}





// // Function to delete flask session when logged out from account
// void logout() async {
//   String url =
//       'https://my-trial-t8wj.onrender.com/logout'; // Replace with your actual logout endpoint URL

//   try {
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       // Successful logout
//       print('Logged out successfully');
//       // Optionally, navigate to another screen or perform other actions after logout
//     } else {
//       print('Failed to logout: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error during logout: $e');
//   }
// }