import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gp_app/models/global.dart';
import 'package:gp_app/models/new_user.dart';
import 'dart:io';

// A function that sends the username and password to the flask backend (return type as future object with no value == The function completes without returning any value)
Future<String> sendData(String username, String password) async {
  String url = 'http://127.0.0.1:19999/login';
  // Local Host For ios Emulator => http://127.0.0.1:19999
  // Local Host For Android Emulator => http://10.0.2.2:19999
  // Local Host For Windows => http://127.0.0.1:19999
  // Local Host For Chrome => http://localhost:58931  120.0.6099.111
  var request = await http.post(Uri.parse(url), body: {
    'username': username,
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
      print('Login successful');
      return 'Access Allowed';
    } else {
      print('Login Failed due to incorrect username or password');
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

Future<String> signUp(NewUser userInfo) async {
  var url = 'http://127.0.0.1:19999/signup'; //
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

bool isValidEmail(String email) {
  // Regular expression for basic email validation
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  return emailRegex.hasMatch(email);
}

Future<int> sendImageToServer(File imageFile) async {
  int navigate = 0;
  String base64Image = base64Encode(imageFile.readAsBytesSync());
  print('Before Request');
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://127.0.0.1:19999/uploadImg'),
  );
  print('After Request');

  // Add the base64-encoded image as a field
  request.fields['Image'] = base64Image;
  var pic = await http.MultipartFile.fromPath('file', imageFile.path);
  request.files.add(pic);

  // Request successful, handle the response (valid http response was received == okay statement for http)
  try {
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image sent & degree predicted successfully');
      // If the call to the server was successful, parse the JSON
      var responseData =
          await response.stream.bytesToString(); // Read the response message

      print('Received response: $responseData');

      var decodedData = json.decode(responseData);
      var prediction = decodedData['prediction'];
      print('Prediction: $prediction');

      // Set the prediction to the global variable
      latestPrediction = prediction;
      navigate = 1;
      return navigate;
    } else {
      print('Failed to receive response');
      // Handle failure
      return navigate;
    }
  } catch (error) {
    print('Error sending image: $error');
    // Handle error
    return navigate;
  }
}
