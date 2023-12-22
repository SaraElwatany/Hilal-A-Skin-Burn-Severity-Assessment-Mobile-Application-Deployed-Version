import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gp_app/models/new_user.dart';
import 'dart:io';

// A function that sends the username and password to the flask backend (return type as future object with no value == The function completes without returning any value)
Future<String> sendData(String username, String password) async {
  String url =
      'http://127.0.0.1:19999/login'; // When launching the app => http://127.0.0.1:19999  For Emulator => http://10.0.2.2:19999

  var request = await http.post(Uri.parse(url), body: {
    'username': username,
    'password': password,
  }); // Send the data to the URL

  if (request.statusCode == 200) {
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
  } else {
    // Request failed, handle the error
    print('Login failed due to failed request');
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
  var url = 'http://127.0.0.1:19999/signup';

  var response = await http.post(Uri.parse(url), body: {
    'firstname': userInfo.firstName,
    'lastname': userInfo.lastName,
    'email': userInfo.email,
    'password': userInfo.password,
  });

  if (response.statusCode == 200) {
    // Request successful, handle the response (valid http response was received == okay statement for http)
    var responseData = jsonDecode(response.body);
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
  } else {
    // Request failed, handle the error
    print('Sign up failed due to failed request');
    return 'Sign up Failed';
  }
}

bool isValidEmail(String email) {
  // Regular expression for basic email validation
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  return emailRegex.hasMatch(email);
}

Future<void> sendImageToServer(File imageFile) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://127.0.0.1:19999/uploadImg'),
  );

  var pic = await http.MultipartFile.fromPath('file', imageFile.path);
  request.files.add(pic);

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image sent successfully');
      // Handle success
    } else {
      print('Failed to send image');
      // Handle failure
    }
  } catch (error) {
    print('Error sending image: $error');
    // Handle error
  }
}
