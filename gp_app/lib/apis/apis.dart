import 'package:http/http.dart' as http;
import 'package:gp_app/models/new_user.dart';

// A function that sends the username and password to the flask backend (return type as future object)
Future<void> sendData(String username, String password) async {
  String url =
      'http://10.0.2.2:19999/login'; // When launching the app => 127.0.0.1:19999  For Emulator => 10.0.2.2:19999

  var response = await http.post(Uri.parse(url), body: {
    'username': username,
    'password': password,
  });

  if (response.statusCode == 200) {
    // Request successful, handle the response (valid http response was received == okay statement for http)
    print('Login successful');
  } else {
    // Request failed, handle the error
    print('Login failed');
  }
}

Future<void> signup(NewUser userInfo) async {
  var url = 'http://10.0.2.2:19999/signup';

  var response = await http.post(Uri.parse(url), body: {
    'firstname': userInfo.firstName,
    'lastname': userInfo.lastName,
    'email': userInfo.email,
    'password': userInfo.password,
  });

  if (response.statusCode == 200) {
    print('signed up successfully');
  } else {
    print('sign up failed');
  }
}
