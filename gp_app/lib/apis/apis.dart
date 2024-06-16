import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gp_app/models/global.dart';
import 'package:gp_app/models/new_user.dart';
import 'package:gp_app/models/patient_list.dart';
import 'package:gp_app/screens/clinical_data.dart';
import 'package:gp_app/models/chat_message.dart';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart'; 

// Imports for keeping the state of variables
import 'package:provider/provider.dart';
import 'package:gp_app/models/my_state.dart'; // Import the file where you defined your state class

// Local Host For ios Emulator => http://127.0.0.1:19999
// Local Host For Android Emulator => http://10.0.2.2:19999
// Local Host For Windows => http://127.0.0.1:19999
// Local Host For Chrome => http://localhost:58931  120.0.6099.111
// https://my-trial-t8wj.onrender.com

// Function that sends the username and password to the flask backend (return type as future object with no value == The function completes without returning any value)
Future<String> sendData(
    String email, String password, BuildContext context) async {
  // Set The Global Variables To Null with each login
  final myState = Provider.of<MyState>(context, listen: false);
  String userId = myState.userId;
  String burnId = myState.burnId;
  myState.updateUserId("0");
  myState.updateBurnId("0");
  //userId = '0';
  //burnId = '0';

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
      UserProfession = responseData['user_profession'];

      print('Login successful');
      print('Profession: $UserProfession');

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
              'Please Enter a valid username or password',
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
    //if (request.statusCode == 200) {
    // Request was successful
    print(
        'Received a successful response (Status Code: ${request.statusCode})');
    // Request successful, handle the response (valid http response was received == okay statement for http)
    var responseData = jsonDecode(request.body);
    var responseMessage = responseData['response'];
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
    String burnId = myState.burnId;
    print('Initial userId: $userId');

    // Encode the image as base64
    String base64Image = base64Encode(imageFile.readAsBytesSync());

    // Create the multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://my-trial-t8wj.onrender.com/uploadImg'),
    );

    // Add the base64-encoded image as a field
    request.fields['user_id'] = userId;
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
      var prediction = responseData['prediction'];
      var receivedBurnId = responseData['burn_id'];

      print('Prediction: $prediction');
      print('Received Burn Id: $receivedBurnId');

      // Set the prediction and burn ID to the global variables
      myState.updatePrediction(prediction);
      myState.updateBurnId(receivedBurnId);

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

  // Get the state of the widgets
  final myState = Provider.of<MyState>(context, listen: false);
  String burnId = myState.burnId;

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
    cause = 'heat';
  } else if (causeOfBurn == Symptoms.chemical) {
    cause = 'chemical';
  } else if (causeOfBurn == Symptoms.radioactive) {
    cause = 'radioactive';
  }

  // Concatenate the clinical data dictionaries
  Map<String, dynamic> causeMap = {'cause': cause};
  Map<String, dynamic> burn_id = {'burn_id': burnId};

  // Concatenating dictionaries using the spread operator
  Map<String, dynamic> concatenatedDict = {
    ...symptomsMap,
    ...causeMap,
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
  String burnId = myState.burnId;

  Map<String, dynamic> burn_id = {'burn_id': burnId};

  try {
    // Try sending a request with the empty clinical data
    var request = await http.post(Uri.parse(url), body: burn_id);

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

Future<List<ChatMessage>> fetchChatHistory(int senderId, int receiverId) async {
  var url = Uri.parse('https://my-trial-t8wj.onrender.com/get_chat_history?sender_id=$senderId&receiver_id=$receiverId');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    List<dynamic> messagesJson = json.decode(response.body);
    List<ChatMessage> messages = messagesJson
        .map((messageJson) => ChatMessage.fromJson(messageJson))
        .toList();
    return messages;
  } else {
    throw Exception('Failed to load chat history');
  }
}

void _sendMessage() {
  final text = _messageController.text.trim();
  if (text.isNotEmpty) {
    final message = ChatMessage(
      message: text,
      receiver: true,
      imageFile: null,
      audioUrl: null,  // Add this line if applicable
      timestamp: DateTime.now(),
    );

    // Send the message to the server
    sendMessageToServer(message);

    setState(() {
      messages.add(message);
      _messageController.clear();
    });
  }
}

Future<void> _requestMicrophonePermission() async {
    await Permission.microphone.request();
  }

Future<void> sendMessageToServer(ChatMessage message) async {
  var url = Uri.parse('https://my-trial-t8wj.onrender.com/api/send_message');
  var response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(message.toJson()),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to send message');
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


class AudioApi {
  static final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  static String? _recordFilePath;

  static Future<void> initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Microphone permission not granted');
    }
    await _recorder.openAudioSession();
  }

  static Future<void> startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    _recordFilePath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder.startRecorder(toFile: _recordFilePath);
  }

  static Future<String?> stopRecording() async {
    await _recorder.stopRecorder();
    return _recordFilePath;
  }

  static Future<void> closeRecorder() async {
    await _recorder.closeAudioSession();
  }
}
