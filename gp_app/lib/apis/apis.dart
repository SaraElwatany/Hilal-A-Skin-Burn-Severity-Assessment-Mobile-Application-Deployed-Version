import 'package:http/http.dart' as http;

fetch_login_info(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}

// A function that sends the username and password to the flask backend (return type as future object with no value == The function completes without returning any value)
Future<void> sendData(String username, String password) async {
  String url =
      'http://10.0.2.2:19999/login'; // When launching the app => http://127.0.0.1:19999  For Emulator => http://10.0.2.2:19999

  var response = await http.post(Uri.parse(url), body: {
    'username': username,
    'password': password,
  }); // Send the data to the URL

  if (response.statusCode == 200) {
    // Request successful, handle the response (valid http response was received == okay statement for http)
    print('Login successful');
  } else {
    // Request failed, handle the error
    print('Login failed');
  }
}
