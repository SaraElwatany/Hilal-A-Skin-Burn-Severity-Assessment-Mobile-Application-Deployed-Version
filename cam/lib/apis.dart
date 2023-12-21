import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> uploadImageToBackend(String image, File ImageFile) async {
  var url = 'http://10.0.2.2:9999/upload';
  //final request = http.MultipartRequest('POST', Uri.parse(url));
  //request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
  final request = await http.post(
    Uri.parse(url),
    body: jsonEncode(
      {
        'Image': image,
        'File Name': ImageFile.path,
      },
    ),
    headers: {'Content-Type': "application/json"},
  );

  // print('StatusCode : ${request.statusCode}');
  // print('Return Data : ${request.body}');

  try {
    final responseData = jsonDecode(request.body);
    final responseMessage = responseData['response'];
    print('Received Response: $responseMessage');

    if (request.statusCode == 200) {
      print('Image uploaded successfully');
      // Handle the response from the backend if needed
    } else {
      print('Failed to upload image. Error: ${request.reasonPhrase}');
      // Handle the failure if needed
    }
  } catch (e) {
    print('Error uploading image: $e');
    // Handle the error if needed
  }
}
