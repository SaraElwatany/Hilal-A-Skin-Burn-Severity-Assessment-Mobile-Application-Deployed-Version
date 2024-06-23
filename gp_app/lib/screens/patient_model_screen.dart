import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/widgets/localization_icon.dart';
import 'package:gp_app/models/global.dart';
import 'package:gp_app/apis/apis.dart';
import 'package:gp_app/models/my_state.dart';
import 'package:gp_app/models/global.dart';
import 'package:provider/provider.dart';

import 'package:gp_app/models/chat_message.dart';
import 'package:gp_app/widgets/messages_widget.dart';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:gp_app/widgets/audio_player_widget.dart';

import 'dart:convert'; // Import for JSON decoding
import 'package:http/http.dart' as http; // Import for HTTP requests
import 'package:flutter/gestures.dart'; // Import for gesture recognizers
import 'package:url_launcher/url_launcher.dart'; // Import for URL launcher

class PatientModelChat extends StatefulWidget {
  const PatientModelChat({Key? key}) : super(key: key);

  @override
  State<PatientModelChat> createState() => PatientModelChatState();
}

class PatientModelChatState extends State<PatientModelChat> {
  List<ChatMessage> messages = [];
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  final TextEditingController _messageController = TextEditingController();
  bool introMessageShown = false;
  bool predictionAndHospitalsFetched = false;

  Future<void> fetchPredictionAndHospitals() async {
    var url = Uri.parse('https://my-trial-t8wj.onrender.com/respond_to_user');

    double userLat = (await SessionManager.getLatitude()) ?? 0.0;
    double userLong = (await SessionManager.getLongitude()) ?? 0.0;

    var params = {
      'user_latitude': userLat.toString(),
      'user_longitude': userLong.toString(),
    };

    try {
      var response = await http.post(
        url.replace(queryParameters: params),
      );

      print('Latitude From Chat Screen: $userLat');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody['error'] != null) {
          print('Error: ${responseBody['error']}');
        } else {
          List<dynamic> hospitals = responseBody['hospitals'];

          String prediction = (await SessionManager.getPrediction()) ?? '';
          Global.latestPrediction = prediction;

          updateChatScreenWithPrediction(prediction);
          updateChatScreenWithHospitals(hospitals);

          setState(() {
            predictionAndHospitalsFetched = true;
          });
        }
      } else {
        print('Failed to get response. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  //marina
  @override
  void initState() {
    super.initState();
    // loadChatHistory();
    // AudioApi.initRecorder();
    // fetchPredictionAndHospitals(); // Fetch data from the server
  }

  @override
  void dispose() {
    // AudioApi.closeRecorder();
    _messageController.dispose();
    super.dispose();
  }

  void loadChatHistory() async {
    try {
      final myState = Provider.of<MyState>(context, listen: false);
      String userId = myState.userId;
      List<ChatMessage> fetchedMessages =
          await fetchChatHistory(userId, '1'); // Receiver ID set to 1
      setState(() {
        messages = fetchedMessages;
      });
    } catch (e) {
      print("Failed to load chat history: $e");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!introMessageShown) {
      updateChatScreenWithIntro();
      introMessageShown = true;
      fetchPredictionAndHospitals();
    }

    // if (messages.isEmpty && !introMessageShown) {
    //   updateChatScreenWithIntro();
    //   introMessageShown = true;

    //   fetchPredictionAndHospitals();
    // }

    // // Add the burn prediction message if available
    // if (Global.latestPrediction.isNotEmpty) {
    //   updateChatScreenWithPrediction(Global.latestPrediction);
    // }
  }

  void _toggleRecording() async {
    if (_isRecording) {
      final path = await _recorder.stopRecorder();
      if (path != null) {
        setState(() {
          messages.add(ChatMessage(
              message: 'New audio message',
              receiver: false,
              timestamp: DateTime.now(),
              senderId: Global.user_id,
              receiverId: '1'));
        });
      }
      setState(() {
        _isRecording = false;
      });
    } else {
      await _recorder.startRecorder(toFile: 'audio_message.aac');
      setState(() {
        _isRecording = true;
      });
    }
  }

  void _sendMessage() {
    final myState = Provider.of<MyState>(context, listen: false);
    String userId = myState.userId;

    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      final message = ChatMessage(
          message: text,
          receiver: true,
          image: null,
          timestamp: DateTime.now(),
          senderId: userId,
          receiverId: '1');

      // Send the message to the server
      sendMessageToServer(message);

      setState(() {
        messages.add(message);
        _messageController.clear();
      });
    } else
      print('message is empty');
  }

  // Function to (Sara)
  void updateChatScreenWithIntro() {
    final myState = Provider.of<MyState>(context, listen: false);
    String userId = myState.userId;

    setState(() {
      messages.add(ChatMessage(
          message: S.of(context).Intro,
          receiver: false,
          timestamp: DateTime.now(),
          // senderId: userId, (Sara)
          senderId: '0',
          receiverId: '1'));
    });
  }

  // Function to display the initial message from the model (Model Prediction & the Treatment Protocol)
  void updateChatScreenWithPrediction(String prediction) {
    final myState = Provider.of<MyState>(context, listen: false);
    String userId = myState.userId;

    setState(() {
      messages.add(ChatMessage(
          message:
              'Your Burn Degree is $prediction. I advise you to use bla bla bla', // Modify the advice as needed
          receiver: false,
          // senderId: userId, (Sara)
          senderId: '0',
          receiverId: '1',
          timestamp: DateTime.now()));
    });
  }

  // Update chat screen with the list of nearest hospitals (Sara)
  void updateChatScreenWithHospitals(List<dynamic> hospitals) {
    final myState = Provider.of<MyState>(context, listen: false);
    String userId = myState.userId;

    setState(() {
      for (var i = 0; i < 5 && i < hospitals.length; i++) {
        var hospital = hospitals[i];
        var hospitalMessage =
            '${hospital['english_name']} - ${hospital['arabic_name']}';
        var mapsLink =
            'https://www.google.com/maps/search/?api=1&query=${hospital['lat']},${hospital['lon']}';
            print('URL $i $mapsLink');

        messages.add(ChatMessage(
            message: '$hospitalMessage\n[View on Maps]($mapsLink)',
            receiver: false,
            senderId: '0',
            receiverId: '1',
            timestamp: DateTime.now()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LocalizationIcon(),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final chatMessage = messages[index];

              // Render the text message as usual
              return MessagesWidget(
                chatMessage: chatMessage,
                introMessage: null,
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.only(left: 16, bottom: 10, right: 16),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 106, 105, 105),
                ),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      enableSuggestions: true,
                      decoration:
                          InputDecoration(hintText: S.of(context).message),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(
                        Icons.send,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




//   @override
//   Widget build(BuildContext context) {
//     final userId = Provider.of<MyState>(context, listen: false).userId;

//     return Scaffold(
//         appBar: const LocalizationIcon(),
//         body: Stack(
//           children: [
//             ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final chatMessage = messages[index];
//                 if (chatMessage.message != null) {
//                   // If there's an audio URL, display both the audio player and the message text.
//                   return Column(
//                     children: [
//                       ListTile(
//                         title: chatMessage.message.contains('View on Maps')
//                             ? RichText(
//                                 text: TextSpan(
//                                   children: [
//                                     TextSpan(
//                                       text: chatMessage.message.split(
//                                           '\n')[0], // Display hospital name
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                     TextSpan(
//                                       text: '\nView on Maps',
//                                       style: TextStyle(
//                                         color: Colors.blue,
//                                         decoration: TextDecoration.underline,
//                                       ),
//                                       recognizer: TapGestureRecognizer()
//                                         ..onTap = () {
//                                           launch(chatMessage.message
//                                                   .split('\n')[1]
//                                                   .split('(')[1]
//                                                   .split(')')[
//                                               0]); // Open link in browser
//                                         },
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : Text(chatMessage.message),
//                         subtitle: Text(chatMessage.receiver ?? false
//                             ? "Patient"
//                             : "Doctor"), // Displaying text message if available
//                       ),
//                       // Padding(
//                       // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                       // child: AudioPlayerWidget(audioPath: chatMessage.audioUrl!),
//                       // ),
//                     ],
//                   );
//                 } else {
//                   // Otherwise, render the text message as usual
//                   return MessagesWidget(
//                     chatMessage: chatMessage,
//                     introMessage: null,
//                   );
//                 }
//               },
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   padding:
//                       const EdgeInsets.only(left: 16, bottom: 10, right: 16),
//                   height: 60,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: const Color.fromARGB(255, 106, 105, 105),
//                   ),
//                   child: Row(children: [
//                     IconButton(
//                       icon: Icon(_isRecording ? Icons.stop : Icons.mic),
//                       onPressed: _toggleRecording,
//                       color: _isRecording
//                           ? Colors.red
//                           : Color.fromARGB(255, 10, 15, 153),
//                     ),
//                     Expanded(
//                       child: TextField(
//                         controller: _messageController,
//                         textCapitalization: TextCapitalization.sentences,
//                         autocorrect: true,
//                         enableSuggestions: true,
//                         decoration:
//                             InputDecoration(hintText: S.of(context).message),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10),
//                       child: IconButton(
//                         onPressed: _sendMessage,
//                         icon: const Icon(
//                           Icons.send,
//                         ),
//                       ),
//                     ),
//                   ]),
//                 ),
//               ),
//             ),
//           ],
//         ));
//   }
// }
